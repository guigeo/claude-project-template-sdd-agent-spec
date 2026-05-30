# Claude Project Template

Template de projeto com o framework AgentSpec 4.2 (Spec-Driven Development) pre-configurado para Claude Code.

## O que esta incluido

```
.claude/
├── agents/
│   ├── workflow/        # 6 agentes SDD (brainstorm → ship)
│   ├── code-quality/    # 6 agentes de qualidade de codigo
│   ├── communication/   # 3 agentes (explainer, meeting-analyst, planner)
│   ├── exploration/     # 2 agentes (codebase-explorer, kb-architect)
│   ├── ai-ml/           # 4 agentes de LLM e AI
│   ├── dev/             # 2 agentes do Dev Loop
│   ├── aws/             # 4 agentes AWS (opcional)
│   ├── data-engineering/ # 8 agentes Spark/Databricks (opcional)
│   └── domain/          # Vazio — crie os agentes do seu projeto aqui
├── commands/            # 13 slash commands (/brainstorm, /define, /build...)
├── sdd/                 # Framework SDD: templates, exemplos, arquitetura
├── dev/                 # Dev Loop: templates de PROMPT
└── kb/                  # Knowledge Base: so os templates (KB vazia)
```

## Como usar para um novo projeto

```bash
./setup.sh <nome-do-projeto> [diretorio-destino]

# Exemplos:
./setup.sh minha-api
./setup.sh meu-saas /Users/joao/Projetos
```

## Primeiros passos apos criar o projeto

1. Abra o projeto no Claude Code
2. `/sync-context` — gera o CLAUDE.md real com base no codigo
3. `/create-kb "fastapi"` — cria KB do seu stack
4. `/brainstorm "..."` — comeca a primeira feature

## Workflow SDD (AgentSpec 4.2)

```text
/brainstorm → /define → /design → /build → /ship
```

| Fase | Comando | Gera |
|------|---------|------|
| 0 (opcional) | `/brainstorm` | `BRAINSTORM_*.md` |
| 1 | `/define` | `DEFINE_*.md` |
| 2 | `/design` | `DESIGN_*.md` |
| 3 | `/build` | Codigo + `BUILD_REPORT_*.md` |
| 4 | `/ship` | `SHIPPED_*.md` em archive/ |

## MCPs recomendados

```bash
# Context7 — documentacao de bibliotecas em tempo real
claude mcp add context7 --transport http https://mcp.context7.com/mcp

# Ref Tools — busca em documentacao de referencia
claude mcp add ref-tools --transport http https://mcp.ref.tools/mcp
```
