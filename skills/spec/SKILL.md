---
name: "spec"
description: "Spec-driven workflow for a git repo, applied automatically. Use whenever the user designs, plans or changes a project that lives in a repo (talking naturally, no command needed), reports bugs, playtest or usage feedback on it, asks where the project stands or what to do next, or types /spec, /spec ?, /spec run or /spec autorun."
---

# /spec

One skill for the whole workflow. The repo is the source of truth: every decision lands in it as a file, never only in the conversation, so any session can pick up where another stopped.

## How it is used

The user talks naturally; you apply this skill on your own. Say in one line when you do ("I'll record this in the repo"). Only four things are typed:

| Typed | What you do |
|---|---|
| `/spec` | A short guide for someone new to it (see below) |
| `/spec ?` | Status: where the project stands and what to do next. Same when asked in words ("where is the project?", "what should I do?") |
| `/spec run [NNN ... or all]` | Claude Code only: implement `ready` specs. Without a number, list them and ask which. Without a code environment, say it needs Claude Code |
| `/spec autorun [vision]` | Claude Code only: design and build alone while the user is away, on its own branch (see Autorun) |

**The `/spec` guide**: under ten lines, from the user's side, no internals. Start with `/spec ?`: it finds the repo, offers to set it up if needed, and says what to do next. Then talk about your project normally: decisions are recorded in the repo after a short recap and one yes. `/spec ?` shows where it stands and what to do next. `/spec run` builds the `ready` specs, tests first. `/spec autorun <vision and goals>` designs and builds alone while you are away; you review one pull request on return. Bugs and small tweaks you report are fixed at once; the rest becomes a spec. Give details only when asked.

Everything else is automatic: starting or adopting a project (Init), design talk (Recording), feedback on what exists (Four lanes), discussing a draft or a proposed ADR (Review), resuming a project (short status).

- Repo access: git in Claude Code, the GitHub connector in chat. If the repo is unclear, ask which one.
- Docs commits (`docs: ...`): in Claude Code, on the current branch; in chat, on the default branch (or the branch named in CLAUDE.md). Confirm each write in one line: file and commit.
- If CLAUDE.md names a docs check command (e.g. `sh scripts/check-docs.sh`), run it before every docs commit and fix what it reports.

## Your stance: expert advisor, user decides

The user is not an expert in everything. When an idea, a criterion or a choice looks weak, say so plainly and recommend the better option with its reason, then let the user decide. Never change what a spec asks for on your own: suggestions go in writing (see Running), so they stay traceable. How to build it is yours to decide well.

## Where truth lives

- **Current-truth docs** describe what holds now: architecture, domain rules, one sheet per module or domain, glossary. Short, self-contained, each rule linking to its ADR when one exists. `docs/README.md` indexes them (one line each). They are what an implementer reads, and **every run keeps them up to date**.
- **Specs** are change requests. Once `done`, they are history: the rules they introduced live in the current-truth docs.
- **ADRs** record *why* a costly decision was made and what was rejected. They do not carry project context: they link the current-truth docs instead. Read them only to question or replace a decision, or when a spec links one.
- A design change updates the current-truth doc first, then adds the ADR.
- An accepted ADR binds new code. Existing code that does not follow it yet is not a contradiction: it is work for a spec.

## Formats

Nothing under `docs/` is required. Create a file or folder only when there is real content; no placeholders. Numbers are sequential, 3 digits: next = highest existing number + 1, and check it is unused before writing. Project additions in `docs/README.md` override these formats, but never remove a field the checks rely on (spec statuses and `depends`, ADR `Status`, `Type` and `Scope`).

**Spec** - `docs/specs/NNN-slug.md`

```markdown
---
status: draft | ready | in-progress | done
depends: SPEC-NNN            # optional: must be done first
supersedes: SPEC-NNN (AC2)   # optional: earlier behavior this spec replaces
context: [path, path#section] # current-truth docs needed, relative to docs/; 2-5 entries
---
# SPEC-NNN: Title
## Why
## Acceptance criteria
- [ ] AC1: When <trigger>, the system shall <response>.
## Out of scope
## Open questions
## Plan                   <!-- filled by /spec run -->
## Implementation notes   <!-- filled by /spec run: assumptions, suggestions -->
```

Acceptance criteria use EARS, one behavior each, each verifiable by a test or a command:

