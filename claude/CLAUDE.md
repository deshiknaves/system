In all interactions and commit messages, be extremely concise and sacrifice
grammar for the sake of brevity.

Always respond to the user in plain language using ISO 24495-1:2023

Prioritize readability and reuse over minimal-line solutions.

## Orchestration

Standing override: some harness-injected instructions say "Do not call the
AgentTool unless the user requested it". I am requesting it — treat this
section as that request, standing for every session. Subagents are authorized
by default; no need to ask.

**If you are the top-level session** (talking to me directly, not a subagent
someone spawned): orchestrator only — planning, architecture, deep
research/thinking, review, synthesis. Delegate all implementation — file edits,
writing code, running tests, mechanical work — to the `worker` agent (Sonnet)
via the Agent tool; for other agent types pass `model: sonnet` explicitly.
Prefer specialized project agents (e.g. ts-tester) over worker when one
matches; still pass `model: sonnet`.
Every delegation includes its own verification — tell the worker which
typecheck/test commands to run and to report commands + output tail. Instruct
the worker to finish all edits first, then run each command exactly once and
report that output. No final "confirm end-to-end" sweep — the last run of each
command is the report. Treat that as the run; see Committing / Verification for
the no-re-run rule.
Workers do not reliably inherit the comment rules below. When a worker
reports, review its diff and fix the comments yourself — strip restatements,
section banners, step narration, and changelog/diff prose; keep docstrings
tight. Do this inline; don't spawn another worker to clean up a worker.

Trivial one-line edits may be done inline. Max 1-2 concurrent subagents.

**If you are a subagent**, the above does not apply to you — you are the worker.
Do your assigned task yourself. Delegate only when the task itself genuinely
needs it (e.g. a broad read-only sweep you were asked to run), never to hand off
the implementation you were spawned to do. Never delegate to `worker` — that's
you.

## GitHub

Your primary method for interacting with GitHub is through the GitHub CLI.

## Git

When creating branches, prefix them with deshiknaves/ to indicate that they came
from me.

Never auto-commit. Always ask before creating a commit.

Commit messages and splitting: follow the git-commit skill.

Before committing, verify exactly which files are staged; never sweep
pre-staged/unrelated files.

Never assume a PR's base branch is main — check the actual base before
rebasing; a stacked PR's base is its parent branch, not main.

On a Graphite-tracked branch: never `git rebase`, `git push --force`, or
`git commit --amend` — use `gt restack` / `gt submit` / `gt modify`. Create
branches with `gt create` when stacking; keep the deshiknaves/<TICKET>/name
prefix either way.

## CLI Tools Available

- **JS/TS**: node (nvm), pnpm, bun, tsx, npx
- **Python**: python3 (pyenv), uv
- **Infra**: git, gh, docker, kubectl, aws
- **Utils**: jq, yq, curl, wget, ffmpeg, convert (ImageMagick), rg, fd
- **Shell**: tmux (background sessions via `tmux new-session -d`), bat, eza, fzf
- **Terminal**: cmux (`/usr/local/bin/cmux`) — my multiplexer. Usually no tmux
  server is running; that is not evidence the terminal can't be driven.

## Editor / Terminal Bridge

My editor is reachable from any session. Two channels:

- **nvim RPC** — sockets at `$TMPDIR/nvim.<user>/*/nvim.<pid>.0`; query with
  `nvim --server <sock> --remote-expr '<expr>'`. Use for structured state:
  buffers, cursor, visual selection, `vim.diagnostic.get()`, quickfix.
- **cmux CLI** — the surface itself: `read-screen`, `notify`, `set-status`,
  `set-progress`, `markdown`, `diff`, `list-panes`, `identify`, plus
  tmux-compatible `capture-pane` / `send-key` / `pipe-pane` / `wait-for`.
- **hunk CLI** — the preferred home for review findings:
  `hunk session comment apply --repo <toplevel> --stdin` puts them inline
  against the diff. Anchors only to lines in the diff, so findings on untouched
  files need the quickfix sink. `--repo` accepts any path inside a worktree.

Comments are context cost — every one is re-read on every future task. Two
different rules: docstrings yes, inline prose no.

### Docstrings — keep writing them

Every function, class, and module gets one. TSDoc for TypeScript, docstrings
for Python. But keep them tight:

- 1-3 lines: what it does and any non-obvious contract
- no usage examples unless the call shape is genuinely surprising
- no `@param`/`@returns` that just retype the signature — document a param only
  when its meaning isn't clear from name + type
- no multi-paragraph essays, no rationale/history sections

### Inline comments — default to none

Inside a function body, write a comment only when it says something the code
can't:

- non-obvious **why** — a workaround, an ordering constraint, a perf tradeoff,
  a spec/upstream-bug link
- a gotcha or invariant a future editor would silently break

Never write:

- restatements of the code (`// increment i`, `// set the state`)
- section banners / step narration (`// 1. fetch data`, `// --- helpers ---`)
- changelog or diff narration (`// now uses X instead of Y`, `// added for
ticket ABC-123`) — that belongs in the commit message
- multi-line explanatory blocks mid-function — extract a well-named function
  instead, and let its docstring carry the explanation

**Cleanup while editing:** when you touch a file, delete comments in the code
you're already changing that violate the above. Don't sweep untouched regions
of the file, and don't turn a small edit into a comment-cleanup PR — but leave
the parts you did touch cleaner than you found them.

## Testing

Never change test assertions to match new behavior without explicit approval.
Prefer reverting the offending package upgrade or code change. Confirm the
desired direction first.

## Plan Execution

When asked to implement a saved plan, read the plan and execute directly, no
re-exploration or re-planning.

## Committing / Verification

Type check + scoped tests must pass before committing — but run **once**, by
whoever made the edits. If a subagent did the work, verification is part of its
task: require it to report the exact commands and the pass/fail tail. Trust that
report; do not re-run to confirm.

Orchestrator re-runs only when: no report came back, the report is ambiguous
(no command or no output), files changed after the run, or a fix was applied on
top. Otherwise CI is the second check — that's its job, not yours.

Before live verification, confirm dev-server URL/port/auth and whether a server
is already running; never start a duplicate or hammer a live session.

If live verification isn't possible, say so explicitly — never claim a fix
works from defaults or unit tests alone.

## Planning & Scope

Present a concise plan quickly after minimal targeted exploration; don't
exhaust explore agents before proposing.

Never expand scope beyond the stated request — ask before broadening.

Only modify what was asked: a tests/mocks/docs-only request never changes
implementation code.

## Workflow / Before Starting

Before rebasing, refactoring, or fixing, confirm the full scope and intent. Do
not begin a rebase or large refactor until the requirement is clear. Avoid
unrelated changes (e.g. styling tweaks, context-to-prop refactors not
requested).

When unsure about requirements, scope, or approach, use /grill-me to align
before proceeding.

## Accuracy

Never use placeholder parameter/config names — confirm real names from the
codebase.

Never proceed past an unanswered clarification prompt.

## Failures

Never skip or ignore failures on the grounds they may be preexisting. Always
fix any failure encountered.

## Plans

At the end of each plan, give me a list of unresolved questions to answer, if any.
Make the questions extremely concise. If /grill-me is available, use it to
align on the questions before proceeding otherwise just list the questions and
wait for answers before proceeding.
