# The Heart Vibe — Claude Code Marketplace

Wewnętrzny marketplace pluginów Claude Code dla zespołu The Heart Vibe.

**Co tu jest:**
1. **`council` plugin** — nasz autorski wrapper na multi-LLM debate. Hostujemy.
2. **Kuratorskie kolekcje** (docs) — mapy polecanych skilli per rola, **odnoszą się do skilli z innych publicznych marketplaces** (ich nie hostujemy).

## 🚀 Quick start dla zespołu

**Nowy w The Heart?** → idź prosto do [**Onboarding VB**](collections/onboarding-vb.md) (30-45 min, pełna instalacja toolkitu).

**Już znasz Claude Code, chcesz dodać tylko nasze rzeczy?**

```
/plugin marketplace add The-Heart-Vibe/claude-code-marketplace
/plugin install council@the-heart-vibe
```

(Council installer dopyta o opt-in Venture Builder hook.)

## Pluginy hostowane tutaj

| Plugin | Opis | Status |
|--------|------|--------|
| [`council`](plugins/council) | Multi-LLM debate (Claude Code + Codex + Gemini CLI) z routingiem domain × tier i hookiem przypominającym o właściwym skillu | ✅ stable |

## Kolekcje (kuratorskie zestawy per rola)

Kolekcje to **dokumentacja** — mapują pracę zespołu na zewnętrzne skille z różnych marketplaces. **Nie są bundle pluginami** — instalujesz każdy skill osobno z jego oryginalnego źródła (instrukcje w onboardingu).

| Kolekcja | Dla kogo | Co zawiera |
|----------|----------|------------|
| [Venture Builder](collections/venture-builder.md) | Analitycy + konsultanci VB w The Heart | ~25 skilli w 7 fazach (discovery → IC) z 5+ zewnętrznych marketplaces + sector addenda (FinTech/HealthTech/RealEstate/MarTech) + token-efficient practices |
| [Onboarding VB](collections/onboarding-vb.md) | Pierwsze 30-45 min nowego teammate'a | Step-by-step: jak dodać marketplaces, zainstalować skille, skonfigurować providerów, 3 zadania praktyczne |

Więcej w [`collections/`](collections/).

## Zewnętrzne marketplaces, na których opieramy się

Kolekcje referują skille z (podzielone wg ich oryginalnego sourceów):

| Skille z... | Marketplace | Add command |
|-------------|-------------|-------------|
| Council (nasze) | `The-Heart-Vibe/claude-code-marketplace` | (już dodane jeśli czytasz to repo) |
| Research, market analysis, exa-search, investor-* | `affaan-m/everything-claude-code` | `/plugin marketplace add affaan-m/everything-claude-code` |
| Product discovery, UX research, competitive teardown, IC memo, pitch deck, unit economics | `alirezarezvani/claude-skills` | `/plugin marketplace add alirezarezvani/claude-skills` |
| Superpowers (brainstorming, TDD), stop-slop | `claude-plugins-official` | `/plugin marketplace add anthropics/claude-plugins` |
| Browser tooling (token-saving) | `ChromeDevTools/chrome-devtools-mcp` | `/plugin marketplace add ChromeDevTools/chrome-devtools-mcp` |
| Docs lookup (Context7) | `upstash/context7` | `/plugin marketplace add upstash/context7` |

> Jeśli któryś `marketplace add` zawiedzie — upstream przeniosło ścieżki. Zgłoś do nas, zaktualizujemy onboarding.

## Dodawanie nowego pluginu

1. Stwórz katalog `plugins/<nazwa>/` z:
   - `.claude-plugin/plugin.json` — metadata
   - `skills/<nazwa>/SKILL.md` — body skilla
   - `README.md` — instrukcje setup i użycia
   - `install.sh` (opcjonalnie) — automatyzacja instalacji zależności
2. Dodaj wpis do `.claude-plugin/marketplace.json`
3. PR z opisem do czego ten plugin służy i jak był testowany
4. Po merge teammate'y robią `/plugin update council@the-heart-vibe` żeby pociągnąć zmiany

## Konwencje

- **Język:** polski w treści, angielski w `description` (dla skanowania przez Claude)
- **Paths:** używaj `$HOME` lub env-overridable zmiennych, nie hardcoded `/Users/...`
- **Provider keys:** unikaj wymuszania API keys jeśli da się przez CLI auth (jak w `council`)
- **Sekrety:** nigdy do repo. `.example.yaml` zamiast prawdziwych configów

## Licencja

MIT — wewnętrzne narzędzia, ale otwarte na opensourceing jeśli zdecydujemy.
