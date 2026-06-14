---
name: blog-writing
description: Write or revise blog articles for the Varr Labs site. Produces the title and prose only; the site repo's blog-ready skill handles site formatting and frontmatter.
---

# Blog Writing

This skill produces the article itself — title, prose, structure. It does NOT format for
the site; the repo's `blog-ready` skill does that at build time. The voice rules below are
the foundation for everything you write here.

## How we sound

Like a friend who knows their stuff explaining something over chai. Not a brand, not a
teacher, not a LinkedIn thought leader. Talk to the reader, not at them. Use "you" and
"I". Have opinions and back them up.

## Voice rules

- Write like you talk. Read it out loud. If it sounds weird, rewrite it.
- Short sentences. Short paragraphs. One idea per paragraph.
- Ask rhetorical questions to pull the reader in.
- Be opinionated. Take a side. "It depends" is lazy unless you explain the conditions.
- Be specific. Numbers, names, examples. Not "many developers" but "most devs I talk to".
- Start with the reader's problem, not background they already know.
- Contractions always. "Don't", "can't", "won't".

## Kill on sight (AI writing tells)

- Em dashes (— or --). Use a period or comma, or split into two sentences.
- Dramatic one-line fragments: "Not a replacement. A portfolio." Write complete sentences.
- Staccato clusters: "Seems harmless. Developers revolted anyway." Connect the thoughts.
- "Revolutionary", "game-changing", "cutting-edge", "unlock", "leverage", "comprehensive".
- "In today's fast-paced...", "In the ever-evolving...", "Let's dive in...".
- "It's worth noting that...", "It's important to understand...".
- Exclamation marks. Starting a sentence with "So,", "Well,", "Now,", "Look,".
- Filler: "essentially", "basically", "actually", "in order to", "when it comes to".
- Hedging: "might potentially", "could possibly". Stacked adjectives. Parenthetical asides.

## The opening

No heading. 2-3 short paragraphs. Frame the problem or question. Hook with something the
reader already feels or wonders about.

Pattern:
- Situation or question the reader has
- Why the obvious answer doesn't work
- What this post actually covers (one sentence)

Don't start with "In this article, we will explore." Just talk.

Example:
```
If you sell wholesale on Shopify Plus, payment terms aren't optional.
They're how your buyers expect to pay.

But most merchants I talk to have a fuzzy understanding of how terms
actually work on Shopify.

This post breaks that down.
```

## Structure

- Opening paragraphs (no heading)
- ## The problem / current state — why it matters, where it breaks
- ## The approach / how it works — core content, broken into logical sections
- ## Practical details or examples — show, don't tell
- Closing — soft CTA if relevant

Adapt it. The point is: problem first, then substance, then action.

## Titles

- Specific beats clever. "How to Deploy Next.js on Vercel in 5 Minutes" beats "Deploying Made Easy".
- Include the primary keyword naturally. Don't force it.
- Under 60 characters when possible.
- No clickbait. The post must deliver what the title promises.

## Formatting

- H2 for major sections. H3 sparingly within long sections.
- Short paragraphs, 2-4 sentences. Walls of text kill readability.
- Bold the lead phrase in descriptive bullets:
  ```
  - **Net 30.** Full payment due 30 days after invoice.
  - **Net 60.** Full payment due 60 days after invoice.
  ```
- Code blocks with language tags for all code.
- Blockquotes for key takeaways, 1-2 sentences.
- Tables for comparisons, 2-3 columns.

## Section length

3-6 paragraphs per H2 section. If it gets longer, break into subsections or split into two H2s.

## SEO basics

- One primary keyword per post, in the title and the first paragraph.
- Meta description: one complete sentence under 160 chars that stands on its own.
- Descriptive alt text on any images.
- 800-2000 words. Quick explainer 800-1200, in-depth guide 1500-2000. Past 2000, split into a series.

## Project-aware writing

When writing for a specific product, read the context files the task points you to in its
`inputs` (e.g. a product PRD, positioning notes, or market doc). Use them to ground the
post:

- What the product does, who it's for, the one concrete claim you can always make.
- The customer's own language — mirror their words, not ours.

The reader should never feel like they're reading a marketing doc. The context files are
your briefing, not your outline. Don't dump strategy into the article.

## Output

Write the article to `outputs/<task-id>/draft.md`:
- Title as an H1 on the first line.
- A one-line meta description noted directly under the title.
- The full body below.

The build step hands the title + body to the repo's `blog-ready` skill, which owns the
site's frontmatter and file format. Don't add site-specific frontmatter here.