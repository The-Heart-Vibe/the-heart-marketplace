# Onboarding: Venture Builder toolkit w Claude Code (The Heart)

Przewodnik dla analityków i konsultantów VB w The Heart. Pokrywa instalację **całego toolkitu** (nie tylko council!) oraz jak go używać w codziennej pracy.

**Czas onboardingu:** 30-45 minut (głównie czekanie na install pluginów).

---

## Co dostajesz po onboardingu

| Faza pracy | Skille (przykłady) | Source marketplace |
|------------|---------------------|---------------------|
| **Discovery + sizing** | deep-research, market-research, competitive-teardown | everything-claude-code, product-skills |
| **Validation** | product-discovery, experiment-designer, ux-researcher-designer | product-skills |
| **Strategy decisions** | **council** ⭐ (multi-LLM debate), brainstorming, product-strategist | the-heart-vibe, superpowers, product-skills |
| **Financial modeling** | unit-economics, 3-statement-model, dcf-model, comps-analysis | private-equity, model-builder |
| **Build prep** | write-spec, landing-page-generator, saas-scaffolder | product-management, product-skills |
| **IC + pitch** | ic-memo, pitch-deck, investor-materials, stakeholder-update | private-equity, pitch-agent |
| **Token-saving** | chrome-devtools-mcp, context7-plugin, exa-search | chrome-devtools-plugins, context7-marketplace, everything-claude-code |
| **Cross-cutting** | stop-slop (anti-AI-slop), brainstorming | superpowers |

➡️ Pełna mapa skilli per faza: [venture-builder.md](venture-builder.md)

---

## 1. Załóż konta jeśli nie masz

| Konto | Po co | Link |
|-------|-------|------|
| Claude Code (Pro/Max) | Główny interfejs | https://claude.ai/code |
| ChatGPT Plus | Token-saving dla council (provider `codex`) | https://chatgpt.com |
| Google Workspace login | Token-saving dla council (provider `gemini-cli`) | (już masz przez @theheart.tech) |

> ChatGPT Plus i Workspace **nie są wymagane** dla samych skilli — wymagane tylko żeby `/council` używał alternatywnych providerów zamiast zjadać Twoją Claude Code session.

---

## 2. Dodaj marketplaces (~5 min)

Cały VB toolkit pochodzi z **3 publicznych marketplaces + naszego**. Wykonaj w Claude Code po kolei:

```
# 1. Nasz marketplace (council + ten onboarding + kolekcja)
/plugin marketplace add The-Heart-Vibe/claude-code-marketplace

# 2. Affaan Mustafa's everything-claude-code (research, market, exa-search, investor-*)
/plugin marketplace add affaan-m/everything-claude-code

# 3. Alireza Rezvani's claude-skills (product, marketing, finance, IC memo, pitch)
/plugin marketplace add alirezarezvani/claude-skills

# 4. Claude plugins official (superpowers, brainstorming, stop-slop)
/plugin marketplace add anthropics/claude-plugins
```

> Po każdej komendzie zobaczysz "✓ Added marketplace". Jeśli któryś fail — zgłoś do mnie/Wojtka, prawdopodobnie zmiana ścieżki w upstream.

---

## 3. Zainstaluj kluczowe pluginy (~10-15 min, zależy od sieci)

W Claude Code:

```
# Sercem zestawu — council (multi-LLM debate)
/plugin install council@the-heart-vibe

# Cross-cutting toolkit (research, exa-search, market analysis)
/plugin install everything-claude-code@everything-claude-code

# Product skills (discovery, competitive teardown, UX research, experiment design)
/plugin install product-skills@product-skills

# Financial + IC tools (assume hosted under finance/ in claude-skills)
/plugin install private-equity@claude-skills
/plugin install model-builder@claude-skills
/plugin install pitch-agent@claude-skills

# Quality / anti-slop
/plugin install superpowers@claude-plugins-official
/plugin install stop-slop@claude-plugins-official
```

> **Council installer zapyta:** "Zainstalować Venture Builder hook? [y/N]" — **odpowiedz `y`**. Hook pattern-matchuje Twoje wiadomości i przypomina o właściwym skillu (research → deep-research, decision → council, modeling → unit-economics itd).

> **Niektóre nazwy pluginów mogą się różnić** w upstream — jeśli `private-equity@claude-skills` nie działa, zerknij na `https://github.com/alirezarezvani/claude-skills` i znajdź odpowiednią subkatalog (`finance/`, `commercial/`).

---

