# Demo prompts — heart-vb v0.9.x

**Cel:** progresywne demo z managerem/analitykiem żeby zobaczyć plugin w akcji. 10 promptów w 5 fazach, ~60-90 min. Pisane pod **Cowork** (główne środowisko zespołu); różnice CLI/IDE zaznaczone.

> ⚠️ **Reality check (v0.9.x):** W Coworku **NIE ma bannerów hooków** (💡/🔧/🎚️) — to był stary mechanizm (UserPromptSubmit hooki), usunięty, i tak nie odpala się w sandboxie. Dziś skille **routują się natywnie z opisów**, a consent/briefing/cross-check to zachowanie wbudowane w treść skilli (🔒 CORE). W CLI/IDE dochodzi tylko SessionStart context injection przy starcie.

**Pre-demo checklist:**
- [ ] heart-vb zainstalowany (Cowork: Customize → Personal plugins → **"+"** → Create plugin → Add marketplace → `The-Heart-Vibe/the-heart-marketplace` → install · CLI: `/plugin install heart-vb@the-heart-marketplace`)
- [ ] **Tier 0 (baseline) — wystarcza do większości demo:** nic więcej nie trzeba, skille działają, cross-check = emulated single-model
- [ ] **Tier 1 (dla prawdziwego Pattern F — prompty 7-8, 10):** w terminalu raz `install.sh` (gemini-cli + `gemini` login) **+ Desktop Commander podłączony w Coworku**. Bez tego cross-check leci jako emulated (oznaczony) — demo nadal działa, tylko bez realnego 3-LLM.
- [ ] `/heart-status` → sprawdź środowisko, wersję, Pattern F readiness (gemini/codex/DC)
- [ ] User wie o opt-out: `BEZ PYTANIA:` (skip consent), `BEZ COWORK:` (skip orkiestracji)

**Co obserwować w trakcie demo:**
- Czy **właściwy skill się ładuje** (panel Skills po prawej w Coworku pokazuje np. `napkin-math`)
- Czy Claude pyta o zgodę **plain language** (NIE "Pattern E/F", NIE żargon)
- Czy output jest **briefing-style** (~150-300 słów) vs research dump
- Czy przy liczbach-do-VC pada **oferta cross-checku**
- Czy przy nowym milestone trzeba **wywołać skill jawnie** (coasting — patrz cowork-usage)

---

## FAZA 1 — Baseline (zero orkiestracji, ~10 min)

### Prompt 1: Trivial lookup
```
Co znaczy ARPU w SaaS metrykach? 1 zdanie wystarczy.
```
**Expected:** solo Claude, ~3s, **bez** consent question. Żaden skill się nie ładuje.
**Co pokazuje:** plugin NIE dodaje frykcji do trivial pytań.

---

### Prompt 2: Single sector lookup
```
Wyjaśnij prosto różnicę między MDR Class IIa a IIb dla SaaS medycznego. Max 4 zdania.
```
**Expected:** Claude może załadować `heart-healthtech-compliance` (sektor HealthTech wykryty z opisu) albo odpowiedzieć z wiedzy. Krótki structured output.
**Co pokazuje:** sector-awareness bez ciężkiej orkiestracji.

---

## FAZA 2 — Heart skills auto-routing (~15 min)

### Prompt 3: DD checklist (academic + HealthTech)
```
Wygeneruj DD checklist dla academic spinout z IBB PAN — venture: AI-powered biomarker discovery dla early-stage cancer detection (HealthTech).
Stage: PoC z 50 pacjentami WUM, looking for €800k seed.
Profesor jako CSO 50% FTE, brak commercial CEO.
```
**Expected:** ładuje `heart-dd-checklist` (+ kontekst `heart-academic-spinouts` / `heart-healthtech-compliance`). Output: structured checklist z priority markers + sector-specific MDR/IRB/IP. Bez consent dialog (pojedynczy skill).
**Co pokazuje:** pojedynczy skill → praktyczny artifact, sector-aware.

---

### Prompt 4: Pitch deck (BESS energy)
```
Napisz 10-slide pitch deck outline dla "GridFlex" — BESS Storage-as-a-Service
dla industrial peak shaving w PL. Stage: pilot z 1 zakładem CCS, ARR €120k.
Target: €2M Series A. Konkurencja: Northvolt, kilka mniejszych integratorów.
```
**Expected:** ładuje `heart-pitch-deck` (+ `heart-energy`). 10-12 slide outline z capacity market, EU Battery Reg, BESS biz model. **Obserwuj:** czy na slajdach z liczbami (ARR, multiple, market) pada oferta cross-checku przed wysłaniem do VC.
**Co pokazuje:** deck-ready artifact dopasowany do sektora portfolio.

