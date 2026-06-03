#!/usr/bin/env bash
# UserPromptSubmit hook: detects venture-builder intent and suggests
# the most relevant skill(s) — not just /council.
#
# Activation: only fires on prompts matching VB signal patterns.
# Output: appends additionalContext instructing Claude to ASK the user
# whether to route through the suggested skill before answering directly.
#
# Auto-loaded od v0.6.10 przez hooks/hooks.json w pluginie (Claude Code v2.1+ convention).
# Disable globally: /plugin uninstall heart-vb lub edit hooks/hooks.json w plugin dir.
# Override per-prompt: prefix with "BEZ COUNCIL:" / "NO COUNCIL:" / "SKIP VB:" / "BEZ PYTANIA:"

set -euo pipefail

INPUT="$(cat)"

PROMPT="$(printf '%s' "$INPUT" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get("prompt", data.get("user_prompt", "")))
except Exception:
    print("")
' 2>/dev/null || printf '')"

# Bail conditions
if [ -z "$PROMPT" ]; then exit 0; fi
if [ "${#PROMPT}" -lt 40 ]; then exit 0; fi
if printf '%s' "$PROMPT" | grep -qiE '^(bez\s*council|no\s*council|skip\s*council|skip\s*vb|bez\s*pytania|skip\s*consent|just\s*do)[: ]'; then exit 0; fi
if printf '%s' "$PROMPT" | grep -qE '^\s*/[a-z]'; then exit 0; fi  # any slash command

# ── Intent detection — match per category ────────────────────────────────────

match_count() {
  local prompt="$1"; shift
  local count=0
  for pat in "$@"; do
    if printf '%s' "$prompt" | grep -qiE "$pat"; then
      count=$((count + 1))
    fi
  done
  printf '%s' "$count"
}

# DECISION intent — multi-option choices, comparisons, build-vs-buy
DECISION_PAT=(
  '\b(versus|vs\.?)\b'
  '\b(co (wybrać|wybierzemy|wybieramy|lepiej|lepsze))\b'
  '\b(który (lepsz|wybrać))\b'
  '\b(czy (warto|powinniśmy))\b'
  '\b(build[- ]vs[- ]buy|build or buy)\b'
  '\b(pivot(ujem|ować)|go[/ ]no[- ]?go|fit[/ ]no[- ]?fit)\b'
  '\b(porównaj|porównanie|oceń|zdecyduj|decyzj)\b'
)

# RESEARCH intent — market, competitors, sizing, exploration
RESEARCH_PAT=(
  '\b(TAM|SAM|SOM|sizing rynku|rozmiar rynku|market size)\b'
  '\b(konkurent|competitor|landscape|teardown)\b'
  '\b(research|zbadaj|przeanalizuj|find out|deep[- ]dive)\b'
  '\b(jakie firmy|kto już|kto robi)\b'
)

# MODELING intent — financial models, unit econ, valuation
MODELING_PAT=(
  '\b(unit econom|CAC|LTV|payback|churn|MRR|ARR|ARPU)\b'
  '\b(DCF|WACC|comps|valuation|wycena|MOIC|IRR|breakeven)\b'
  '\b(P&L|cash[- ]?flow|3-statement|projekcj)\b'
  '\b(model finansowy|projekt budżetu)\b'
)

# WRITING intent — IC memo, pitch deck, investor materials
WRITING_PAT=(
  '\b(IC[-_ ]?memo|investment[- ]committee|term[- ]?sheet)\b'
  '\b(pitch[- ]deck|deck inwestorski|one[- ]pager|teaser|data[- ]?room)\b'
  '\b(napisz|zredaguj|wygeneruj|sporządź)\b.*\b(memo|deck|pitch|brief|spec|update|raport|prd|prezentacj)\b'
  '\b(stakeholder update|investor update)\b'
)

# VALIDATION intent — user research, experiments
VALIDATION_PAT=(
  '\b(JTBD|jobs[- ]to[- ]be[- ]done|persona|user research)\b'
  '\b(interview|wywiad z|talk to user)\b'
  '\b(experiment|smoke test|fake[- ]door|fake door|MVP)\b'
  '\b(zwaliduj|validate|hypothesis|hipotez)\b'
)