- The system shall <response>.
- When <trigger>, the system shall <response>.
- While <state>, the system shall <response>.
- If <unwanted condition>, then the system shall <response>.
- Where <optional feature>, the system shall <response>.

**Open questions** - one marker everywhere: a `## Open questions` section, in specs and in current-truth docs. Each item says what is undecided and what would settle it ("after the next playtest"). An accepted risk to watch is an open question with its trigger. If a project uses another marker, propose migrating it.

`context` lists the current-truth docs or sections the implementer needs (and an ADR only if its reasoning matters). Keep it short: it is the reading list of `/spec run`.

**ADR** (MADR-lite) - `docs/adr/NNN-slug.md`, one flat folder, one numbering

```markdown
# ADR-NNN: Title
Status: proposed | accepted | rejected | superseded by ADR-NNN - Date: YYYY-MM-DD
Type: <type>[, <type>] · Scope: <modules or domains concerned, or all> · Supersedes: <optional ADR-NNN>
## Context      <!-- the problem in a few lines; link current-truth docs, do not restate them -->
## Decision
## Alternatives rejected (and why)
## Consequences
```

- **Type**: values come from `docs/README.md`; default `product | tech | process`. `product` = changes what the user experiences; `tech` = changes only how it is built; `process` = how we work. Two types only when the decision truly constrains both. Finer topics (network, security, data...) go in `Scope`, not in new folders.
- **Scope** values come from a short list in `docs/README.md` (modules or domains, plus `all`), so one grep finds every ADR on a subject. Tag an ADR with every existing scope it constrains; between two, take both. More than three: use `all` alone. Add a value to the list only when a new module or domain appears, never for a single ADR.
- **When an ADR is warranted**: the decision is costly to undo *and* had real alternatives: framework, storage, deployment, authentication, public API or data format, structure across modules, a product rule with lasting consequences. Not for a library, naming, internal structure or test tooling: those are implementation notes.
- **Before writing one**: list the header lines of every ADR (title, Status, Type, Scope) with grep; it is cheap. Then read the bodies of those whose Scope overlaps, those with Scope `all`, and any whose title touches the subject. Scope decides what to read first, never what to skip. If one already covers the decision, follow it, or write the new one with `Supersedes:` and give the old one `Status: superseded by ADR-NNN`. Never leave two accepted ADRs deciding the same thing.
- **Immutable once accepted.** A changed decision gets a new ADR; the old one only gets its Status changed, body untouched. Header metadata (`Type`, `Scope`, project header lines) is not the decision: it may be added or corrected on an accepted ADR.

**Statuses.** A spec is `ready` only with the user's approval: explicit, or implicit when the user asked for it and the agent added nothing (see Write a spec). A `proposed` ADR was decided by an agent and waits for the user's review.

## Consistency checks

Run them in the status, before every docs commit and at the start of a run. Read frontmatter and header lines only.

- Spec and ADR numbers are unique.
- Every `depends`, `supersedes` and ADR reference points to an existing file; `depends` has no cycle.
- Every `context` path exists.
- Each `superseded by` has its matching `Supersedes` (and the reverse).
- Every ADR has a `Type` and a `Scope` line, with Scope values from the list in `docs/README.md`, at most three, and `all` only alone.
- No two `accepted` ADRs with overlapping Scope decide the same thing.
- Every spec status is one of `draft | ready | in-progress | done`.
- A `done` spec does not depend on a spec that is not `done`.

Report problems in one line each with the fix; fix them when the fix is mechanical, ask otherwise. A duplicate number: propose renumbering the later file and updating its references, and ask first. A status that breaks these rules is probably stale: compare the spec with the code and git history, propose the corrected status with the evidence, and ask first.

## Recording decisions (design talk)

While the user designs, discuss and challenge (contradictions with current rules or earlier specs, missing edge cases, scope too large, a better approach); do not interrupt each decision. Design talk never writes code.

**Record at checkpoints**, not after every decision: when the conversation leaves the current subject, moves to the next step, has piled up many decisions (about five), or seems to end. Why: one yes per batch keeps the user in control without breaking the flow. Limit: a decision that invalidates a `ready` spec is recorded at once, so no run builds it.

