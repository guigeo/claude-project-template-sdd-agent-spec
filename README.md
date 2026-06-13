# Claude Project Template — AgentSpec 4.2

> Template de projeto com o framework AgentSpec 4.2 (Spec-Driven Development) pré-configurado para Claude Code. Abra no Claude Code, rode `/new-project` e comece a codar com KBs e agentes selecionados pelo seu stack.

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
│   └── domain/             # Vazio — agentes do projeto criados por /new-project ou /project-init
├── commands/
│   ├── core/               # /project-init, /sync-context, /memory, /readme-maker
│   ├── workflow/           # /brainstorm, /define, /design, /build, /ship, /iterate
│   ├── knowledge/          # /create-kb
│   ├── review/             # /review
│   └── dev/                # /dev
├── sdd/                    # Framework SDD: templates, exemplos, contratos
├── dev/                    # Dev Loop: templates de PROMPT
└── kb/                     # Knowledge Base: acervo central reaproveitável + templates
catalog.yaml                # Catálogo de componentes (metadados para cópia seletiva)
setup.sh                    # Fallback de criação de projeto (copia tudo)
```

---

## Criar um novo projeto

### Opção A — `/new-project` (recomendado: cópia seletiva)

Abra **este repositório** no Claude Code e rode:

```bash
/new-project meu-projeto /Users/joao/Projetos
```

O comando faz a entrevista de 6 perguntas **antes** de copiar e então:
- Seleciona via [catalog.yaml](catalog.yaml) só os agentes que casam com seu stack (um projeto Next.js não recebe os agentes Spark/AWS)
- Copia as KBs do acervo central que se aplicam; se faltar alguma, propõe criar — a KB nova fica **no template** e é reaproveitada nos próximos projetos
- Cria os agentes de domínio do projeto, preenche o `CLAUDE.md` e grava o vínculo de versão em `.claude/template-link.yaml`

### Opção B — `setup.sh` (fallback: copia tudo)

```bash
./setup.sh <nome-do-projeto> [diretorio-destino]

# Exemplos:
./setup.sh minha-api
./setup.sh meu-saas /Users/joao/Projetos
```

Depois, dentro do projeto criado, rode `/project-init` — entrevista de 6 perguntas que instala KBs (localmente), cria agentes de domínio e preenche o `CLAUDE.md`.

### Em ambos os casos, na sequência

```bash
/sync-context      # gera a seção de Arquitetura após adicionar código-fonte
/brainstorm "..."  # explore a ideia da primeira feature
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
| **Domínio** | criados por `/new-project` ou `/project-init` | Específicos do seu projeto |

> Quais agentes vão para cada projeto é decidido por [catalog.yaml](catalog.yaml) (campos `scope`/`stacks`/`domains`/`clouds`). O `/new-project` copia só os que casam com o stack declarado na entrevista.

---

## Comandos disponíveis

| Comando | Propósito |
|---------|-----------|
| `/new-project` | **No template** — entrevista + cópia seletiva via catalog.yaml |
| `/distill` | **No projeto filho** — destila aprendizado de feature shipada em KB generalizada |
| `/contribute` | **No projeto filho** — devolve KB/agente reaproveitável ao acervo do template |
| `/project-init` | **No projeto filho** (se criado via setup.sh) — KBs + agentes de domínio + CLAUDE.md |
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