# SCREENING intent — incoming opportunity / founder / research fit
SCREENING_PAT=(
  '\b(founder fit|founder profile|założyciel)\b'
  '\b(profesor|naukowiec|patent|spin[- ]?out|commercializ|tech[- ]?transfer)\b'
  '\b(fit dla|dla nas|incoming|opportunity|inquiry)\b'
  '\b(DD checklist|due[- ]diligence|deal screen)\b'
)

# PRICING intent (special — usually triggers council + benchmarks)
PRICING_PAT=(
  '\b(pricing|cennik|tier|freemium|paid tier|enterprise tier)\b'
  '\b(price (point|elasticity)|monetiz)\b'
)

# MILESTONE intent — DD by Heart vocabulary (M1-M12)
# Wykrywa konkretne milestone z procesu VB i deleguje do heart-vb-process
# master orchestrator (który dalej routuje do sub-skill per milestone).
# Priorytet: wyższy niż generic intents bo bardziej specific.
MILESTONE_PAT=(
  # Workflow-level keywords (heart-vb-process / assessment / kickoff)
  '\b(DD by Heart|12 milestones|stempel The Heart|stempel TH|venture building proces|VB proces)\b'
  '\b(kickoff projektu|kick[- ]off projektu|assessment projektu|audyt projektu|gdzie stoimy)\b'
  '\b(ile milestones (done|zrobionych)|risk ranking|sprint planning|bi[- ]weekly summary|fundraising readiness)\b'
  '\b(przepu(ść|sc)\s+projekt|cały proces|full process|pełen pipeline)\b'
  # M1 — Analiza rynku
  '\b(TAM|SAM|SOM|sizing rynku|rozmiar rynku|trendy rynkowe|wzrost YoY|slajd Market)\b'
  # M2 — Konkurencja (covered by RESEARCH_PAT też, ale tutaj milestone-specific)
  '\b(competitive landscape|5-10 konkurent|defensible advantage)\b'
  # M3 — Walidacja z inwestorami (early signal)
  '\b(early signal|walidacja z inwestor|reality check z inwest|2-3 rozmowy z VC)\b'
  # M4 — Walidacja problemu
  '\b(walidacja problemu|10-20 rozm[ow]w|segmentacja klient|problem confirmed)\b'
  # M5 — Napkin math
  '\b(napkin math|napkin|1-stronicowy|czy to się spina|unit econ na kartce|break[- ]even szybko)\b'
  # M6 — Exit strategy & acquirers
  '\b(exit strategy|kto to kupi|potencjalni acquirers|comparable exits|mnożniki przy sprzedaży|exit narrative)\b'
  # M7 — Zespół & cap table
  '\b(cap table|equity split|ESOP planning|advisory agreement|spółka założona)\b'
  # M8 — MVP / produkt & roadmapa (covered by VALIDATION/PRODUCT)
  '\b(MVP|prototyp|roadmapa produktowa|demo dla klienta|6-18 miesi)\b'
  # M9 — Walidacja rozwiązania & pricing (overlap z PRICING)
  '\b(LOI|letter of intent|pilot agreement|willingness to pay|5 walidacji)\b'
  # M10 — IP/regulacje/prawo
  '\b(IP ownership|regulatory path|ścieżka regulacyjna|legal red flag|CE\\/FDA|MDR|MIFID|AMLD)\b'
  # M11 — Materiały fundraisingowe (covered by WRITING_PAT)
  '\b(data room|pitch deck iterowany|pełen model finansowy|3-statement P\\&L)\b'
  # M12 — Lista inwestorów & outreach
  '\b(lista inwestor|outreach plan|target inwestor|intro do funduszy|CRM funduszy)\b'
)

