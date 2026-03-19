---
name: jira-ticket-manager
description: Manages Jira tickets for all engineering work — every implementation task flows through a ticket, whether one exists already or needs to be created. Use this skill when asked to create Jira tickets, break down a project plan into tickets, plan sprints, sequence work, transition ticket status, or when Claude Code needs to pick up and execute work. Also triggers for "go build this", "implement this feature", "fix this bug", "create tickets for this", "break this down into tasks", "what's next in the epic", "move this ticket to in review", "plan this project", or any request to do engineering work that should be tracked in Jira. If work is being done and no ticket exists, this skill ensures one is created first.
---

# Jira Ticket Manager

This skill manages the full lifecycle of Jira tickets at SidelineSwap — from decomposing a project plan into well-structured tickets, through sequencing and creating them, to transitioning their status as work progresses.

The system is designed around a key assumption: **Claude Code is the primary executor of ticket work.** Tickets are written as vision-level work instructions that an engineering agent can plan against, not as traditional project management artifacts. Non-engineers (product, CEO) can author tickets in this system because implementation details are resolved during a separate planning phase, not embedded in the ticket itself.

## Configuration

Before creating or managing tickets, confirm these values. They may change per project.

| Setting | Value | Notes |
| --- | --- | --- |
| Atlassian Site | `sidelineswap.atlassian.net` | Used as cloudId in all Atlassian MCP calls |
| Project Key | **Confirm per project** | Query with `getVisibleJiraProjects` if unknown |
| Issue Types | **Confirm per project** | Query with `getJiraProjectIssueTypesMetadata` |
| Workflow Statuses | To Do → In Progress → Committed → Staged | See Lifecycle section |
| Default Assignee | **Current user (me)** | All tickets are assigned — see Assignment section |
| Story Points | **Fibonacci scale** | All tickets get story point estimates — see Estimation section |

When starting work on a new project, always run discovery first:

1. `getVisibleJiraProjects` — find the project key
2. `getJiraProjectIssueTypesMetadata` — confirm available issue types and fields (especially the story points field name — it varies by instance, commonly `story_points` or `customfield_XXXXX`)
3. `searchJiraIssuesUsingJql` — check for existing tickets in the project related to this work
4. `getTransitionsForJiraIssue` — on any existing ticket, confirm the transition IDs for the workflow
5. `atlassianUserInfo` — resolve the current user's account ID for default ticket assignment

Cache these values mentally for the session. The transition IDs are especially important — you need the numeric ID, not just the status name, to call `transitionJiraIssue`. The current user's account ID is needed for assignment on every ticket created.

## Information Architecture

Context lives in three layers. Each layer has a job. Don't duplicate across layers.

**Epic (project context):** The epic description holds the full project plan — phasing, architecture, data models, API contracts, decisions, cross-team coordination, and open questions. This is the authoritative source of truth for the project. When a project plan document exists (a PRD, a spec, kick-off notes), the epic description should contain or closely mirror that content. The epic is read during the planning phase to ground ticket work in the bigger picture.

**Ticket (work instruction):** A ticket describes a single deliverable slice of the project. It carries enough context to understand _what_ to build and _why_, but not _how_ to implement it. The ticket opens with a brief orientation that situates this work within the epic's scope, then describes the feature behavior, constraints, and observable acceptance criteria. A reader should understand the work without reading the epic, but the epic provides deeper context when needed during planning. See the Ticket Authoring section and `references/ticket-template.md` for the format.

**Codebase (implementation context):** File paths, existing patterns, API response shapes, utility functions, component conventions — all of this lives in the code and is discovered during planning, not written into tickets. This is what makes the system accessible to non-engineer ticket authors: you don't need to know where things live in the codebase to write a good ticket.

### How Claude Code uses these layers

When executing a ticket:

1. **Read the ticket** — understand the work slice, constraints, and acceptance criteria.
2. **Read the parent epic** — absorb the full project context, architecture, data models, and decisions relevant to this ticket.
3. **Explore the codebase** — find relevant files, patterns, endpoints, and conventions.
4. **Plan** — produce a concrete implementation plan that bridges the ticket's intent with the codebase's reality.
5. **Execute** — write the code, following the plan.
6. **Transition** — move the ticket to Committed (ready for review).

## Pre-flight: All Work Flows Through Tickets

This is the core operating principle: **no implementation begins without a ticket.** Whether the request is "go build the value guide epic" or "can you fix this one bug," a ticket must exist before code is written. This ensures every piece of work is tracked, reviewable, and has a clear definition of done.

