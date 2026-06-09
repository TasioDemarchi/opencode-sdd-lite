# SDD Lite — Spec-Driven Development for Personal Projects

A lightweight, opinionated workflow for building personal projects with AI agents. Born from real frustration: the original SDD workflow consumed a weekly token budget in one day.

## The Problem

Full SDD (Spec-Driven Development) was designed for enterprise teams — 7 sub-agents per change, 4-7 artifact files, each phase starting from scratch. For personal projects, that's:

- **7 sub-agent calls** for a single change (explore → propose → spec → design → tasks → apply → verify)
- **2,600+ lines of artifacts** for a translation overlay app
- **Token budget consumed in 1 day** for what should be simple changes
- **30+ iterations** to fix a bug because the agent kept touching things outside scope

## The Solution

SDD Lite replaces ceremony with collaboration. 3 phases instead of 7. 0-1 artifacts instead of 7. You plan, the agent executes.

```
SIMPLE (1-3 files, bugfix)
  └── Direct Apply — 1 sub-agent with instructions

MEDIUM (4-10 files, new feature)
  └── Plan → Build — 2 sub-agents

LARGE (10+ files, architectural change)
  └── Plan → Design → Build — 3 sub-agents
```

**Token savings: ~73-95% compared to full SDD.**

## The 11 Principles

These are not suggestions. They are the framework for every decision:

| # | Principle | What it means |
|---|-----------|---------------|
| 1 | **Caveman Structure** | Simple prompts, simple artifacts. If plan.md can be 10 lines, make it 10 lines. |
| 2 | **Inversion of Control** | You plan, the agent executes. The human decides, the AI implements. |
| 3 | **Chesterton's Fence** | Before changing anything, understand WHY it exists. If you can't explain it, you can't change it. |
| 4 | **Impact Checklist** | Define "done" BEFORE starting. No scope creep. |
| 5 | **Ockham's Razor** | Simplest hypothesis first. Don't over-engineer. |
| 6 | **AHA** | Don't abstract until 3+ use cases. Premature abstraction is worse than duplication. |
| 7 | **Unix Philosophy** | One agent = one task. Each sub-agent does ONE thing well. |
| 8 | **Least Touch** | Only touch files in the plan. Note observations outside scope, don't implement them. |
| 9 | **Progressive Detail** | 3 levels of detail, not everything upfront. Most changes stop at Level 2. |
| 10 | **Feynman Technique** | If you can't explain it simply, you don't understand it. |
| 11 | **KISS** | Simplest solution that works. No gold-plating. |

## Project Artifacts

Instead of 7+ phase artifacts, SDD Lite uses 3 project files that serve both the agent AND the human:

### `docs/decisions.md` — Architecture Decision Records

Flat file format (not individual ADR files). Only real architectural decisions with tradeoffs.

```markdown
## D1: Tauri 2 as desktop framework

- **Date**: 2026-04-17
- **Status**: Accepted
- **Context**: Need a desktop overlay for games. <50MB RAM constraint.
- **Decision**: Tauri 2 with Rust backend + vanilla JS frontend.
- **Consequences**: ✅ ~10MB RAM ❌ Smaller ecosystem than Electron
```

**For interviews**: Shows you think before you code and document the "why."

### `CHANGELOG.md` — Keep a Changelog

One entry per released version, not per iteration.

```markdown
## [0.3.0] - 2026-06-06

### Fixed
- API keys now persist across app restarts
- Settings returns saved defaults, not profile-overridden values
```

**For interviews**: Shows your project evolves with discipline.

### `PROJECT_CONTEXT.md` — Agent Map

The document that eliminates redundant exploration. Commits to the repo, travels with the project, stays consistent across machines.

```markdown
## Stack
- Tauri 2 (Rust) + vanilla JS. Windows-only.

## Architecture Map
- commands.rs → All Tauri commands
- settings.rs → Settings persistence (JSON + Credential Manager)
- lib.rs → App state, startup, events

## Key Patterns
- Settings: Frontend → save_settings → disk + Credential Manager
```

## Change Artifacts

Instead of proposal.md + spec.md + design.md + tasks.md, SDD Lite uses:

### `plan.md` — For medium and large changes

```markdown
# Plan: Settings Persistence Fix

## Intent
API keys and engine preferences don't survive app restarts.

## Scope
- Fix API key persistence on save
- Fix profile override leak

## Affected Files
- src-tauri/src/commands.rs — save_settings, get_settings
- src-tauri/src/settings.rs — credential manager integration

## Impact Checklist
- [ ] API keys survive app restart
- [ ] Profile overrides don't leak into saved defaults

## Decisions
- D1: Best-effort key persistence — per-credential, not transactional

## Out of Scope
- Key error UI display (future change)
```

### `design.md` — Only for large/architectural changes

Contains: Context, Approach, Architecture diagram, Key Decisions (with tradeoffs), Contracts, Migration notes.

### Observations — Instead of "leaving code better"

The plan.md includes an **Observations** section for things noticed but NOT implemented (Least Touch principle):

```markdown
## Observations (outside scope)
- [ ] commands.rs:142 — unwrap() could be proper error handling
- [ ] settings.rs:53 — save_settings_to_disk could be more granular
```

These feed future refactors, not scope creep.

## Onboarding Existing Projects

For projects where you didn't make the architectural decisions (e.g., built with AI assistance), SDD Lite uses **archaeology mode**:

1. Agent scans the codebase and infers decisions
2. Agent generates draft PROJECT_CONTEXT.md, decisions.md, CHANGELOG.md
3. **You validate and correct** — agent proposes, human decides
4. ADRs for pre-existing decisions are marked as "retroactive — documented after implementation"