# BRAINSTORM intent — generic exploratory tasks bez clear VB context
# (organizacja eventu, struktura spotkania, ad-hoc decyzja, draft komunikacji,
#  refleksja strategiczna). Fall-through gdy żaden inny intent nie pasuje.
BRAINSTORM_PAT=(
  '\b(pomyśl|pomysl) ze mną\b'
  '\b(pomóż|pomoz) mi (z|ułożyć|ulozyc|zaplanować|zaplanowac|przemyśleć|przemysl|wymyślić|wymyslic|ogarn)\b'
  '\b(jak (ułożyć|ulozyc|zorganiz|zaplanować|zaplanowac|podejść|podejsc|ugryźć|ugryzc|ogarn|napisać|napisac))\b'
  '\b(co (napisać|napisac|odpowiedzieć|odpowiedziec)) (.*do|.*na)\b'
  '\b(nie wiem (jak|od czego))\b'
  '\b(mam (pomysł|pomysl|ideę|idee).*(pomóż|pomoz|ułóż|uloz))\b'
  '\b(agenda spotkania|struktura warsztatu|format eventu|plan retreat)\b'
  '\b(brainstorm|burza mózgów|burza mozgow|przemyśl|przemysl|pomyślmy|pomyslmy|przemyślmy|przemyslmy|rozważmy|rozwazmy) (razem|sobie|nad|o)\b'
  '\b(brainstorm|burza mózgów|burza mozgow)\b'
  '\b(zorganiz(uj|ować|owac) (mi|spotkanie|warsztaty|event|retreat))\b'
)

# SECTOR hints — adds context, doesn't trigger alone
# Heart portfolio focus: HealthTech, Academic spinouts, Energy storage, FinTech (legacy)
SECTOR_PAT=(
  '\b(FinTech|HealthTech|CleanTech|EnergyTech|energ(ia|etyk|ii)|magazyn(y)? energii|BESS|V2G|fotowoltaik|PV|wiatr|offshore wind|nuclear|SMR|OZE|elektrolizer|wodór|H2|electrolyzer|hydrogen|heat pump|pompa ciepła|biogaz|biogas|ciepłownict|district heating)\b'
  '\b(academic spinout|spin[- ]?out|tech transfer|uczelni|profesor|PAN|NCBR|NCN|patent|IP commercializ)\b'
  '\b(KNF|RODO|AMLD|MDR|NFZ|MIFID|PSD2|EU Battery|CSRD|EU Taxonomy|RED III|EU ETS|EPBD|Fit-for-55|CBAM)\b'
  '\b(bank|przychodni|klinika|szpital|PSE|TSO|DSO|PGE|Tauron|Enea|Energa|URE|TGE|Orlen|KGHM|CPO|EMSP|ładowarka|charger|charging)\b'
)

DEC_HITS=$(match_count "$PROMPT" "${DECISION_PAT[@]}")
RES_HITS=$(match_count "$PROMPT" "${RESEARCH_PAT[@]}")
MOD_HITS=$(match_count "$PROMPT" "${MODELING_PAT[@]}")
WRT_HITS=$(match_count "$PROMPT" "${WRITING_PAT[@]}")
VAL_HITS=$(match_count "$PROMPT" "${VALIDATION_PAT[@]}")
SCR_HITS=$(match_count "$PROMPT" "${SCREENING_PAT[@]}")
PRI_HITS=$(match_count "$PROMPT" "${PRICING_PAT[@]}")
SEC_HITS=$(match_count "$PROMPT" "${SECTOR_PAT[@]}")
BRN_HITS=$(match_count "$PROMPT" "${BRAINSTORM_PAT[@]}")
MIL_HITS=$(match_count "$PROMPT" "${MILESTONE_PAT[@]}")

TOTAL=$((DEC_HITS + RES_HITS + MOD_HITS + WRT_HITS + VAL_HITS + SCR_HITS + PRI_HITS + MIL_HITS))

# Trigger threshold
# Brainstorming jest fall-through: fire'uje gdy BRAINSTORM_PAT match a żaden VB intent nie złapał
if [ "$TOTAL" -lt 1 ] && [ "$BRN_HITS" -lt 1 ]; then exit 0; fi
if [ "$TOTAL" -eq 1 ] && [ "$SEC_HITS" -eq 0 ] && [ "$BRN_HITS" -eq 0 ] && [ "$MIL_HITS" -eq 0 ]; then exit 0; fi  # single weak signal — skip

# ── Determine primary intent (highest hit count) ─────────────────────────────

# MILESTONE intent ma najwyższy priorytet — to jest DD by Heart vocabulary
# (specyficzne keywords procesu VB → bezpośredni routing do heart-vb-process)
if [ "$MIL_HITS" -ge 1 ]; then
  PRIMARY="milestone"
  PRIMARY_HITS=$MIL_HITS