Before starting any implementation work, run this check:

1. **Search for an existing ticket.** Use `searchJiraIssuesUsingJql` or `search` (Rovo) to find tickets matching the requested work. Search by keywords from the request, relevant epic, or project area.

2. **If a ticket exists and is well-formed** (has description, constraints, and acceptance criteria that meet the authoring standard): pick it up and begin the execution flow — transition to In Progress, plan, execute, transition to Committed.

3. **If a ticket exists but is thin or poorly written** (missing description, vague acceptance criteria, no constraints): enrich it before executing. See the Ticket Enrichment section below.

4. **If no ticket exists:** create one before starting work. For epic-scoped work, follow the full Ticket Authoring guidelines with orientation, description, constraints, and acceptance criteria. For standalone work (bug fixes, one-off improvements), create a lighter ticket — see Standalone Tickets below.

This pre-flight applies regardless of how the work was initiated. A request from a human, a ticket from the backlog, or the next item in an epic sequence all go through the same check.

## Ticket Enrichment

When a ticket exists but doesn't meet the authoring standard, enrich it before executing. The goal is to bring the ticket up to a quality level where the planning phase can work effectively — the agent needs to understand the feature behavior, the boundaries, and what "done" looks like.

### Assessing Completeness

Read the ticket and check for:

- **Orientation present?** Does the ticket explain where this work fits in the bigger picture? If there's a parent epic, does the orientation connect to it?
- **Feature behavior described?** Can you understand what the user will see and interact with? Are the data fields and interaction patterns named?
- **Constraints defined?** Are there explicit boundaries on scope? Does the ticket say what's out of scope or what patterns to follow?
- **Acceptance criteria verifiable?** Are there observable statements about what "done" looks like? Can you check each criterion by using the feature?

A ticket doesn't need to be perfectly written to be workable. The bar is: can the planning phase bridge from this ticket to a concrete implementation plan? If any of the four elements above are missing entirely, the ticket needs enrichment.

### Enrichment Process

1. **Gather context.** Read the parent epic if one exists. Check sibling tickets for patterns and related work. Review any linked documents or conversation context.

2. **Draft the enriched description.** Fill in missing sections following the Ticket Authoring guidelines. Preserve anything the original author wrote — enrichment adds to the ticket, it doesn't replace the author's intent. If the original description has useful information but is unstructured, reorganize it into the standard format.

3. **Update the ticket in Jira.** Use `editJiraIssue` to update the description with the enriched version.

4. **Add a comment.** Use `addCommentToJiraIssue` to note that the ticket description was enriched with additional context from the epic and codebase. This creates an audit trail so the reviewer knows the agent interpreted the work, not just the original author.

### What Enrichment Does NOT Do

Enrichment fills in the _what_ and _why_ — it doesn't add implementation details. Don't add file paths, endpoint URLs, or code-level instructions during enrichment. Those belong in the planning phase. The enriched ticket should still be readable by a non-engineer.

Enrichment also doesn't change the intent of the ticket. If the original ticket says "add search to the hub page," the enriched version elaborates on what that search experience looks like — it doesn't expand scope to include building the search backend.

## Standalone Tickets

Not all work lives in an epic. Bug fixes, one-off improvements, small refactors, and ad-hoc requests are standalone tickets. They follow the same authoring structure but the orientation describes the work's purpose directly instead of situating it within a larger project.

A standalone ticket's orientation might read: "The predictive search endpoint occasionally returns stale results when the Elasticsearch index is mid-reindex. This ticket adds a cache-busting mechanism to ensure fresh results." No epic reference needed.

Standalone tickets still get constraints and acceptance criteria. Even a quick bug fix benefits from explicit boundaries ("fix the stale results issue without changing the indexing pipeline") and verifiable done conditions ("search results reflect items listed within the last 5 minutes").

For truly small work (under an hour, single-file change), the ticket can be lightweight — a title, a couple sentences of description, and 2-3 acceptance criteria. The point is to have a record, not to over-document trivial changes.

## Ticket Authoring

Every ticket follows a consistent structure. See `references/ticket-template.md` for the full template with examples.

### Title Convention

Use a project-scoped prefix with a sequence number: `{PREFIX}-{SEQ}: {Short Description}`

The prefix is a short identifier for the project or feature area (e.g., `VG-Web` for Value Guide web work). The sequence number establishes execution order. The description is a concise summary of the deliverable.

Examples: `VG-Web-1: Hub Page Shell & Data Loading`, `VG-Web-2: Predictive Search (Models Only)`

### Description Structure

