---
name: "presentation-generator"
description: "Generate branded presentations from a topic or brief. Produces a spec JSON and calls generate.py to build a .pptx file using the company template. Use when user asks to create, generate, or build a presentation, deck, or slides."
---

# Presentation Generator

Generate professional, on-brand presentations. You are the creative director and copywriter, not just a script runner.

---

## Token efficiency

Do the minimum necessary to produce a good output. Every extra step costs time and context.

**Assumptions — make them, don't ask:**

| If user says | Assume |
|---|---|
| "pitch for a bank" | Formal, 8–10 slides, C-level audience, English |
| "internal update" | Casual, 5–7 slides, team audience |
| "product overview" | Semi-formal, 8–12 slides, mixed audience |
| No slide count given | Use narrative minimum — stop when the story is complete |
| No language given | Match the language the user wrote in |

**Ask only one question at a time**, only if the answer genuinely changes the deck structure. Never ask about things you can infer.

**Never:**
- Narrate your planning process ("First I'll figure out the structure...")
- Show the spec JSON to the user before generating — go straight to the file
- Ask for approval of the spec — generate, then offer revisions
- Re-explain what each slide does after generating — the user can open the file
- Add slides "just in case" — every slide must earn its place

**On revisions:** one round is normal. If the user asks for changes, apply them and regenerate. Don't discuss — do.

---

## Available templates

Templates live in `bundled/templates/`. Each `.pptx` file is a separate branded template with its own slide layouts. More can be added over time — the plugin picks up any file placed in that directory.

| Template file | Use for |
|---|---|
| `blank.pptx` | Simple internal decks, one-pagers, quick updates |
| `pitchdeck-toolkit.pptx` | External pitches, client proposals, investor materials |

**Default:** if the user doesn't specify, infer from context:
- Formal pitch / client / investor → `pitchdeck-toolkit.pptx`
- Internal update / team / status → `blank.pptx`

**Assumption:** state which template you're using in the outline approval step. The user can override before generation.

---

## Workflow

1. **Assess context** — enough to write a good deck, or critically missing?
2. **If critically missing: brainstorm** — run a short structured session (see below)
3. **Select template** — infer from context or ask if genuinely ambiguous
4. **Plan the narrative** — slide order and layout types before any copy
5. **Show the outline for approval** — template + title + layout for each slide, no body copy yet
6. **Wait for go-ahead**, then write the full spec and run generate.py
7. **Present the file** — share and offer one round of revisions

### When to brainstorm vs when to assume

**Assume and proceed** when you have: topic, audience, rough goal.
Example: "pitch for a bank about our rewards product" — enough. Start.

**Brainstorm first** when the brief is so open that the wrong structure would waste the whole generation:
- No clear audience ("make a presentation about AI")
- Conflicting goals ("pitch + internal update in one deck")
- Unknown product/context with no prior conversation
- User explicitly unsure: "I don't know where to start"

### Brainstorm session format

Ask max 3 questions, all at once, not one by one:

```
Before I plan the deck, three quick things:
1. Who's in the room? (role, company type, what they care about)
2. What decision do you want them to make after seeing this?
3. What's the one thing they must walk away believing?
```

Use answers to fix structure, not just fill content.

### Outline approval format

Show template + numbered list: layout type and title only. No bullets, no body.

```
Template: pitchdeck-toolkit.pptx

1. cover      — "Transaction Rewards Hub: Pilot Proposal for Bank ABC"
2. content    — "Banks spend 14 months building what we ship in 4 weeks"
3. content    — "One API call. Rewards live on day one."
4. two_column — "Option A: Event Triggers vs Option B: Transaction Data"
5. content    — "Four success metrics for the pilot"
6. closing    — (standard)
```

If the user approves or says "looks good / go / ok" — generate immediately. No further questions.

---

## Layout Selection

Choose the layout that fits the *content shape*, not the slide title.

| Layout | Use when |
|---|---|
| `cover` | First slide only. Never reuse. |
| `section` | Transitioning between major narrative blocks (Problem → Solution). Use sparingly — max 2 per deck. |
| `content` | Default. One idea, max 5 bullets, optional icon. |
| `two_column` | Comparison, options A/B, before/after, pros/cons. |
| `chart` | Data that earns a visual — growth over time, distribution, funnel. Don't use for a single number. |
| `quote` | A strong customer quote, a stat that deserves full focus, a bold claim. |
| `closing` | Last slide only. Always include. |

**Narrative order for a pitch:**
`cover → problem → solution → how_it_works → proof/metrics → next_steps → closing`

**Narrative order for an internal update:**
`cover → context → what_changed → impact → decisions_needed → closing`

**Narrative order for a product overview:**
`cover → problem → solution → key_features (content ×2–3) → pricing/packaging → next_steps → closing`

---

## Icon Selection

Map the *theme* of the slide, not the title words.

| Slide theme | Icon |
|---|---|
| Security, compliance, privacy | `shield` or `lock` |
| Growth, uplift, improvement | `trending-up` |
| People, team, audience | `users` |
| Money, revenue, payment | `banknote` or `credit-card` |
| Time, timeline, deadline | `clock` |
| Goal, OKR, KPI | `target` |
| Technical, API, code | `code` |
| Data, analytics, metrics | `bar-chart-2` or `database` |
| Bank, company, institution | `building-2` |
| Launch, new product, MVP | `rocket` |
| Achievement, recognition | `award` |
| Warning, risk, blocker | `alert-triangle` |
| Confirmation, success, done | `check-circle` |
| Integration, layers, stack | `layers` |

One icon per slide. Skip the icon if the slide has a chart or image.

---

## Copy Rules

### Slide titles

Titles must state the *point*, not name the category.