# Fall-through to brainstorming gdy żaden VB intent nie złapał (TOTAL=0 bez MIL) ale BRAINSTORM_PAT match
elif [ "$TOTAL" -eq 0 ] && [ "$BRN_HITS" -ge 1 ]; then
  PRIMARY="brainstorm"
  PRIMARY_HITS=$BRN_HITS
else
  PRIMARY="decision"
  PRIMARY_HITS=$DEC_HITS

  if [ "$RES_HITS" -gt "$PRIMARY_HITS" ]; then PRIMARY="research"; PRIMARY_HITS=$RES_HITS; fi
  if [ "$MOD_HITS" -gt "$PRIMARY_HITS" ]; then PRIMARY="modeling"; PRIMARY_HITS=$MOD_HITS; fi
  if [ "$WRT_HITS" -gt "$PRIMARY_HITS" ]; then PRIMARY="writing"; PRIMARY_HITS=$WRT_HITS; fi
  if [ "$VAL_HITS" -gt "$PRIMARY_HITS" ]; then PRIMARY="validation"; PRIMARY_HITS=$VAL_HITS; fi
  if [ "$SCR_HITS" -gt "$PRIMARY_HITS" ]; then PRIMARY="screening"; PRIMARY_HITS=$SCR_HITS; fi
fi

# Wykryj konkretny milestone (M1-M12) z prompta dla lepszego routing
DETECTED_MILESTONE=""
if [ "$MIL_HITS" -ge 1 ]; then
  if printf '%s' "$PROMPT" | grep -qiE 'TAM|SAM|SOM|rozmiar rynku|trendy rynkowe|slajd Market'; then
    DETECTED_MILESTONE="M1 (Analiza rynku)"
  elif printf '%s' "$PROMPT" | grep -qiE 'competitive landscape|defensible advantage|5-10 konkurent'; then
    DETECTED_MILESTONE="M2 (Analiza konkurencji)"
  elif printf '%s' "$PROMPT" | grep -qiE 'early signal|walidacja z inwestor|2-3 rozmowy z VC'; then
    DETECTED_MILESTONE="M3 (Early signal z inwestorami)"
  elif printf '%s' "$PROMPT" | grep -qiE 'walidacja problemu|10-20 rozm|segmentacja klient'; then
    DETECTED_MILESTONE="M4 (Walidacja problemu z klientami)"
  elif printf '%s' "$PROMPT" | grep -qiE 'napkin math|czy to się spina|unit econ na kartce'; then
    DETECTED_MILESTONE="M5 (Napkin math)"
  elif printf '%s' "$PROMPT" | grep -qiE 'exit strategy|kto to kupi|acquirers|comparable exits|mnożniki'; then
    DETECTED_MILESTONE="M6 (Exit strategy & acquirers)"
  elif printf '%s' "$PROMPT" | grep -qiE 'cap table|equity split|ESOP|spółka założ'; then
    DETECTED_MILESTONE="M7 (Zespół & cap table)"
  elif printf '%s' "$PROMPT" | grep -qiE 'MVP|prototyp|roadmapa produktowa|demo dla klient'; then
    DETECTED_MILESTONE="M8 (MVP & roadmapa)"
  elif printf '%s' "$PROMPT" | grep -qiE 'LOI|letter of intent|pilot agreement|willingness to pay'; then
    DETECTED_MILESTONE="M9 (Walidacja rozwiązania & pricing)"
  elif printf '%s' "$PROMPT" | grep -qiE 'regulatory path|ścieżka regulacyjna|legal red flag|CE\/FDA|MDR|MIFID'; then
    DETECTED_MILESTONE="M10 (IP, regulacje & prawo)"
  elif printf '%s' "$PROMPT" | grep -qiE 'data room|pitch deck iterowany|pełen model finansowy|3-statement'; then
    DETECTED_MILESTONE="M11 (Materiały fundraisingowe)"
  elif printf '%s' "$PROMPT" | grep -qiE 'lista inwestor|outreach plan|target inwestor|intro do funduszy'; then
    DETECTED_MILESTONE="M12 (Lista inwestorów & outreach)"
  elif printf '%s' "$PROMPT" | grep -qiE 'kickoff|assessment projektu|gdzie stoimy|risk ranking'; then
    DETECTED_MILESTONE="WORKFLOW (Krok 1-2: assessment + kickoff)"
  elif printf '%s' "$PROMPT" | grep -qiE 'cały proces|full process|przepu(ść|sc) projekt'; then
    DETECTED_MILESTONE="FULL PROCESS (przepuść projekt przez 12 milestones)"
  fi