**Orientation (1-2 sentences).** Situate this ticket within the project. What is the broader feature, and what piece does this ticket deliver? This gives a reader immediate context without needing to read the full epic. Write it as natural prose, not a reference link.

**Feature description (1-3 paragraphs).** Describe the user-facing behavior being built. Be specific about what appears on screen, how the user interacts with it, and what data drives it. Name the data fields, describe the interaction patterns, call out any non-obvious behavior. Write this at the level of "what the feature does," not "how to code it."

For data-driven features, describe the data conceptually: "Each category section shows a scrollable row of model cards displaying the model image, name, median resale price, and total sales count." Don't specify endpoint URLs or response field names — that's planning-phase work.

**Constraints.** Explicit boundaries on the work. What is out of scope? What existing patterns should be followed? What should _not_ be built? Constraints prevent scope creep and are especially valuable for agent execution because they eliminate ambiguity about boundaries.

**Acceptance Criteria.** Observable, verifiable statements about what "done" looks like. Write these as behaviors someone can verify by using the feature — not as implementation instructions.

Good: "Selecting a size filter updates the displayed median price and sales count to reflect only matching sales." Bad: "Call the endpoint with filter params and re-render the stats component."

Good: "Category sections load and render independently — a slow response from one category doesn't block others." Bad: "Use Promise.all with independent fetch calls per category."

### Decomposition Heuristics

When breaking a project plan into tickets, split when:

- The work can be reviewed independently. If you could merge one piece without the other and the app still works (even if incomplete), they're separate tickets.
- There's a natural data or interaction boundary. Search is a different interaction pattern than browsing. Filter-based recalculation involves a different API round-trip than static display.
- A meaningful blocking relationship exists. The page shell must exist before components can be added to it.

Combine when:

- Splitting would create tickets that take less than a couple hours and have no standalone value.
- The pieces are so tightly coupled that reviewing one without the other is meaningless.

### Placeholder Tickets

For work that's planned but not yet ready for execution (future phases, backend work that depends on investigation, etc.), create lightweight placeholder tickets. These need only a title, a brief description of what the phase covers, and any known prerequisites. They exist to maintain visibility in the backlog, not to instruct execution.

## Sequencing

Tickets within an epic execute in a defined order. Express this order through two mechanisms:

**Sequence numbers in titles.** Every ticket gets a sequence number in its title prefix (e.g., `VG-Web-1`, `VG-Web-2`). This is the primary ordering mechanism. Claude Code sorts by sequence number and executes in order.

**Sequencing summary in the epic description.** At the top of the epic description (or in a clearly marked section), include a short ordered list of ticket keys with one-line summaries:

```
## Execution Sequence
1. VG-Web-1: Hub page shell, routing, and parallel data loading
2. VG-Web-2: Predictive search filtered to models, routed to VG detail
3. VG-Web-3: Popular models pills derived from category data
4. VG-Web-4: Category sections with Shape-sorted personalized ordering
5. VG-Web-5: Category listing page with sort modes
...
```

This gives the executing agent a single place to read the full plan before diving into individual tickets. Update this list as tickets are created.

### Sequencing Principles

- **Shell before content.** Page structure and routing come first. Components that live on the page come after.
- **Independent before dependent.** If ticket B uses data or patterns established by ticket A, A comes first.
- **Core before peripheral.** The main feature screens come before entry points, analytics, or polish work.
- **Placeholders last.** Future-phase placeholder tickets go at the end of the sequence.

## Lifecycle

Tickets move through four statuses. The skill manages transitions using `getTransitionsForJiraIssue` (to find transition IDs) and `transitionJiraIssue` (to execute transitions).

**To Do** — The ticket is written and ready to be picked up. This is the starting state.

**In Progress** — Work has begun. Transition to this status when Claude Code starts executing the ticket (after planning, at the start of implementation). This signals to human reviewers that the work is active.

**Committed** — Implementation is complete and ready for human review. This is the handoff point. Claude Code transitions to Committed after finishing the work. **This is the automation boundary.** Claude Code stops here and does not advance tickets further.

**Staged** — The human reviewer has approved the work. This transition is manual — Nick reviews the implementation, provides feedback or approves, and advances to Staged. If feedback requires changes, the ticket moves back to In Progress.

### Transitioning Tickets

To transition a ticket:

1. Call `getTransitionsForJiraIssue` with the ticket key to get available transitions and their IDs.
2. Find the transition that moves to the target status.
3. Call `transitionJiraIssue` with the transition ID.

Transition IDs are instance-specific — always query them rather than hardcoding.

## Assignment