> **Coasting watch:** jeśli po Prompt 3→4 panel Skills wciąż pokazuje tylko pierwszy skill — to znany efekt. Wywołaj jawnie `/heart-vb:heart-pitch-deck` żeby załadować pełną metodykę.

---

## FAZA 3 — Decyzja z konsultacją 3 ekspertów (~20 min)

### Prompt 5: Pricing decision HealthTech
```
Pricing dla HealthTech SaaS B2B sprzedawanego do polskich przychodni:
A) Tier €99/€299/€999 per practice/mo
B) Flat €2500/rok per practice
Target ARR: €500k w 24mc, sales cycle 6-9 mc, decision-maker: zarząd przychodni.
Co wybrać?
```
**Expected (KEY MOMENT — KROK -1 consent w plain language):**
> *"To wygląda na decyzję wartą konsultacji z kilkoma ekspertami. Mogę zapytać 3 ekspertów (pricing analyst / growth lead / VP product), ~60s. (a) Tak (b) Tylko Ty (c) Sam wiem."*

Manager: "a" → spawn 3 agentów (Wojtek-personas) parallel → briefing synthesis (~150 słów): rekomendacja + verify points + bottom line.
**Co pokazuje:** explicit consent (NIE spawnuje bez yes), plain language, multi-perspektywa, krótki actionable output. Easter egg: "Wojtek (pricing analyst) says...".

---

### Prompt 6: Build vs partner
```
Czy budować AI-powered contract review SaaS dla polskich kancelarii czy partnerować z istniejącym US vendorem (Harvey, Spellbook)?
Stage: idea, mamy €200k pre-MVP budget i 3-osobowy team (2 dev + 1 sales).
```
**Expected:** KROK -1 consent → 3 persony **dobrane do typu decyzji** (founder-skeptic / strategic / financial), nie statyczny zestaw. Synthesis: clear path + risks.
**Co pokazuje:** persony adekwatne do decyzji; Claude dobiera różnych ekspertów dla pricing vs build/buy.

---

## FAZA 4 — Research z cross-check 3 AI (~20 min · wymaga Tier 1: gemini+DC)

> Jeśli brak gemini/DC → Claude zrobi **emulated single-model** z jawnym tagiem "⚠️ jeden model, bez cross-checku". Demo nadal pokazuje flow, tylko bez realnego 3-LLM.

### Prompt 7: NCBR funding facts
```
Jakie są aktualne wymagania NCBR Szybka Ścieżka dla deep tech spinouts w 2026?
Konkretnie: maks kwota grantu, maks długość projektu, minimum własności IP przez aplikanta, czy wymaga partner przemysłowy.
```
**Expected:** KROK -1 consent (research/fakty):
> *"To wygląda na pytanie faktualne. Mogę zweryfikować przez 3 niezależne AI (Claude + Gemini + GPT-5, każdy grounded w sieci), ~90s. (a) Tak (b) Z mojej wiedzy (c) Sam zweryfikuję."*

Po "a": cross-check (gemini przez Desktop Commander na hoście + Claude WebSearch). Synthesis: konkretne liczby + "sprawdzone przez X z 3 modeli" + **primary source** (NCBR oficjalne) + verify points dla rozbieżności.
**Co pokazuje:** cross-LLM verification + grounding obu modeli + "consensus ≠ prawda, podaj źródło".

---

### Prompt 8: Energy regulatory (cross-vertical)
```
Co MUSZĘ wiedzieć przed wejściem na polski rynek energetyczny z EnergyTech SaaS (forecasting + EMS) dla OZE wytwórców i DSO:
- RED III RFNBO targets — kto i kiedy raportuje
- TGE day-ahead/intraday: czy SaaS wymaga licencji URE
- Capacity market 2026: rules dla DR aggregators
- CSRD scope w PL (próg pracownicy/przychody)
```
**Expected:** research + `heart-energy` context → cross-check. Synthesis: high-confidence facts vs flagged dla EUR-Lex/URE verify, z primary sources.
**Co pokazuje:** realna wartość cross-checku dla regulacji (daty/procenty hallucination-prone) + szeroki scope heart-energy. **Scope guard:** dla venture spoza PL/EU plugin flaguje inny reżim, nie ekstrapoluje.