## 4. Token-saving tools (~5 min)

| Plugin | Dlaczego | Komenda |
|--------|----------|---------|
| chrome-devtools-mcp | Browser session do multi-page research, znacznie tańsze niż N×WebFetch | `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` |
| context7-plugin | Bezpośredni dostęp do docs index bibliotek/API, omija drogie web search | `/plugin install context7-plugin@context7-marketplace` |

Jeśli te marketplaces nie były dodane, dodaj je:
```
/plugin marketplace add ChromeDevTools/chrome-devtools-mcp
/plugin marketplace add upstash/context7
```

---

## 5. Setup providerów dla council (opcjonalny, ale ważny)

Po install council odpal w terminalu:

```bash
council doctor
```

Zobaczysz status 3 providerów:

| Provider | Jak ustawić jeśli FAIL | Co daje |
|----------|------------------------|---------|
| `codex` | `codex login` (wymaga ChatGPT Plus) | Council używa GPT-5 zamiast Twojej Claude session |
| `gemini-cli` | `gemini` (OAuth przez Google Workspace) | Council używa Gemini, największa pula tokenów |
| `claude` | Już zalogowany | ❌ **NIE używać z poziomu Claude Code** — self-invocation block |

Jeśli odpalisz `council doctor` z poziomu Claude Code — claude będzie `FAIL`. To OK. Z terminala działa.

---

## 6. Jak to faktycznie używać

### Tryb domyślny — z hookiem (rekomendowany)

Po prostu **pisz normalnie** do Claude. Hook wykryje intent i Claude zapyta np.:

> *"To wygląda na zadanie typu modeling — proponuję użyć: **unit-economics** (CAC/LTV/payback) lub **3-statement-model**. Wolisz tak, czy odpowiedzieć od razu?"*

**Tabela przykładów z odpowiednim skillem:**

| Twoja wiadomość | Hook fires? | Sugerowany skill |
|------------------|-------------|-------------------|
| "cześć, jak się masz?" | ❌ nie | – |
| "Zbadaj TAM dla AML SaaS w CEE banking" | ✅ research | deep-research / market-research |
| "Zbuduj unit econ dla MarTech SaaS: ARPU €49, CAC €600, churn 4%" | ✅ modeling | unit-economics |
| "Napisz IC memo dla projektu X" | ✅ writing | ic-memo |
| "Pricing $99/$299/$999 vs flat $2k — co wybrać?" | ✅ decision + pricing | council + pricing-strategy + comps-analysis |
| "Zaprojektuj fake door experiment dla brokerów RE" | ✅ validation | experiment-designer / ux-researcher-designer |
| "Profesor X z patentem — fit dla nas?" | ✅ screening | screen-deal / dd-checklist |

### Manualne wywołanie

Jeśli wiesz dokładnie co chcesz:

```
/council Pricing FinTech B2B, mid-market PL banki, target ARR €500k/24mc
```

### Skip hook na konkretnej wiadomości

```
BEZ COUNCIL: szybko porównaj te 2 vendory, bez pełnej rady
```

---

## 7. Co rób / czego nie rób

### ✅ Rób

- **Pisz konkretnie z kontekstem** — "Pricing dla FinTech B2B, ICP banki PL, target ARR €500k/24mc" jest 10× lepsze niż "pomóż z pricingiem"
- **Dołączaj artefakty przez `--files`** — masz brief? Persona research? `--files brief.md,personas.md` (limit: 50KB/plik, 200KB łącznie)
- **Sprawdź `council doctor`** co tydzień — providerzy mogą wymagać re-login OAuth
- **Zapisuj wyniki w projekcie** (`decisions/2026-05-pricing-decision.md`) — następna sesja zaczyna z `--files <previous>`
- **Używaj browser tools (chrome-devtools-mcp) dla multi-page research** — nie N×WebFetch
- **Słuchaj hooka** — jeśli sugeruje skill X, zwykle ma rację

### ❌ Nie rób

- **Nie pytaj council o trywialne rzeczy** — np. "co znaczy CAC" → odpowie Claude solo
- **Nie kopiuj output 1:1 do dokumentów** — to syntheza, nie deliverable. Przetwórz, dopisz kontekst Heart, zweryfikuj liczby
- **Nie odpalaj 5 rad council pod rząd** — limity providerów się skończą. Pomyśl: czy potrzebuję rady czy mogę z tego co mam?
- **Nie ufaj ślepo w sprawach regulacyjnych** — KNF/MDR/RODO modele mogą dawać przestarzałe info. Zweryfikuj z prawnikiem
- **Nie używaj council do code review** — to nie use case dla analityka VB
- **Nie skip hooka "BEZ COUNCIL:" gdy to NAPRAWDĘ decyzja** — bo zjesz tokeny Claude Code zamiast oddelegować

