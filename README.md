# Claude Project Template — AgentSpec 4.2

> Template de projeto com o framework AgentSpec 4.2 (Spec-Driven Development) pré-configurado para Claude Code. Clone, rode `setup.sh` e comece a codar.

---

## O que está incluído

```
.claude/
├── agents/
│   ├── workflow/           # 6 agentes SDD (brainstorm → ship)
│   ├── code-quality/       # 6 agentes de qualidade (reviewer, cleaner, test-generator...)
│   ├── communication/      # 3 agentes (explainer, meeting-analyst, planner)
│   ├── exploration/        # 2 agentes (codebase-explorer, kb-architect)
│   ├── ai-ml/              # 4 agentes de LLM e AI
│   ├── dev/                # 2 agentes do Dev Loop
│   ├── aws/                # 4 agentes AWS (opcional)
│   ├── data-engineering/   # 8 agentes Spark/Databricks (opcional)
│   └── domain/             # Vazio — criado pelo /project-init
├── commands/
│   ├── core/               # /project-init, /sync-context, /memory, /readme-maker
│   ├── workflow/           # /brainstorm, /define, /design, /build, /ship, /iterate
│   ├── knowledge/          # /create-kb
│   ├── review/             # /review
│   └── dev/                # /dev
├── sdd/                    # Framework SDD: templates, exemplos, contratos
├── dev/                    # Dev Loop: templates de PROMPT
└── kb/                     # Knowledge Base: templates (KB vazia — populada por /project-init)
setup.sh                    # Script de criação de novo projeto
```

---

## Criar um novo projeto

```bash
./setup.sh <nome-do-projeto> [diretorio-destino]

# Exemplos:
./setup.sh minha-api
./setup.sh meu-saas /Users/joao/Projetos
```

---

## Primeiros passos após criar o projeto

```bash
# 1. Abra no Claude Code
code /caminho/do/projeto

# 2. Primeiro comando — configura tudo antes da primeira feature
/project-init
```

O `/project-init` faz uma entrevista de 6 perguntas e então:
- Instala KBs para cada lib/framework do stack declarado
- Cria agentes de domínio específicos do projeto
- Preenche o `CLAUDE.md` com contexto real
- Commita tudo automaticamente

```bash
# 3. Após adicionar código-fonte
/sync-context      # gera a seção de Arquitetura no CLAUDE.md

# 4. Primeira feature
/brainstorm "..."  # explore a ideia
/define "..."      # ou vá direto para requisitos
```

---

## Workflow SDD — AgentSpec 4.2

```text
/brainstorm → /define → /design → /build → /ship
  (Opus)      (Opus)    (Opus)   (Sonnet)  (Haiku)
```

| Fase | Comando | Gera |
|------|---------|------|
| 0 (opcional) | `/brainstorm` | `BRAINSTORM_*.md` |
| 1 | `/define` | `DEFINE_*.md` |
| 2 | `/design` | `DESIGN_*.md` |
| 3 | `/build` | Código + `BUILD_REPORT_*.md` |
| 4 | `/ship` | `SHIPPED_*.md` em `archive/` |

Artefatos em `.claude/sdd/features/` e `.claude/sdd/archive/`.

---

## Dev Loop (Desenvolvimento Agentico Nível 2)

Para features isoladas, utilitários e KBs — sem o overhead do SDD completo:

```bash
/dev "Quero construir X"              # O crafter te guia
/dev tasks/PROMPT_FEATURE.md          # Executa um PROMPT existente
/dev tasks/PROMPT_FEATURE.md --resume # Retoma sessão interrompida
```

---

## MCPs recomendados (instalar uma vez, vale para todos os projetos)

```bash
# Context7 — documentação de bibliotecas em tempo real
claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp

# Ref Tools — busca em documentação técnica (requer login OAuth na primeira vez)
claude mcp add --scope user --transport http ref-tools-ref-tools-mcp https://api.ref.tools/mcp
```

Verificar MCPs instalados:
```bash
claude mcp list
```

---

## Agentes disponíveis

| Categoria | Agentes | Quando usar |
|-----------|---------|-------------|
| **Workflow** | brainstorm, define, design, build, ship, iterate | Construir features com SDD |
| **Qualidade** | code-reviewer, code-cleaner, test-generator, dual-reviewer | Revisar e melhorar código |
| **AI/ML** | llm-specialist, genai-architect, ai-prompt-specialist | Prompts, sistemas de IA |
| **Comunicação** | adaptive-explainer, meeting-analyst, the-planner | Explicações, planejamento |
| **Exploração** | codebase-explorer, kb-architect | Explorar repositório, criar KBs |
| **AWS** | aws-lambda-architect, lambda-builder, aws-deployer, ci-cd-specialist | Projetos serverless |
| **Dados** | medallion-architect, lakeflow-architect, spark-specialist, ... | Pipelines Databricks/Spark |
| **Domínio** | criados pelo `/project-init` | Específicos do seu projeto |

---

## Comandos disponíveis

| Comando | Propósito |
|---------|-----------|
| `/project-init` | **Primeiro comando** — KBs + agentes de domínio + CLAUDE.md |
| `/brainstorm` | Explorar ideias em diálogo |
| `/define` | Capturar e validar requisitos |
| `/design` | Criar arquitetura técnica |
| `/build` | Executar implementação |
| `/ship` | Arquivar feature concluída |
| `/iterate` | Atualizar documentos mid-stream |
| `/dev` | Dev Loop para iteração estruturada |
| `/create-kb` | Criar domínio de knowledge base |
| `/review` | Revisão de código |
| `/create-pr` | Criar pull request |
| `/memory` | Salvar insights da sessão |
| `/sync-context` | Atualizar CLAUDE.md com contexto do projeto |
| `/readme-maker` | Gerar README completo |
