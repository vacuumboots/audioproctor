

**Design Philosophy**

The aesthetic is **editorial print** — specifically inspired by mid-century typeset documents and quality journalism (think *The Economist* or a well-designed annual report). The core idea is that it should feel *credible and considered*, not tech-startup slick. For an education product pitched to administrators, that tone is intentional: it reads as something made by someone who takes their craft seriously.

The organizing principle is **structure through rules** — borders, dividers, and grid columns do the heavy lifting instead of color blocks or drop shadows. Everything feels contained and deliberate.

---

**Color Palette**

| Name | Hex | Role |
|---|---|---|
| Ink | `#1a1a2e` | Primary text, borders, dark blocks |
| Paper | `#f8f5ef` | Page background — warm off-white, not pure white |
| Accent | `#c0392b` | Highlights, the "Proctor" in the wordmark, solution labels |
| Warm Mid | `#e8e0d0` | Problem column background, step numbers |
| Muted | `#6b6560` | Secondary text, labels, footer |
| Light Accent | `#fdf0ee` | Feature card backgrounds — the faintest blush of red |

The palette is essentially **two neutrals + one strong red**. The red is used sparingly so it always reads as meaningful.

---

**Typography**

- **Playfair Display** (Google Fonts) — the display/headline font. Serif, high contrast strokes, classical feel. Used for the wordmark, the lead paragraph, and the large price figure. It's what gives the document its editorial authority.
- **DM Sans** — the body font. Geometric sans-serif, but warmer and less corporate than Inter or Roboto. Used for everything else at `font-weight: 300` (light) for body copy, `500` for labels and emphasis.

The pairing works because Playfair is expressive and DM Sans is restrained — they don't compete.

---

**Key Structural Choices**

- Labels are `0.7rem`, `letter-spacing: 0.14em`, `text-transform: uppercase` — this "small caps" treatment is used consistently for every section label, creating a quiet but strong typographic rhythm
- Borders are `1px solid #1a1a2e` (full ink color) — no soft grays, which keeps things crisp
- The dark pricing block uses the ink color as a background with the paper color as text — an inversion that creates visual weight without needing a graphic
- Generous `line-height: 1.7` on body copy keeps everything breathable

---