**Every ticket must have an assignee.** When creating or updating tickets, always set the assignee field.

- If the user specifies an assignee by name, use `lookupJiraAccountId` to resolve their name to an account ID, then assign the ticket to that account.
- If no assignee is specified, assign the ticket to the current user (me). Use `atlassianUserInfo` to get the current user's account ID during discovery, and use that ID as the default assignee for all tickets created in the session.

Set the assignee in the `createJiraIssue` call via the `assignee` field (`{ "accountId": "<id>" }`). For existing tickets that are unassigned, use `editJiraIssue` to set the assignee when picking them up.

## Estimation (Story Points)

**Every ticket must have a story point estimate.** Use Fibonacci values: 1, 2, 3, 5, 8, 13, 21.

Estimate liberally — round up, not down. Software work consistently takes longer than expected, and generous estimates create breathing room for edge cases, testing, and iteration. When in doubt, go one Fibonacci number higher.

### Estimation Guidelines

| Points | Scope | Example |
| --- | --- | --- |
| 1 | Trivial change, single file, < 30 min | Fix a typo, update a config value |
| 2 | Small, well-scoped change across 1-2 files | Add a new field to an existing form |
| 3 | Moderate work, clear path, a few files | Add a new API endpoint with basic CRUD |
| 5 | Meaningful feature slice, multiple files, some unknowns | Build a new page with data loading and components |
| 8 | Substantial feature work, cross-cutting concerns | Full search experience with filters and pagination |
| 13 | Large feature, significant complexity or integration work | New multi-step workflow with state management |
| 21 | Epic-sized — consider breaking this down further | Full feature area from scratch |

When creating tickets, set story points in the `createJiraIssue` call. The field name varies by Jira instance — discover it during project setup via `getJiraIssueTypeMetaWithFields` and look for the story points or estimation field. Common field names: `story_points`, `story_point_estimate`, or a `customfield_XXXXX`.

For existing tickets without estimates, add story points via `editJiraIssue` when picking them up.

## Creating Tickets from a Project Plan

When given a project plan (document, spec, PRD, or conversation context) and asked to create tickets:

1. **Understand the project scope.** Read the full plan. Identify phases, features, screens, and decisions.
2. **Identify the deliverable slices.** Apply the decomposition heuristics to find natural ticket boundaries.
3. **Sequence the slices.** Apply the sequencing principles to determine execution order.
4. **Draft the tickets.** Write each ticket following the authoring guidelines. Start with the orientation, describe the feature behavior, add constraints and acceptance criteria.
5. **Confirm with the user.** Present the proposed tickets (titles and brief summaries) before creating them in Jira. The user may want to adjust granularity, reorder, or add/remove tickets.
6. **Create in Jira.** Use `createJiraIssue` for each ticket. Link them to the parent epic. Add sequence labels or title prefixes. **Set the assignee** (specified person or default to current user) and **set story points** (Fibonacci estimate, round up generously) on every ticket.
7. **Update the epic.** Add the sequencing summary to the epic description.

When creating tickets, the user may provide the plan in different forms — a document attachment, a pasted spec, a conversation where they've been talking through the feature. Adapt to whatever form the context takes, but always produce tickets that follow the authoring structure.

## Picking Up Work from an Epic

When asked to execute work from an epic (e.g., "go build the value guide"):

1. **Find the epic.** Use `searchJiraIssuesUsingJql` to locate the epic by name or key.
2. **Read the epic description.** Absorb the full project context.
3. **Find child tickets.** Query for tickets linked to or within the epic, sorted by sequence.
4. **Identify the next ticket.** Find the first ticket in To Do status (by sequence number).
5. **Run pre-flight.** Assess the ticket's completeness. If it needs enrichment, enrich it before proceeding.
6. **Transition to In Progress.** Signal that work has begun.
7. **Plan the implementation.** Read the ticket, read the epic for context, explore the codebase, produce a plan.
8. **Execute.** Implement the work.
9. **Transition to Committed.** Signal the work is ready for review. Stop and wait for human feedback.

## Picking Up Ad-hoc Work

When asked to implement something with no ticket reference (e.g., "fix the search bug" or "build a filter component"):

1. **Search for an existing ticket.** Check Jira for tickets matching the described work.
2. **If found:** run pre-flight (assess completeness, enrich if needed), then execute.
3. **If not found:** create a standalone ticket following the authoring guidelines — include assignee and story points — then execute.
4. **Follow the same execution flow** — transition to In Progress, plan, execute, transition to Committed. If the ticket is missing an assignee or story points, set them when picking it up.
