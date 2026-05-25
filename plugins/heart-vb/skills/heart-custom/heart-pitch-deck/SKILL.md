---
name: heart-pitch-deck
description: Buduje lub poprawia pitch deck inwestorski dla venture w portfolio Heart. Atomic daily task — odpalasz raz, dostajesz structured deck outline z thesis/problem/solution/traction/team/financials/ask. Sector-aware (HealthTech/academic/energy/FinTech). Use when user pyta "zbuduj deck dla X", "popraw deck Y", "co powinno być na slide thesis".
---

# Heart Pitch Deck

Atomic skill dla buildowania/poprawiania pitch decków. Daily task — single session, brak persistent state.

## Standardowy Heart pitch deck structure (10-12 slides)

| # | Slide | Co MUSI być | Heart-specific framing |
|---|-------|-------------|--------------------------|
| 1 | **Cover** | Logo, tagline, single sentence value prop | Polski + ENG bilingual jeśli international audience |
| 2 | **Problem** | Konkretny pain point z evidence (dane, quotes), kto ma ten problem | Quote z research interviews — nie generic stats |
| 3 | **Solution** | Co robicie + dlaczego to działa, najlepiej diagram | Tech architecture na 1 slide (NIE wszystkie details) |
| 4 | **Why now** | Macro trends, regulator changes, tech maturity — co umożliwia to teraz a nie 5 lat temu | KRYTYCZNE dla deep tech / regulated sectors — show timing |
| 5 | **Market** | TAM/SAM/SOM z polską perspektywą + EU expansion path | CEE benchmarks (rynek PL ≠ rynek US 1:1) |
| 6 | **Product/Demo** | Screenshots, workflow, what user faktycznie widzi | Avoid jargon — analytic VC partner musi zrozumieć w 30s |
| 7 | **Traction** | MAU/MRR/ARR/customers + 3-6mc trajektoria. Pre-revenue → LOIs/pilots/waitlist | Heart-specific: pilot z portfolio company / corporate VB partner |
| 8 | **Business model** | Pricing tier struktura + unit economics (CAC, LTV, payback, gross margin) | Polska realia — banki/przychodnie/DSOs sales cycle 9-18mc |
| 9 | **Competition** | Landscape matrix (us vs 3-5 konkurentów) + moat (lokalność, IP, regulator, network effects) | Local + global view dla CEE ventures |
| 10 | **Team** | Founders + key hires + advisory board. Jeśli academic — explicit role split CSO/CEO/CTT | Heart angle: ekspertyza scientific + commercial bridge |
| 11 | **Financials** | 3-yr projection (revenue, costs, burn, headcount) + use of funds | Conservative scenario na pierwszej liczbie, bull case w appendix |
| 12 | **Ask** | Kwota + ekwity + milestones na 18-24 mc | Konkretne: NIE "raise €5M" → "€5M w zamian za 15% na 24-mc runway do Series A" |

**Appendix slides (opcjonalne, dla follow-up Q&A):**
- Detailed financials breakdown
- Cap table
- Tech architecture deep dive
- Regulatory roadmap (dla HealthTech / Energy / FinTech)
- IP portfolio (dla academic spinouts)
- Customer references / case studies

## Sector-aware modifications

| Sektor | Co dodatkowo MUSI być w decku |
|--------|---------------------------------|
| **HealthTech** | Slide z MDR classification path + clinical advisory board + IRB/pilot study plan + reimbursement narrative (NFZ/private/insurance) |
| **Academic spinout** | Slide z IP ownership (CTT license / equity split), funding stack (NCBR + EU + private), founder allocation realities (sabbatical/dual employment), founder readiness gap |
| **Energy storage / cleantech** | Slide z regulator path (URE, EU Battery Reg compliance), capacity market participation strategy, ESG/EU Taxonomy alignment, anchor customer (PSE/DSO/industrial) |
| **FinTech** (legacy) | KNF licencja status + AMLD6/MIFID2/PSD2 compliance roadmap + bank vendor security audit readiness + on-prem deployment option |

## Inputs (co zbieram od użytkownika przed buildowaniem)

1. **Venture name + 1-sentence pitch**
2. **Stage** (idea / PoC / MVP / pilot / revenue / growth)
3. **Sektor** (HealthTech / Academic / Energy / FinTech / inny — jeśli inny → persona-only mode bez heart-* context)
4. **Audience** (IC The Heart / external VC / corporate partner / strategic acquirer)
5. **Materiały** które mam (research, financial model, customer data, team CVs)
6. **Ask** (jeśli wiadomy: kwota + use of funds + milestones)

Jeśli któryś brak → pytaj user przed buildowaniem, NIE confabuluj.

## Common anti-patterns (NIE rób tego)

- **Slide z "competitors" gdzie wszyscy są niżsi niż my** → Naive. Pokaż real moat, gdzie konkurenci są lepsi.
- **Hockey stick na revenue projection bez bottom-up** → flagi VC. Bottom-up logic na pierwszej projection slide.
- **"Disruption" / "AI-powered" / "revolutionary"** → buzzwordy, używaj concrete language.
- **Multi-color, 3D charts, animations** → distractions. Heart deck style = clean, white space, max 2 colors.
- **Wszyscy founders mają "20+ lat experience"** → exaggeration. Real backgrounds + specific gaps + how filling them.
- **Pomijanie risks/challenges** → IC wie że są. Lepiej explicit z mitigations niż pretend that nie ma.

## Output format

Gdy ktoś prosi o build deck:

1. Zbierz inputs (above)
2. Pokaż **slide-by-slide outline** (NIE pełne slidy) — bullet points per slide
3. Zaznacz które slidy wymagają data z user (np. "Slide 7 Traction — potrzebuję MRR z ostatnich 6 mc")
4. Suggested sector-specific additions (z tabeli wyżej)
5. Po akceptacji outline'u: rozwiń każdy slide w detail

Gdy ktoś prosi o **poprawić istniejący deck**:
1. Poproś o paste deck (markdown / text dump slidów) lub `--files deck.pdf`
2. Review per slide: co działa, co nie działa, missing
3. Top 5 zmian do wprowadzenia z priorytetem

## Use jako standalone

```
"Zbuduj deck inwestorski dla heartware AI (HealthTech, AI-powered cardiac monitoring,
 PoC stage z 50 pacjentami z WUM, looking for €1.5M seed). Audience: external VC."

→ Pytam o: pricing model, team profile (CMO?), competitive landscape, financial assumptions
→ Zwracam: 10-slide outline z markowanymi gaps
→ Po akceptacji: rozwijam slide-by-slide
```

## Integration z innymi heart-vb skillami

- Przed deckem: **deep-research** dla market sizing, **competitive-teardown** dla landscape
- W trakcie: **saas-metrics-coach** dla unit economics na slide 8, **board-prep** dla narrative coherence
- Po pierwszym draft: **stress-test** żeby red-team przeciwko obvious VC pushback
- Sector context: załącz odpowiedni **heart-{healthtech/academic/energy/fintech}-compliance/context**

Output to deck **outline + content per slide**. NIE generuję faktycznych .pptx — to artifact tools / external designer job.
