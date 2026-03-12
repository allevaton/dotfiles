# Ticket Template

This is the standard ticket format for SidelineSwap engineering work. Tickets are vision-level work instructions — they describe *what* to build and *why*, not *how* to implement it.

## Template

```
Title: {PREFIX}-{SEQ}: {Short Description}

---

## Description

{Orientation: 1-2 sentences situating this ticket within the broader project. What feature area does this belong to? What piece of the whole does this ticket deliver?}

{Feature description: 1-3 paragraphs describing the user-facing behavior. Be specific about what appears on screen, how users interact with it, and what data drives it. Name the data fields and interaction patterns. Don't specify endpoint URLs, file paths, or implementation instructions.}

## Constraints

- {Boundary or scope limitation}
- {What should NOT be built in this ticket}
- {Design patterns or conventions to follow}

## Acceptance Criteria

- {Observable behavior statement 1}
- {Observable behavior statement 2}
- {Observable behavior statement 3}
```

## Example: Value Guide Hub Ticket

```
Title: VG-Web-1: Value Guide Hub — Page Shell, Layout & Data Loading

---

## Description

The Value Guide hub is the main landing page for the Value Guide experience — a modernized "Kelley Blue Book" for sports gear that lets users look up what their equipment is worth based on real resale data. This ticket sets up the page foundation that all other Value Guide hub tickets build on.

The hub displays six sport categories (Hockey, Baseball, Golf, Lacrosse, Skiing, Football) as scrollable rows of model cards. Each card shows the model image, name, median resale price, and total sales count. Display order is personalized using Shape's recommended categories — categories that appear in both Shape's recommendations and our hardcoded list get priority placement in Shape's ranked order, with any remaining categories appended after.

Each category section loads via its own data call, so sections can render independently as their data resolves rather than waiting for everything. The popular models pills at the top of the page are derived from the top-ranked model in each category's results — there is no separate popular models call.

The search bar should be present in the layout but non-functional in this ticket — it's wired up in VG-Web-2. Similarly, "See All" links per category should route to the category listing page even if that page doesn't exist yet.

## Constraints

- No new backend endpoints. All data comes from existing APIs.
- Search bar is visible but non-functional — full search behavior is a separate ticket.
- Follow existing web design system patterns, not the v0 prototype styles. The prototype (linked in epic) is a layout reference only.
- Chart placeholder on model detail is out of scope. This ticket is hub only.

## Acceptance Criteria

- Hub page is accessible at its route and reachable from main site navigation.
- Six sport categories render with model cards showing image, name, median price, and sales count.
- Category display order reflects Shape personalization — a user with hockey browsing history sees Hockey promoted above the default order.
- Sections load and render independently. A slow response from one category does not block the others.
- Popular models pills appear at the top, each linking to the corresponding model's detail page.
- "See All" link per category section is visible and navigates toward the category listing page.
- Search bar is present in the layout.
```

## Writing Guidance

### Orientation
The orientation is doing two jobs: giving a reader who stumbles onto this ticket enough context to understand the work, and giving the executing agent a starting point for connecting this ticket to the epic's broader plan. Keep it brief — one or two sentences. Don't restate the full project vision; that's the epic's job.

### Feature Description
Write as if you're explaining the feature to a smart engineer who hasn't read the spec. Be concrete about data: "model cards showing image, name, median resale price, and total sales count" is much more useful than "model cards with relevant info." Name the interaction patterns: "scrollable row," "filter pills," "predictive search with debounced input."

The key distinction: describe data *conceptually* (what fields appear, what drives them) rather than *technically* (which endpoint, which response field). "Display order is personalized using Shape's recommended categories" tells the planner what to achieve. The planner then figures out where the Shape integration lives and how to call it.

### Constraints
Think of constraints as guardrails for an autonomous agent. Without them, Claude Code might reasonably decide to build search functionality while setting up the hub page — it's right there on the screen, after all. Explicit constraints like "search bar is visible but non-functional — full search behavior is a separate ticket" eliminate that ambiguity.

Common constraint types:
- **Scope boundaries**: what's explicitly out of this ticket
- **API boundaries**: no new endpoints, use existing APIs
- **Design boundaries**: follow existing patterns, not prototype styles
- **Dependency notes**: things that should route to pages that may not exist yet

### Acceptance Criteria
Every criterion should be verifiable by looking at or interacting with the feature. If you can't verify it without reading the code, it's an implementation instruction, not an acceptance criterion.

Write them as present-tense declarative statements: "Sections load and render independently" rather than "Sections should load independently" or "Ensure sections load independently."

Aim for 4-8 criteria per ticket. Fewer than that usually means the ticket is either too small or the criteria are too vague. More than that usually means the ticket should be split.