---

## 8. Pierwsze 3 zadania do przećwiczenia

Wykonaj te 3 w pierwszym tygodniu. **Każde używa innego skilla** — pomoże Ci poczuć cały toolkit.

### Zadanie 1: Research + sizing → `deep-research`
> Zbadaj TAM/SAM/SOM dla AI-powered legal contract review SaaS w Polsce. Profil top 5 konkurentów (lokalni + globalni). Trendy regulacyjne. ~50 firm prawniczych z 50-500 employees.

**Oczekiwany flow:** Hook fires (research intent) → Claude pyta o `deep-research` (lub `market-research`) → zgadzasz się → dostajesz strukturalny report.

### Zadanie 2: Modeling → `unit-economics`
> Zbuduj unit economics dla MarTech SaaS (UniPerks-like): ARPU €49/mo, GM 78%, CAC €600 z paid+content mix, 4% monthly churn. Pokaż LTV, payback, contribution margin.

**Oczekiwany flow:** Hook fires (modeling intent) → Claude pyta o `unit-economics` → dostajesz konkretne liczby + breakdown.

### Zadanie 3: IC memo → `ic-memo`
> Napisz IC memo dla "Heart [twoje wymyślone venture]" — thesis, market opportunity, team profile, 3-yr financials summary, top 3 risks, ask.

**Oczekiwany flow:** Hook fires (writing intent) → Claude pyta o `ic-memo` (lub `pitch-deck`) → dostajesz IC memo template do dopracowania.

### Zadanie bonus 4: Decision → `council`
> Skoro już masz output z zadań 1-3, użyj `/council` żeby ocenić: czy ten venture jest fundable?

**Oczekiwany flow:** Hook fires (decision intent) → Claude pyta o `/council Tier L` → dostajesz syntezę z 2-3 LLM perspektyw.

---

## 9. Troubleshooting

| Problem | Rozwiązanie |
|---------|-------------|
| `command not found: council` | PATH nie zawiera `~/.local/bin` — dodaj `export PATH="$HOME/.local/bin:$PATH"` do `~/.zshrc` |
| `Provider claude failed: unknown` | Council nie może odpalić zagnieżdżonego Claude Code. To NIE jest błąd — fala kontynuuje z innymi providerami |
| `Gemini CLI timed out` | Cold start Gemini ~10s. Dla Tier L+ dodaj `--timeout 600` |
| Plugin install fail z 404 | Marketplace mógł być przeniesiony. Spawdź upstream README repo source |
| Hook fires zbyt często | Edit `~/.claude/hooks/council-vb-suggest.sh` — usuń niektóre patterny z `WEAK_PATTERNS` |
| Hook nie fires nigdy | `cat ~/.claude/settings.json | grep council-vb-suggest` — sprawdź czy zarejestrowany |
| Zła rekomendacja od council | To opinion model, nie sąd. Zweryfikuj liczby, dodaj kontekst Heart, decyduj jako człowiek |

---

## 10. Cheat sheet

```
# Najczęstsze patterny
<piszesz normalnie>                          # Hook decyduje czy fires
/council <pytanie>                           # Wymuszone wywołanie rady
BEZ COUNCIL: <pytanie>                       # Skip hook na tę wiadomość
council doctor                               # Status providerów (terminal)
council doctor --deep --provider gemini-cli  # Live test (zużywa tokeny!)
codex login                                  # Re-auth ChatGPT Plus
gemini                                       # Re-auth Google Workspace OAuth

# Token-saving wzorce
"Użyj chrome-devtools-mcp żeby otworzyć X i wyciągnąć Y"   # Multi-page research
"Użyj context7-plugin żeby sprawdzić docs biblioteki Z"    # Library docs lookup
```

**Pełna referencja:** [Venture Builder collection](venture-builder.md)

---

## 11. Feedback po 1-2 tygodniach

Daj znać:
- Patterny hookowe są za szerokie / za wąskie?
- Które skille faktycznie używasz, które ignorujesz?
- Brakuje skill dla konkretnego use case?
- Marketplace install instructions — gdzie się wykrzaczyło?

Issue lub PR: https://github.com/The-Heart-Vibe/claude-code-marketplace