fi

# ── Map intent to skill suggestions ──────────────────────────────────────────

case "$PRIMARY" in
  decision)
    SKILLS="**heart-orchestrate Pattern E** (3 cowork workers z różnymi personami pricing/growth/VP product, gemini-cli przez Bash) — judgment przez role-play divergence. Council CLI tylko z terminala (nie z CC session)."
    ;;
  research)
    SKILLS="**heart-orchestrate Pattern F** (3 workers, KAŻDY INNY LLM: Sonnet native + Gemini + Codex z `codex exec --skip-git-repo-check`) — fact verification przez cross-LLM divergence; wykrywa hallucinacje pojedynczego modelu. Lub samo **deep-research**/**market-research** dla single-source research, **exa-search** token-efficient, **chrome-devtools-mcp** dla multi-page browser."
    ;;
  modeling)
    SKILLS="**saas-metrics-coach** (CAC/LTV/payback/churn/unit econ) lub **financial-analyst** (P&L + 3-statement + DCF). Dla interpretacji wyników: heart-orchestrate Pattern E z personami (CFO/pricing analyst/VP product)."
    ;;
  writing)
    SKILLS="**board-prep** (IC memo), **heart-pitch-deck** (10-12 slide deck), **investor-materials** (one-pagery), **heart-stakeholder-update** (weekly/monthly update). Dla multi-section deliverables: heart-orchestrate Pattern E (1 persona per sekcja)."
    ;;
  validation)
    SKILLS="**product-discovery** (JTBD), **experiment-designer** (smoke test / fake door), **ux-researcher-designer** (interview plan + synthesis). Dla simulacji stakeholderów: heart-orchestrate Pattern E (różne user personas)."
    ;;
  screening)
    SKILLS="**deal-desk** (quick fit/no-fit), **heart-dd-checklist** (sector-aware DD), **heart-dd-prep** (one-page DD case dla IC). Dla founder fit assessment: heart-orchestrate Pattern E (VC partner + operator + skeptic personas)."
    ;;
  brainstorm)
    SKILLS="**brainstorming** — generic thinking partner dla non-VB tasków bez precyzyjnego kontekstu (organizacja eventu, struktura spotkania, ad-hoc decyzja personal/operacyjna, draft komunikacji). Flow: explore context → clarify questions one-at-a-time → propose 2-3 approaches → user approves → output. Po dialogu, jeśli scope się skrystalizował, transition do bardziej specyficznego skill (heart-orchestrate / board-prep / heart-pitch-deck etc.)."
    ;;
  milestone)
    SKILLS="**heart-vb-process** (master orchestrator dla DD by Heart 12 milestones framework). Detected: ${DETECTED_MILESTONE:-unspecified}. Routing: M1 Analiza rynku → market-research / M2 Konkurencja → competitive-teardown / M3 Early signal → product-discovery jako fallback / M4 Walidacja problemu → product-discovery / **M5 Napkin math → vb-process/napkin-math** ⭐ / **M6 Exit strategy → vb-process/exit-strategy** ⭐ / M7 Cap table → deal-desk / M8 MVP → product-strategist / M9 Pricing & LOI → pricing-strategist / M10 IP/regulacje → heart-dd-checklist + sector context / M11 Materiały → heart-pitch-deck + board-prep + financial-analyst / M12 Inwestorzy → investor-outreach. Workflow skille: **vb-process/assessment** (Krok 1 — 12-row checker), **vb-process/kickoff** (Krok 2 — risk ranking + sprints). Mode Full Process: 'przepuść projekt przez cały proces' → uruchom assessment + kickoff + per-milestone execution w kolejności risk ranking."
    ;;
esac