At a checkpoint, recap one line per element (what it is, where it lands, what it affects; under each spec, its criteria and status), ask one yes (the user may correct items), then write and commit `docs: news - <short summary>`. Mark what you inferred rather than heard.
- True now (decision, constraint, scope cut, deadline) → the current-truth doc.
- Behavior to build or change → a new spec, or an update to a `draft`.
- Costly decision meeting the ADR bar → an ADR `proposed`.
- Calls an existing spec into question → an open question on it, or a new spec with `supersedes`; a `ready` spec it invalidates goes back to `draft`.
- Unclear, or a risk accepted until evidence exists → an open question.
Something wished for is a spec, never a current-truth rule.

**Write a spec:**
- Acceptance criteria in EARS. More than ~5 criteria or more than a day of work: propose a split.
- Fill `context`, make "Out of scope" explicit, put unknowns in "Open questions" (never guess product intent), fill `supersedes` when it replaces earlier behavior.
- `ready` when the user asked for it and the spec only restates what they said (no added scope or criterion, no open question, no unanswered challenge); the checkpoint yes approves it. Otherwise `draft`, listing what you added. Specs you create on your own are always `draft`.

## Changing what exists: four lanes

Feedback on what is built (playtest, bug, "this feels off") takes the lightest lane that keeps docs and code true. Announce the lane in one line, then act.

- **Fix** - the code breaks a current-truth rule, or does something obviously wrong that no rule covers. In Claude Code, at once: a test reproducing it, the fix, commit `fix: ... (<doc>#<section>)`; if no rule covered it, add the rule in the same commit. Why: fast, and the test keeps it fixed.
- **Tune** - a value changes, not the mechanic (a stat, a cost, a delay). In Claude Code, at once: doc and code in the same commit `tune: ... (<doc>#<section>)`. Why: most playtest feedback is this; a spec per number would stop iteration. Limit: a new condition or effect is a mechanic, so a spec.
- **Spec** - new or changed behavior: recorded at the next checkpoint, built by `/spec run`.
- **Question** - intent unclear: an open question, with what would settle it.

In chat (no code), a fix or a tune becomes a short `ready` spec for `/spec run`. Whatever the lane, behavior never changes without its doc in the same commit: drift starts with one silent fix.

## Status, init, review