| ❌ Slop | ✓ Sharp |
|---|---|
| "Overview" | "Banks spend 14 months building what we ship in 4 weeks" |
| "The Problem" | "Loyalty kills margins before the first cardholder earns a point" |
| "Our Solution" | "One API call. Rewards live in 4 weeks." |
| "Key Benefits" | "Three things banks get on day one" |
| "Next Steps" | "Two decisions needed before we can start" |
| "Conclusion" | "The pilot costs 4 weeks. Doing nothing costs more." |
| "Market Opportunity" | "€4.2B in uncaptured loyalty revenue in CEE alone" |

Rules:
- Max 8 words
- No gerunds ("Driving growth", "Unlocking value", "Leveraging data")
- No "our", "we", "you" in title — state the fact
- A good title makes the slide's argument on its own

### Bullet points

Each bullet is a complete thought — not a label.

| ❌ Slop | ✓ Sharp |
|---|---|
| "Scalability" | "Handles 10M transactions/day — no infrastructure changes needed" |
| "Fast integration" | "2–4 weeks from first call to live rewards" |
| "Secure" | "Zero PII leaves the bank — pseudonymised data only" |
| "Easy to use" | "One API endpoint. One webhook. Bank dev time: ~3 days." |
| "Cost effective" | "No CapEx. Revenue share from month one." |

Rules:
- Start with a number, a verb, or a concrete noun — never an adjective
- Max 12 words per bullet
- 3–5 bullets per slide — never more
- No bullet should repeat another bullet's idea in different words
- If two bullets could be merged, merge them

### Banned phrases for slides

**Titles:**
- "Overview", "Introduction", "Background"
- "Key [Anything]" — ("Key Benefits", "Key Features", "Key Takeaways")
- "Unlocking", "Leveraging", "Driving", "Enabling", "Empowering"
- "World-class", "Best-in-class", "Industry-leading", "Next-generation"
- "Innovative solution", "Unique approach", "Powerful platform"
- "In today's [landscape/world/environment]"
- "The future of [X]"

**Bullets:**
- Bullets that start with an adjective ("Fast", "Secure", "Scalable", "Flexible")
- "And more..." as a final bullet
- "Proven track record"
- "Seamless experience"
- "End-to-end solution"
- "Best practices"
- "Robust [anything]"
- "Cutting-edge", "State-of-the-art"
- Any -ly adverb ("quickly", "easily", "seamlessly", "significantly")

**Punctuation:**
- Em-dash (—): banned everywhere. Use a period or comma.
- En-dash (–): banned as a clause separator ("Fast – and secure" → "Fast and secure"). Allowed only in numeric ranges (2–4 weeks, 10–12 months).
- Ellipsis (…): banned. Finish the sentence or cut it.

**Structural patterns to kill:**
- Tricolon for drama: "Fast. Simple. Reliable." → write one sentence
- Rhetorical questions on slides: "What if you could...?" → state the answer
- Negative listing: "Not X. Not Y. Z." → state Z
- Agenda slide for decks under 12 slides — skip it entirely
- "Thank you" as a closing slide title — use a call to action instead

---

## Slide count rules

| Presentation type | Slide count |
|---|---|
| Cold pitch / first meeting | 8–10 |
| Deep-dive / proposal | 12–16 |
| Internal update | 5–8 |
| Product demo intro | 6–10 |

Never pad to hit a number. 8 strong slides beat 14 with filler.

Section dividers count against the total — they add no information.

---

## Numbers and data

- If you have a number, use it. "Significant time savings" → "9–14 months saved"
- Round consistently — don't mix "€4.2M" and "3 million euros" in the same deck
- Sources: if a stat is from external research, add a footnote reference in speaker notes
- Single-number stats belong on a `quote` layout, not buried in a bullet

---

## Tone calibration

| Context | Tone adjustments |
|---|---|
| Bank / enterprise pitch | Remove contractions. No exclamation marks. Lead with numbers. |
| Internal team update | Casual, direct. First person fine. Focus on decisions and blockers. |
| Investor / startup pitch | Short sentences. Vision first, proof second. |
| Product demo | Present tense. "You click X, the system does Y." |

---

## Quick checks before generating

Run these before calling generate.py:

- [ ] Every title states a point, not a category
- [ ] No bullet starts with an adjective
- [ ] No banned phrases anywhere in the deck
- [ ] Slide count matches the context (no padding)
- [ ] Icons match slide *theme*, not title words
- [ ] Numbers are specific and consistent
- [ ] Closing slide has a call to action, not "Thank you"
- [ ] No slide repeats the argument of another slide

---

## Calling generate.py

```bash
python3 bundled/generate.py --spec /tmp/spec.json --output /tmp/output.pptx
```

`--template` is optional. If omitted, generate.py reads `"template"` from the spec. If neither is set, it falls back to `bundled/templates/blank.pptx`.

Spec format:
```json
{
  "template": "pitchdeck-toolkit",
  "slides": [
    {
      "layout": "cover",
      "title": "...",
      "subtitle": "..."
    },
    {
      "layout": "content",
      "title": "...",
      "icon": "shield",
      "body": ["Bullet one", "Bullet two", "Bullet three"]
    },
    {
      "layout": "two_column",
      "title": "...",
      "left":  { "heading": "Option A", "bullets": ["..."] },
      "right": { "heading": "Option B", "bullets": ["..."] }
    },
    {
      "layout": "chart",
      "title": "...",
      "chart_type": "bar",
      "data": { "labels": ["Q1","Q2","Q3"], "values": [20, 35, 48] }
    },
    {
      "layout": "closing"
    }
  ]
}
```

After generating: present the file with `mcp__cowork__present_files` and offer one round of revisions.
