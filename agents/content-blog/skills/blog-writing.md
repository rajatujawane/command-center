---
name: blog-writing
description: Write or revise blog articles for any content-blog project. Owns craft — structure, AI-tell kill list, titles, SEO, output contract. The project's voice file owns persona and audience; the site repo's blog-ready skill owns site formatting and frontmatter.
---

# Blog Writing

This skill produces the article itself — title, prose, structure. It does NOT format for
the site; the repo's `blog-ready` skill does that at build time.

## Resolve the voice first

Before writing a word, read `projects/<task.project>/config.json` and load its `voice`.

Voice lives in the SITE REPO, not here — that way the agent and anyone writing a post by
hand in that repo read the same file. `"voice": "repo:<path>"` means read `<path>` inside
the project's `repo`:

- termstack    -> `~/Developer/varr-labs-website/.claude/skills/blog-writing.md`
- publishpilot -> `~/Developer/publish-pilot/.claude/skills/blog-writing.md`

(A `"voice": "projects/<p>/voice.md"` form is still honoured for a project whose repo has no
voice guide, read relative to `agents/content-blog/`. Nothing uses it today. Prefer the repo.)

The voice file owns persona, pronouns, audience, and product-mention stance. Where the
voice file and this file disagree on tone, the voice file wins. Where they disagree on
craft (the kill list below, structure, SEO), this file wins. Never write a post without
having loaded the project's voice file.

## Kill on sight (AI writing tells)

Applies to every project, no exceptions.

- Em dashes (— or --). Use a period or comma, or split into two sentences.
- Dramatic one-line fragments: "Not a replacement. A portfolio." Write complete sentences.
- Staccato clusters: "Seems harmless. Developers revolted anyway." Connect the thoughts.
- "Revolutionary", "game-changing", "cutting-edge", "unlock", "leverage", "comprehensive".
- "In today's fast-paced...", "In the ever-evolving...", "Let's dive in...".
- "It's worth noting that...", "It's important to understand...".
- Exclamation marks. Starting a sentence with "So,", "Well,", "Now,", "Look,".
- Filler: "essentially", "basically", "actually", "in order to", "when it comes to".
- Hedging: "might potentially", "could possibly". Stacked adjectives. Parenthetical asides.

## Craft floor

- Short sentences. Short paragraphs. One idea per paragraph.
- Start with the reader's problem, not background they already know.
- Be specific. Numbers, names, examples beat adjectives.
- Human enough that someone would believe a person wrote it.

## The opening

No heading. 2-3 short paragraphs. Frame the problem or question. Hook with something the
reader already feels or wonders about.

Pattern:
- Situation or question the reader has
- Why the obvious answer doesn't work
- What this post actually covers (one sentence)

Don't start with "In this article, we will explore." Just talk. See the project's voice
file for a worked example in that project's register.

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

Read every context file the task points you to in its `inputs` (the project PRD, the topic
brief, positioning notes). Those live under the project's `knowledge_root`. Use them to
ground the post:

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