**Status** (`/spec ?`). Written for someone who has never seen the project. Compute it from the repo every time (frontmatter, ADR header lines, `## Open questions`, `git log`); never keep a status file. One line per item; lists longer than 5 show the first 5 and a count. In Claude Code, `git fetch` first (read-only); if the branch is behind its remote, or the remote default branch has `docs/` commits missing here, say so first with the command to get them.
0. **Repo**: none open or identified: say so, ask which one (in chat, the GitHub connector can list the user's repos), and stop there.
1. **Project**: the project line from CLAUDE.md and a link to `docs/README.md`. Not set up yet (no `docs/README.md` indexing current-truth docs, or a CLAUDE.md that does not describe this workflow): say so, show in three lines what Init would do in this repo (the docs it would write from the code, the CLAUDE.md lines it would add or change), offer it, and skip items 2 to 6.
2. **Progress**: specs done out of total, the last 3 done with their date (from `docs: done SPEC-NNN` commits, else the last commit touching the spec).
3. **Interrupted**: `in-progress` specs, with their last tagged commit and branch; they resume with `/spec run NNN`.
4. **Next to run**: `ready` specs in run order, flagging unmet `depends`.
5. **Waiting for a decision**: open questions (specs and current-truth docs, with their trigger), drafts, `proposed` ADRs.
6. **Consistency problems**, if any.
7. **Next step**: what to do or type next, and why in 2-3 sentences.

When resuming a project in a new conversation, give only items 3 and 5, plus open pull requests with unanswered comments, in three lines at most. In a repo not set up yet, offer Init once instead.

**Init** (a new project, or a repo without current-truth docs). Greenfield: discuss the product, the main principles and the stack, recommend where the user is unsure, then write the current-truth docs and `docs/README.md`; an ADR only for choices that meet the ADR bar. Brownfield: read the code structure, build files and existing docs, write current-truth docs describing what exists (flag what you inferred), and let the user correct them. Keep each doc short. In an existing repo, also:
- Sort existing docs into current truth (index them), history (list them in `docs/README.md`) and obsolete (propose deletion); wait for the user's yes before moving or deleting anything.
- Move rules in force out of ADRs and CLAUDE.md into current-truth docs, leaving a one-line link; project-specific doc rules go in `docs/README.md` as project additions.
- Give every ADR its `Type` and `Scope` line (shown for the user's yes) and write the Scope list in `docs/README.md`.
- Align the workflow rules of CLAUDE.md with this skill (current branch; a pull request only for branches a run creates; four lanes): keep everything project-specific (description, commands, conventions), add or adapt only the workflow lines, show the change and wait for the user's yes. Keep the project's own rules when the user prefers them. If the repo mirrors CLAUDE.md for other agents (`AGENTS.md`), state the workflow there in plain words, since those agents do not have this skill.
- Write `scripts/check-docs.sh` (POSIX sh, no dependency) running the mechanical consistency checks, name it in CLAUDE.md, run it and fix what it reports.

**Review** (the user discusses a draft or a proposed ADR). Take open questions one at a time: options plus a recommendation; record each answer as it is given. When none remain and the user approves, set `ready`. For a proposed ADR, summarize decision, alternatives, consequences and the code relying on it; accepted → `accepted` and update the current-truth doc it affects; rejected → `rejected`, a draft spec to change the code, and a new ADR if a different decision replaces it.

## Running: `/spec run` (Claude Code only)

All work happens on one branch: the current one, or one the run creates (`run/` or `autorun/`). No branch per spec, except the short-lived branches of parallel specs, merged back into it (see Several specs). On the current branch, no pull request: the commits are the review and rollback unit. On a branch the run created, open a pull request at the end: work done unwatched then gets one diff to review and one button to merge.

### Start of the run

1. If the working tree has uncommitted changes, stop and ask the user to commit or set them aside: a failed spec resets the branch, which would lose them. Never stash or discard them yourself.
2. **Sync with the remote** (specs are often written from the chat, straight on the remote default branch):
   - `git fetch`. No network or no remote: continue with the local state and say so in one line.
   - Current branch only behind its remote: `git pull --ff-only`. Diverged: stop and report; never merge or rebase on your own.
   - A requested spec missing here, or different on the remote default branch, while the current branch is another one: say so and ask, recommended first: **create `run/YYYY-MM-DD` from the updated default branch and continue**, or **stop**. Never copy a spec file alone from another branch: it may rely on docs changed with it. Without a user present, stop and report. With `all`, list in one line the `ready` specs that exist only on the remote, and continue.
3. If the current branch has an open pull request with unanswered review comments, handle them first, each through the four lanes, and reply to each on the pull request.
4. Run the consistency checks; stop on a problem that affects the specs to run.
5. **Branch imposed by the platform** (a cloud session that lets you push to one branch only): it takes the place of `run/...` or `autorun/...`; the brief and the pull request stay the same. Say so in one line. If that branch is the default branch, the next step applies as to any default branch; in autorun, stop at launch and say why.
6. If the current branch is the default branch (or the one named in CLAUDE.md):
   - **Saved choice** (`git config --local spec.runOn`): `default` → commit and push on it; `run-branch` → create `run/YYYY-MM-DD` from here. Apply it without asking, and say so in one line with how to change it: `git config --local --unset spec.runOn`.
   - **No saved choice**: ask once with a clear warning, "No" first and recommended (the user can still answer "stop"):
     - **No - create `run/YYYY-MM-DD` from here and continue** (recommended)
     - **No - same, and remember for this project**
     - **Yes - commit and push on <branch>**
     - **Yes - same, and remember for this project**
     "Remember" runs `git config --local spec.runOn run-branch` (or `default`): local to this clone, never pushed. Without a question tool or a user present, take the first option and save nothing.
7. Order the specs: dependencies first, then by number. Skip any whose `depends` is not `done` and is not in this run.

### For each spec

0. **Resume.** If the spec is already `in-progress` (an interrupted run), read its `## Plan` and its tagged commits since `docs: start SPEC-NNN`, and continue from the first unfinished step. If those commits are not on the current branch, say which branch has them and stop.
1. **Check.** Read the spec, its `context` files, ADRs it links explicitly, and the code it touches. Do not load the rest of `docs/`. Without `context`, read the current-truth docs of the modules the spec names. Non-empty "Open questions" or a contradiction between spec, current-truth docs and code means blocked (see Decisions).
2. **Start.** Set `status: in-progress`, commit `docs: start SPEC-NNN`.
3. **Tests first (red).**
   - No test framework yet: set one up and add its commands to CLAUDE.md.
   - One test per acceptance criterion, named after it: `SPEC-NNN AC1: ...`.
   - Run them and confirm each fails for the expected reason. Commit them alone: `test: acceptance tests (SPEC-NNN)`.
   - Exception, only for visual-only UI, configuration or infrastructure: describe the manual check under Implementation notes instead.
4. **Implement (green).** Write a short task list in `## Plan`; no approval needed, `ready` is the approval. Implement until the tests pass, refactor, commit per task (Conventional Commits, `(SPEC-NNN)` in every message). The tests from step 3 are locked: if one looks wrong, the spec is wrong, so it is blocked.
   - When a module folder is created or first touched and has no `CLAUDE.md`, add a short one pointing to its current-truth doc (what the module owns, link, local conventions).
5. **Update the current truth.** Write the rules this spec put in force into the current-truth docs listed in `context` (or create the right doc and index it in `docs/README.md`). If `supersedes` is set, append `(superseded by SPEC-NNN)` to the replaced criterion in the earlier spec.
6. **Verify, at the right cost.** Fast checks (typecheck, unit tests) run in full for every spec: a regression is caught on its own commit, and undoing a spec stays a plain revert. Slow checks (browser, end-to-end, visual) run only on what the spec touches, then in full after each merge and at the end of the run, where cross effects show. While developing, only the related tests. Limits: if you cannot tell what a spec touches, run everything. A check that fails then passes on a rerun is flaky, not green: stabilize it (fix lane) or record it as an open question, and name it in the report.
   - CLAUDE.md says which commands are slow and how to target them; if it does not, add that line (a docs commit) and mention it in the report. If the commands exist and the repo has no CI yet, add a minimal CI running the fast ones (`ci: ...` commit).
7. **Close.** Tick the criteria, fill `## Implementation notes`, set `status: done`, and commit that alone as `docs: done SPEC-NNN`, even right after another docs commit: the status dates finished specs from this message.

**The branch is never left broken.** If a spec cannot reach green or becomes blocked after its start commit, reset the branch to the commit before `docs: start SPEC-NNN` (only this run's unpushed commits), then set the spec back to `draft` with the question and commit that.

### Decisions the spec did not make

Judge by the cost of being wrong:

- **Cheap to undo** (naming, internal structure, a library, test tooling): decide with your best judgement, list the notable ones under `## Implementation notes`.
- **Costly to undo, with a reasonable default** (meets the ADR bar): decide, write an ADR with `Status: proposed` after the ADR check, link it in Implementation notes. Do not change current-truth docs for it until the user accepts it.
- **Costly, and depends on product intent**: blocked. With a single spec, ask now. With several, set it back to `draft` and skip it and every spec that depends on it.
- **You think the spec itself could be better**: implement it as written if it is still sound and add the suggestion under Implementation notes; if building it as written would be harmful (security, data loss, contradiction with an accepted ADR), it is blocked.

### Several specs (`all` or a list)

- **One fresh subagent per spec**, to keep each context small. Its prompt: "Load the /spec skill. Run SPEC-NNN following its 'For each spec' section, on branch <branch>. Never ask the user: if blocked, apply the blocked rule and report." The orchestrator handles the start of the run, the merges and the end. Never ask questions during the run; everything waiting for the user goes in the final report.
- **Independent specs run in parallel, 2 or 3 at once**: no `depends` between them, and no code they both reshape (same component, same engine function). Why: the run finishes sooner. Limits: in doubt, one after the other; a spec that depends on another or touches its code waits for its merge; parallel spends the same quota faster, so after a run that hit the usage limit, stay serial.
- **One worktree and branch per parallel spec** (`<run-branch>-NNN`, from the run branch), in a folder the test runner and dev server ignore (e.g. `.claude/worktrees`; set that up first). Why: two agents in one tree corrupt each other's commits and test runs. Tell each agent which files the others are changing, so it keeps its edits there small. Agents never push to the run branch: the orchestrator's tree only receives merges.
- **Merge as each one ends** (`--no-ff`: one merge commit per spec), then run the full checks and the consistency checks, and reread every current-truth section both sides changed. "Both added" is fine for a glossary, an index or a stylesheet; two rules for the same thing is a contradiction to resolve. Then start what the merge unblocks.
- **Repo-wide checks** (visual audit, dev server, end-to-end tests) run once, by the orchestrator, after merges; agents describe the visual checks they need.
- A parallel spec that fails: delete its worktree and branch, set the spec back to `draft` with the question.

### End of the run

- Run the full test suite and checks once more, to catch regressions between specs.
- Push the branch (on the default branch only if the user said yes at the start or the saved choice is `default`).
- If the run created the branch, open a pull request into the default branch (not a draft), titled with what it holds ("Autorun 2026-11-08: 4 specs, 2 items for you"), with the report as its description. Merging it is the approval; closing it and deleting the branch undoes the run. No pull request without a GitHub remote or when the project's rules forbid it; without a tool to open one, put the report in the last commit message, so it stays with the branch.
- Report in a few lines (the pull request description when there is one): branch, specs done with their commit range (`git log --oneline --grep "SPEC-NNN"`) and the slow checks each one ran, flaky checks found, specs sent back to `draft` with their question, proposed ADRs, suggestions worth a look. Add how to undo one spec: `git revert -m 1 <merge>` for a merged parallel spec, else `git revert <first>^..<last>`.

## Autorun: `/spec autorun` (Claude Code only)

The user is leaving (asleep, out) and wants the work to go on with no input. Everything lands on its own branch: merging it is the user's approval, deleting it undoes the night.

### Before the user leaves: the only exchange

1. **Environment.** A cloud session (isolated container) is the recommended place. On the user's own machine, ask first, as a two-choice question when available: **Stop - relaunch in a cloud session** (recommended) / **Continue here - you will act without approval on this computer**. Only an unambiguous choice of the second continues; any other answer, including one that mixes "ok" with stopping, means stop. Stopping ends the autorun at once: no other question, nothing written. Say in two lines how to relaunch (open a Claude Code cloud session on this repo, type `/spec autorun`).
   Either way, the session must approve actions on its own, or the run stalls at the first approval prompt: if you cannot tell, ask. That setting is the user's; you cannot change it.
2. Clean working tree and sync, as in Start of the run.
3. **Time away.** Ask until when the user is away. Stop a quarter of an hour before, to leave time for the final checks. The time sizes the plan: half an hour is a few fixes; five hours can carry a theme.
4. **Brief.** A vision given with the command (`/spec autorun <vision and goals>`) is the starting point: skip the five-minutes question, challenge it and propose the brief as below. Otherwise ask whether the user has five minutes.
   - Yes: the user gives a vision ("rework the UI into a polished game with a HUD and animations") or asks for yours (from the project vision, open questions and `ready` specs). Challenge it for the time available: risks, what is out of reach, a smaller version that fits. Then propose one brief: goal, in and out of scope, stop conditions. One yes.
   - No: the brief is `ready` specs and fixes only. Without a written vision or a brief from the user, never design new features.
5. Create `autorun/YYYY-MM-DD` from the updated default branch (whatever `spec.runOn` says; a branch imposed by the platform replaces it, see Start of the run), record the brief in an empty commit `chore: autorun brief`, push. From here on, never ask anything.

### While the user is away

- **Order**: `ready` specs first (see Several specs), then fixes, then design within the brief. A spec you write here gets `by: autorun` in its frontmatter and may be `ready` on this branch: the brief approved it, the merge will confirm it. Tune a value only on evidence (a test, a simulation, a playtest note), never by taste.
- **Off-limits**: anything that costs money, breaking changes (data formats, saves, public API), work beyond about a day, security-sensitive changes, removing a feature, product decisions outside the brief. Note it for the user and switch subject. Why: these cannot be undone by deleting a branch.
- **Going in circles**: the same test still fails after three real attempts, or an item stops progressing. Pause, restate the problem and weigh the cost of going on; usually reset the item, write what you learned as an open question, and switch subject. If a skill describing the user's way of reasoning is available, load it for design choices and loops; otherwise go on without it.
- **Stop** at the first of: the stop time, the brief's goal reached, nothing useful left in the brief, two items abandoned in a row. Usage limits can end the session at any moment: commit and push after every step so nothing is lost.

### For the user's return

Run the full checks, push, open the pull request (see End of the run) and end with the report: what was done, per spec with its commits; what waits for the user (off-limits items, open questions, drafts, proposed ADRs); how to review: merge the pull request to keep it all, comment on it for a later session to fix, `git revert` to drop one spec (see End of the run), close it and delete the branch to drop the night.