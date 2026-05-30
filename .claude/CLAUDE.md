# [PROJECT NAME]

> [One-line description of the project]

---

## Project Context

**Business Problem:** [Describe the problem being solved]

**Solution:** [Describe the technical solution]

**Stack:** [Main technologies used]

**Team:** [Team size / stakeholders]

---

## Architecture Overview

[Run /sync-context after setting up the project to auto-generate this section]

---

## Project Structure

```text
[project-root]/
├── src/           # Source code
├── tests/         # Test suites
└── ...
```

---

## Development Workflows

### AgentSpec 4.2 (Spec-Driven Development)

5-phase structured workflow for features requiring traceability:

```text
/brainstorm → /define → /design → /build → /ship
  (Opus)      (Opus)    (Opus)   (Sonnet)  (Haiku)
```

| Command | Phase | Purpose |
|---------|-------|---------|
| `/brainstorm` | 0 | Explore ideas through dialogue (optional) |
| `/define` | 1 | Capture and validate requirements |
| `/design` | 2 | Create architecture and specification |
| `/build` | 3 | Execute implementation with verification |
| `/ship` | 4 | Archive with lessons learned |
| `/iterate` | Any | Update documents when changes needed |

**Artifacts:** `.claude/sdd/features/` and `.claude/sdd/archive/`

### Dev Loop (Level 2 Agentic Development)

```bash
/dev "I want to build X"              # Let the crafter guide you
/dev tasks/PROMPT_FEATURE.md          # Execute existing PROMPT
/dev tasks/PROMPT_FEATURE.md --resume # Resume interrupted session
```

**When to use:** KB building, prototypes, single features, utilities

---

## Agent Usage Guidelines

| Category | Agents | Use When |
|----------|--------|----------|
| **Workflow** | brainstorm, define, design, build, ship, iterate | Building features with SDD |
| **Code Quality** | code-reviewer, code-cleaner, test-generator, dual-reviewer | Improving code quality |
| **AI/ML** | llm-specialist, genai-architect, ai-prompt-specialist | LLM prompts, AI systems |
| **Communication** | adaptive-explainer, meeting-analyst, the-planner | Explanations, planning |
| **Exploration** | codebase-explorer, kb-architect | Codebase exploration, KB creation |
| **Domain** | [add your domain agents here] | Project-specific tasks |

---

## Coding Standards

### Language: [e.g. Python 3.11+]

- **Style:** [e.g. Ruff / ESLint]
- **Testing:** [e.g. pytest / jest]
- **Validation:** [e.g. Pydantic v2 / Zod]
- **Type Hints:** Required on all function signatures

---

## Commands

| Command | Purpose |
|---------|---------|
| `/brainstorm` | Explore ideas through collaborative dialogue |
| `/define` | Capture and validate requirements |
| `/design` | Create technical architecture |
| `/build` | Execute implementation |
| `/ship` | Archive completed features |
| `/iterate` | Update documents mid-stream |
| `/dev` | Dev Loop for structured iteration |
| `/create-kb` | Create knowledge base domains |
| `/review` | Code review workflow |
| `/create-pr` | Create pull requests |
| `/memory` | Save session insights |
| `/sync-context` | Update CLAUDE.md with project context |
| `/readme-maker` | Generate comprehensive README |

---

## Knowledge Base

Run `/create-kb "<domain>"` to add domains for your stack.

| Domain | Purpose | Entry Point |
|--------|---------|-------------|
| [domain] | [purpose] | `.claude/kb/[domain]/index.md` |

---

## Active Features (In Progress)

| Feature | Status | Description |
|---------|--------|-------------|
| — | — | — |

---

## Shipped Features (SDD Archive)

| Feature | Shipped | Description |
|---------|---------|-------------|
| — | — | — |

---

## Getting Help

- **SDD Workflow:** See [.claude/sdd/_index.md](.claude/sdd/_index.md)
- **SDD Examples:** See [.claude/sdd/examples/](.claude/sdd/examples/)
- **Dev Loop:** See [.claude/dev/_index.md](.claude/dev/_index.md)
- **Agents:** Browse [.claude/agents/](.claude/agents/)
- **KB Index:** See [.claude/kb/_index.yaml](.claude/kb/_index.yaml)
