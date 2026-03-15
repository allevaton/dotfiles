---
name: new-active-project
description: Bootstraps a structured project workspace from a planning document (PDF, markdown, or pasted text). Use this skill when the user runs /new-active-project or asks to set up a new project, initialize project docs, or convert a kickoff doc, PRD, or plan into a tracked Claude Code project. Also use when the user wants to advance to the next phase of a project (/advance-phase) or finalize and archive a completed project (/complete-project). Creates overview.md, phase or plan files with task tracking, decisions.md, and updates CLAUDE.md automatically.
---

# New Active Project

Converts a planning document into a structured project workspace that persists context across Claude Code sessions.

## What This Skill Does

- Parses a source document (PDF, markdown, pasted text) into a canonical file scaffold
- Detects whether the project is phased or single-scope and adjusts structure accordingly
- Seeds a `decisions.md` with any open questions found in the source doc
- Updates `CLAUDE.md` to index the new project so every future session loads the right context automatically
- Handles lifecycle commands: advancing phases and archiving completed projects

## Commands

- `/new-active-project <source>` — Bootstrap a new project from a document
- `/advance-phase` — Mark current phase complete, activate next
- `/complete-project` — Archive project as documentation

---

## Step 1: Parse the Source Document

Read the document in full. Rather than mapping source sections to output sections 
directly, classify content into information types:

**Always extract if present:**
- **Identity** — project name, what it is, who uses it
- **History/context** — what exists today, why it's being replaced or built, what 
  changed to make this possible now
- **Motivation** — goals, business value, user value
- **Scope** — what's included; what screens, features, behaviors
- **Phases** — whether delivery is staged, and what each stage contains
- **Entry points** — how users reach this feature
- **Open decisions** — explicit questions, options being weighed, TBDs
- **Deferred work** — anything explicitly called out as future or out of scope

**Extract if meaningfully present:**
- **Constraints** — technical, timeline, resource, or platform constraints that 
  affect how work gets done
- **Dependencies** — things that must exist or be decided before work can proceed
- **Design/UX reference** — prototypes, mockups, existing patterns to follow or 
  diverge from
- **Data models** — entities, fields, shapes described in the doc
- **Success criteria** — how the team will know this is done or working

**Ignore:**
- Author's implementation opinions (library choices, architectural preferences) 
  unless they're framed as open decisions
- Specifics the engineer should form their own view on

---

## Step 2: Determine Structure

**Phased project** — use when there are 2+ distinct delivery phases with different scope:
```
docs/projects/<project-slug>/
  overview.md
  phase-1.md
  phase-2.md        ← created but marked PARKED
  phase-N.md        ← one file per phase
  decisions.md
```

**Single-scope project** — use when there are no phases or the "phases" are just sequencing within one delivery:
```
docs/projects/<project-slug>/
  overview.md
  plan.md
  decisions.md
```

If you're uncertain, lean toward single-scope. Phases should reflect genuinely separate delivery milestones, not internal task ordering.

---

## Step 3: Write the Files

### `overview.md`

Do not use a fixed template. Instead, create sections based on what you extracted.
Every overview.md will have some sections and not others depending on what the 
source doc contains.

Rules:
- Each information type that was extracted becomes a section
- Section titles should be plain and descriptive, not creative
- Keep each section tight — overview.md is orientation, not a full spec
- Suggested section titles by type:

  | Type              | Suggested title         |
  |-------------------|-------------------------|
  | Identity          | What We're Building     |
  | History/context   | Background              |
  | Motivation        | Why It Matters          |
  | Entry points      | Entry Points            |
  | Deferred work     | Out of Scope            |
  | Constraints       | Constraints             |
  | Dependencies      | Dependencies            |
  | Design reference  | Design Reference        |
  | Data models       | Data Models             |
  | Success criteria  | Success Criteria        |

- If a type is absent from the source doc, omit the section entirely
- If two types are closely related and small, combine them under a shared title
- Identity is always first. Everything else follows in logical reading order.

### `phase-N.md` (phased) or `plan.md` (single-scope)

```markdown
# <Project Name> — Phase N: <Phase Title>
<!-- Use "# <Project Name> — Plan" for single-scope projects -->

## Status
ACTIVE  <!-- or PARKED for future phases -->

## Scope
<What is included in this phase. Be specific about screens, features, behaviors.>

## Implementation Status
<!-- Populated from scope above. Add items as work begins. -->
- [ ] <task>
- [ ] <task>

## Notes
<!-- Running notes, gotchas, things discovered during implementation -->
```

For PARKED phases, omit the Implementation Status section. Add it when the phase is activated.

### `decisions.md`

```markdown
# Decisions — <Project Name>

Open questions and resolved decisions for this project.

## Open
<!-- Unresolved questions extracted from the source doc, or that arise during implementation -->

- **<Decision topic>**: <Context. What are the options? What's the tradeoff?>

## Resolved
<!-- Move items here when a decision is made. Include what was decided and a brief why. -->

| Decision | Resolution | Rationale |
|----------|-----------|-----------|
```

Seed Open with any explicit questions or options from the source doc. Leave Resolved empty.

---

## Step 4: Update CLAUDE.md

Locate or create the `## Active Projects` section in CLAUDE.md. Add an entry:

```markdown
## Active Projects

### <Project Name>
**Status**: Phase N active  <!-- or "In progress" for single-scope -->
**Docs**: `docs/projects/<slug>/`

Before starting any work on this project, read:
- `docs/projects/<slug>/overview.md`
- `docs/projects/<slug>/phase-N.md`  <!-- or plan.md -->
- `docs/projects/<slug>/decisions.md`

Parked (do not read unless instructed):
- `docs/projects/<slug>/phase-2.md`  <!-- list any parked phases -->

**Convention**: When completing implementation work, update `## Implementation Status` 
in the active phase file before ending the session.
```

If there are no parked phases, omit that section.

---

## Lifecycle Commands

### `/advance-phase`

When the user runs this after completing a phase:

1. In the current phase file:
   - Change `Status` to `COMPLETE`
   - Add a `## Summary` section: what was built, what decisions were locked in
   - Keep the completed task list as a record

2. In the next phase file:
   - Change `Status` to `ACTIVE`
   - Add the `## Implementation Status` section seeded from the scope

3. Update CLAUDE.md:
   - Change the "Before starting" list to point to the new active phase
   - Move the old phase to Parked (or remove it from Parked if it was listed there)
   - Update the Status line

### `/complete-project`

When the user signals the project is done:

1. For each phase file (or plan.md):
   - Remove the Implementation Status section (tasks are done, they're noise now)
   - Collapse decisions references to just the resolutions
   - Keep the Summary if present

2. Move the folder to `docs/architecture/<slug>/` or equivalent long-term docs location

3. Remove the project entry from CLAUDE.md's Active Projects section

4. Tell the user what was moved and where.

---

## Output Checklist

Before finishing, confirm:
- [ ] `overview.md` written — what and why only, no implementation
- [ ] Phase/plan files written — one ACTIVE, rest PARKED if phased
- [ ] `decisions.md` seeded with open questions from source doc
- [ ] CLAUDE.md updated with project entry and file pointers
- [ ] Convention instruction included in CLAUDE.md entry
- [ ] Told the user what was created and what to do next