---

## FAZA 5 — Edge cases (~10 min)

### Prompt 9: Opt-out
```
BEZ COWORK: szybko podsumuj 3 główne różnice między PSE jako TSO a PGE jako utility. Max 5 zdań.
```
**Expected:** prefix `BEZ COWORK:` → zero propozycji orkiestracji mimo multi-entity. Solo Claude ~10s.
**Co pokazuje:** user retains control — opt-out per-prompt.

---

### Prompt 10: Multi-signal stress test
```
Porównaj 5 polskich konkurentów na rynku AI-powered EHR dla szpitali. Sprawdź ich pricing na https://www.g2.com/categories/electronic-medical-records-emr-software i https://www.capterra.com/p/category/ehr/. Tabela: feature set, pricing tier, target ICP, integracje z systemem P1.
```
**Expected:** złożone zadanie (research + HealthTech + 5 entities + 2 URL). Claude proponuje plan (competitive-teardown + ewentualny cross-check). Dla stron JS-heavy: chrome-devtools-mcp jeśli podłączony (taniej niż N×WebFetch), inaczej WebFetch.
**Co pokazuje:** koordynacja złożonego zadania bez crash; token-efficient browsing gdy dostępny.

---

## Follow-up — pytania do managera po demo

| Pytanie | Co wyciągnąć |
|---|---|
| "Które prompty czuły się najbardziej naturalne?" | Adoption barriers |
| "Czy explicit consent (KROK -1) jest blocking czy welcome?" | UX preference |
| "Czy briefing ~150 słów wystarcza, czy chcesz więcej szczegółu?" | Output calibration |
| "Czy cross-check (3 AI) jest wart setupu (gemini+DC), czy emulated wystarcza?" | Tier 1 vs Tier 0 |
| "Dla których teammate'ów to **NIE** zadziała?" | Persona segmentation |

---

## Troubleshooting podczas demo

| Symptom | Quick fix |
|---|---|
| Plugin nie wykryty | `/heart-status`. Cowork: Customize → Personal plugins → + → Add marketplace. CLI: `/plugin install ...` |
| Panel Skills pokazuje tylko 1 skill mimo wielu kroków | Coasting — wywołaj kolejny skill jawnie (`/heart-vb:<skill>`) lub świeża sesja per milestone |
| Cross-check leci jako "emulated single-model" | Brak gemini na hoście lub DC niepodłączony (Tier 1). OK dla demo — to honest fallback |
| `gemini` MISSING mimo instalacji | OAuth wygasł → `gemini` w terminalu, re-login. Lub gemini w PATH niewidocznym dla DC |
| Output żargonem ("pass"/"Voices"/"Pattern F") | Issue — 🔒 CORE rule #1 mówi prosty polski; zgłoś |
| Claude pyta "Pattern E?" zamiast plain language | Issue — consent ma być w języku biznesowym |

---

## Quick reference — co plugin daje

| Kategoria | Skille/agenci | Trigger |
|---|---|---|
| **Decyzje** | konsultacja 3 ekspertów (heart-orchestrate) | "vs", "co wybrać", "build/buy" |
| **Research/fakty** | cross-check (Pattern F, wymaga gemini+DC) | "TAM", "regulacja", "ile wynosi" |
| **Modeling** | financial-analyst, saas-metrics-coach, napkin-math | "CAC", "LTV", "DCF", "czy się spina" |
| **Writing** | board-prep, heart-pitch-deck, investor-materials | "IC memo", "pitch deck", "update" |
| **Screening** | deal-desk, heart-dd-checklist, heart-dd-prep | "fit?", "founder", "DD" |
| **Sectors** | heart-{healthtech/academic/energy/fintech} | sector keywords (PL/EU scope) |
| **Advisor** | heart-advisor (brutalna szczerość + quality check) | "bądź szczery", "oceń jakość" |
| **Proces** | /heart-vb-process (12 milestones), assessment, kickoff | "kickoff", "gdzie stoimy" |

---

**Last update:** 2026-06-08 (v0.9.x — refresh: native skill routing, Pattern F via Desktop Commander, locked CORE, accurate Cowork install)