For new projects, the flow is **collaborative**: you and the agent co-create the decisions.

## The Agents

| Agent | Model (recommended) | Role |
|-------|---------------------|------|
| `sdd-lite` | MiniMax M3 | Orchestrator — talks to you, plans, delegates |
| `sdd-lite-apply` | DeepSeek V4 Pro | Implementation — receives plan, writes code |
| `sdd-lite-design` | MiniMax M3 | Design — creates design.md for large changes |
| `sdd-lite-apply` | DeepSeek V4 Flash | Onboarding — archaeology for existing projects |

**Model strategy**: The orchestrator needs good conversation quality (MiniMax M3 with 1M context). Implementation needs good code following (DeepSeek V4 Pro). Design needs good reasoning (MiniMax M3). Onboarding reads a lot and writes little (DeepSeek V4 Flash, cheapest).

## Installation

### Quick Install

```bash
git clone https://github.com/TasioDemarchi/opencode-sdd-lite.git
cd opencode-sdd-lite
chmod +x install.sh
./install.sh
```

### Manual Install

Copy the following directories to `~/.config/opencode/`:

```bash
cp -r skills/sdd-lite/          ~/.config/opencode/skills/
cp -r skills/sdd-lite-apply/    ~/.config/opencode/skills/
cp -r skills/sdd-lite-design/   ~/.config/opencode/skills/
cp -r skills/sdd-lite-onboard/  ~/.config/opencode/skills/
cp    skills/_shared/sdd-lite-common.md ~/.config/opencode/skills/_shared/
cp -r prompts/sdd-lite/         ~/.config/opencode/prompts/
cp    AGENTS.md                  ~/.config/opencode/AGENTS.md
```

Then add the agent configs from `agents/sdd-lite-agents.json` to your `opencode.json`.

### Agent Configuration

Add the contents of `agents/sdd-lite-agents.json` to the `"agent"` section of your `~/.config/opencode/opencode.json`:

```bash
# Option A: Automated merge (requires jq)
chmod +x install-agents.sh
./install-agents.sh

# Option B: Manual
# Copy-paste the agents from agents/sdd-lite-agents.json into
# the "agent" section of your opencode.json
```

### Model Configuration

The default models use OpenCode Go for the orchestrator and design agent, and DeepSeek API for implementation and onboarding. Adjust the model names to match your providers:

| Agent | Default Model | Alternative |
|-------|---------------|-------------|
| `sdd-lite` | `opencode-go/minimax-m3` | Any strong conversational model |
| `sdd-lite-apply` | `deepseek/deepseek-v4-pro` | `opencode-go/deepseek-v4-pro` |
| `sdd-lite-design` | `opencode-go/minimax-m3` | Any strong reasoning model |
| `sdd-lite-onboard` | `deepseek/deepseek-v4-flash` | `opencode-go/deepseek-v4-flash` |

### Restart OpenCode

After installation, restart opencode for changes to take effect.

## Usage

### Onboarding an existing project

```
/agent sdd-lite
"I want to start using SDD Lite on my project at ~/projects/my-app"
```

The agent will perform archaeology, generate PROJECT_CONTEXT.md, decisions.md, and CHANGELOG.md, and present them for your validation.

### Starting a new project

```
/agent sdd-lite
"I want to build a CLI tool that does X"
```

The agent will collaborate with you to define the project, then generate the artifacts.

### Making a change

```
"Fix the settings persistence bug — API keys are lost on restart"
```

The agent will:
1. Assess change size (simple/medium/large)
2. For medium/large: create plan.md collaboratively with you
3. Delegate implementation to sdd-lite-apply
4. Review results and update project artifacts

### Requesting a refactor

The agent will challenge you with Chesterton's Fence: "Why do you want to refactor this?" Only refactors with a clear purpose (enabling a feature, fixing a pattern that causes bugs) get supported.

## Comparison with Full SDD

| Aspect | Full SDD | SDD Lite |
|--------|----------|----------|
| Sub-agents per change | 5-7 | 1-3 |
| Artifact files per change | 4-7 | 0-1 |
| Who generates the plan? | Sub-agent (sdd-propose) | You + orchestrator (collaborative) |
| How the agent knows the project? | Explores from scratch each time | PROJECT_CONTEXT.md (persistent map) |
| Where decisions live? | Scattered across proposals/specs/designs | decisions.md (flat ADR file) |
| How to verify completion? | sdd-verify (7th sub-agent) | Impact Checklist in plan.md |
| Token consumption per change | ~$2.05 | ~$0.10-0.55 |
| Project documentation for interviews | None (pipeline artifacts) | decisions.md + CHANGELOG.md |

## Philosophy

SDD Lite is built on a simple idea: **the human plans, the AI executes.** Not the other way around.

The original SDD workflow is brilliant for enterprise teams with budget and traceability requirements. But for personal projects, it's overkill. SDD Lite keeps the principles that matter (think before you code, document decisions, verify completion) and strips the ceremony that doesn't (7-phase pipeline, autonomous agents, 5 artifact files per change).

The result is a workflow that respects both your time and your token budget.

## License

MIT

## Credits

SDD Lite was born from frustration with token consumption and iteration loops on personal projects. The original SDD workflow was created by [Gentleman Programming](https://github.com/gentleman-programming). SDD Lite adapts those principles for solo developers with budget constraints.

The 11 principles draw from software engineering best practices:
- Chesterton's Fence (G.K. Chesterton, 1929)
- AHA (Kent C. Dodds)
- Unix Philosophy (Doug McIlroy)
- KISS (Kelly Johnson, SR-71 designer)
- Feynman Technique (Richard Feynman)