# Pricing usually = decision + modeling
if [ "$PRI_HITS" -ge 1 ]; then
  SKILLS="$SKILLS Bonus: **pricing-strategist** + **heart-comps-analysis** dla benchmarków valuation."
fi

# Sector hint adds compliance/context reminder for Heart portfolio sectors.
# Dla nowych sektorów (nie ujętych poniżej) — persona alone wystarczy, Pattern E w heart-orchestrate.
SECTOR_NOTE=""
if [ "$SEC_HITS" -ge 1 ]; then
  if printf '%s' "$PROMPT" | grep -qiE 'HealthTech|MDR|NFZ|RODO art.?9|medycyn|klinicz|szpital|przychodni|klinika'; then
    SECTOR_NOTE=" ⚠️ HealthTech kontekst — załącz **heart-healthtech-compliance** (MDR, RODO art. 9, IRB approval, NFZ procurement)."
  elif printf '%s' "$PROMPT" | grep -qiE 'academic spinout|spin[- ]?out|tech transfer|uczelni|profesor|PAN|NCBR|NCN|IP commercializ'; then
    SECTOR_NOTE=" ⚠️ Academic spinout kontekst — załącz **heart-academic-spinouts** (IP ownership, NCBR/NCN funding paths, cooperation models z profesorami)."
  elif printf '%s' "$PROMPT" | grep -qiE 'energ(ia|etyk|ii)|magazyn(y)? energii|BESS|V2G|PSE|TSO|DSO|URE|TGE|fotowoltaik|PV|wiatr|offshore wind|nuclear|SMR|OZE|elektrolizer|wodór|H2|hydrogen|heat pump|pompa ciepła|ciepłownict|district heating|ładowarka|charging|CPO|EMSP|EU Battery|RED III|EPBD|EU ETS'; then
    SECTOR_NOTE=" ⚠️ Energy kontekst — załącz **heart-energy** (generation/OZE/nuclear, T&D PSE/DSO, storage/BESS, e-mobility, H2, heat & buildings, energy services SaaS; regulator stack RED III/Battery Reg/ETS/EPBD/CSRD, funding NFOŚiGW/NCBR/EU Innovation Fund)."
  elif printf '%s' "$PROMPT" | grep -qiE 'FinTech|KNF|AMLD|MIFID|PSD2|bank'; then
    SECTOR_NOTE=" ⚠️ FinTech kontekst — załącz **heart-fintech-compliance** (KNF, AMLD6, MIFID2, PSD2, RODO, DORA)."
  fi
fi

# ── Emit hint ────────────────────────────────────────────────────────────────

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "💡 [Venture Builder hook] User's prompt matches **${PRIMARY}** intent (decision:${DEC_HITS} research:${RES_HITS} modeling:${MOD_HITS} writing:${WRT_HITS} validation:${VAL_HITS} screening:${SCR_HITS} pricing:${PRI_HITS} sector:${SEC_HITS} brainstorm:${BRN_HITS} milestone:${MIL_HITS}). Suggested skill(s): ${SKILLS}${SECTOR_NOTE} === UNIVERSAL CONSENT GATE === BEFORE invoking ANY skill or starting workflow (brainstorming, Pattern E/F, board-prep, financial-analyst, deep-research, heart-vb-process, any skill), ask user in 1-2 sentences PLAIN BUSINESS LANGUAGE (NIE 'Pattern E/F' jargon, NIE 'M5' kodu — używaj nazwy 'napkin math'). Template: 'To wygląda na [intent w plain] — proponuję [skill X / dialog / 3 ekspertów / cross-check 3 AI]. (a) tak (b) odpowiedz inline bez skill (c) sam wiem co chcę.' Wait for explicit yes. Skip consent ONLY na: trivial lookups (haiku tier, definicje, 1-line answers), single Read/Bash commands, slash commands. Opt-out per prompt: 'BEZ PYTANIA: ...' / 'BEZ COUNCIL: ...' / 'BEZ COWORK: ...'. Pełen pattern w skills/heart-custom/heart-orchestrate/SKILL.md (KROK -1 confirmation). DD by Heart 12 milestones framework opisany w skills/heart-custom/heart-vb-process/SKILL.md."
  }
}
EOF
