---
name: new-project
description: Cria um projeto filho a partir do template com cópia seletiva — entrevista primeiro, seleciona componentes via catalog.yaml, cria KBs faltantes no acervo central e copia só o que o projeto precisa
---

# Comando New Project

> Roda **no repositório do template**. Substitui o fluxo "setup.sh + /project-init" por:
> entrevista → seleção via catálogo → criação de lacunas no acervo → cópia seletiva.
>
> O conhecimento reaproveitável (KBs de tecnologia) nasce e fica **no template**;
> o conhecimento específico (agentes de domínio, regras de negócio) nasce **no filho**.

## Uso

```bash
/new-project
/new-project meu-projeto
/new-project meu-projeto /Users/joao/Projetos
/new-project meu-projeto /Users/joao/Projetos "FastAPI + PostgreSQL, API de ingestão"
```

---

## Processo

### Passo 1: Validar ambiente

```text
Read(catalog.yaml)                # Obrigatório — se não existir, este não é o template. Abortar com aviso.
Bash(git -C . rev-parse HEAD)     # SHA atual do template → será gravado no filho
```

Se argumentos não fornecidos, perguntar nome do projeto e diretório de destino.
Se o diretório de destino já existir e não estiver vazio: **abortar** e avisar — nunca sobrescrever.

### Passo 2: Entrevista

Fazer as perguntas **uma de cada vez**, aguardando resposta. São as mesmas 6 perguntas
do `/project-init` (P1–P6) — seguir o texto exato de
[.claude/commands/core/project-init.md](.claude/commands/core/project-init.md), Passo 2:

1. **P1 — Identidade:** o que é o projeto, em uma frase
2. **P2 — Stack:** linguagens, frameworks, bibliotecas
3. **P3 — Domínio:** api-web / data-pipeline / ai-llm / cli / frontend-fullstack / infra-devops
4. **P4 — Cloud:** aws / gcp / azure / databricks / local / híbrido
5. **P5 — Equipe e restrições**
6. **P6 — Contexto adicional** (PRD, briefing — opcional)

Se o usuário passou descrição como argumento, usar para pré-preencher e confirmar em vez de perguntar do zero.

Normalizar as respostas para a taxonomia do `catalog.yaml` (stacks em kebab-case,
domínio e cloud nos valores canônicos listados no cabeçalho do catálogo).

### Passo 3: Seleção de componentes via catálogo

Para cada entrada do `catalog.yaml`, aplicar as regras:

```text
scope: core          → SEMPRE copiar
scope: template-only → NUNCA copiar (ex.: este comando)
scope: optional      → copiar se houver interseção entre os metadados do componente
                       (stacks / domains / clouds) e as respostas normalizadas P2–P4
```

Para `requires:` (ex.: coderabbit-cli), verificar disponibilidade com `which {tool}`;
se ausente, excluir da seleção e registrar o motivo no plano.

**KBs:** comparar o stack (P2 + KBs de base do domínio, conforme tabela de mapeamento
do `/project-init` Passo 3) com a seção `kbs:` do catálogo:

```text
KB existe no acervo  → entra na lista "copiar"
KB não existe        → entra na lista "lacunas" (proposta de criação)
```

### Passo 4: Confirmar o plano

```text
PLANO DE CRIAÇÃO DO PROJETO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Projeto:  {nome}  →  {destino}
Stack:    {stacks normalizados} | Domínio: {dominio} | Cloud: {cloud}

Agentes a copiar ({n}):
  core:     {lista}
  optional: {lista com motivo do match}
  excluídos: {lista com motivo — ex.: "aws/* — cloud é databricks"}

KBs do acervo a copiar ({n}): {lista}

LACUNAS — KBs a criar NO TEMPLATE antes da cópia ({n}):
  • {kb} — {motivo}
  Criar agora? (sim / pular alguma / ajustar)

Agentes de domínio a criar NO FILHO ({n}):
  • {nome-do-projeto}-expert + {agentes por domínio, conforme /project-init Passo 3}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Confirmar? (sim / ajustar)
```

A criação de KBs no acervo central **sempre exige confirmação explícita** — o acervo
propaga para todos os projetos futuros.

### Passo 5: Criar KBs faltantes no acervo (template)

Para cada lacuna confirmada, invocar o agente **kb-architect**:

```text
Tarefa: "Criar domínio KB para '{kb}' — conhecimento geral da tecnologia,
         SEM contexto de negócio de nenhum projeto específico"
Saída:  .claude/kb/{kb}/
```

Após cada criação:
1. Registrar em `.claude/kb/_index.yaml` (seção `domains:`)
2. Registrar em `catalog.yaml` (seção `kbs:`) com `stacks`, `domains`,
   `last_validated: {hoje}` e `library_version` se identificável

Falha na criação de uma KB: pular, registrar no relatório, não bloquear as demais.

### Passo 6: Copiar seletivamente para o destino

Montar o filho em `{destino}/{nome}`:

```text
COPIAR:
  .claude/commands/           → tudo, EXCETO core/new-project.md
  .claude/sdd/                → tudo
  .claude/dev/                → tudo
  .claude/kb/_templates/      → tudo
  .claude/kb/{dominio}/       → apenas KBs selecionadas no plano
  .claude/kb/_index.yaml      → reescrever contendo APENAS os domínios copiados
  .claude/agents/{...}        → apenas agentes selecionados, preservando subpastas
  .claude/agents/_template.md.example
  .claude/agents/domain/      → criar vazia (receberá os agentes do Passo 7)
  .claude/CLAUDE.md.template  → copiar como .claude/CLAUDE.md (preenchido no Passo 8)

NÃO COPIAR:
  catalog.yaml, setup.sh, README.md, .claude/CLAUDE.md (do template),
  arquivos .DS_Store, KBs e agentes fora da seleção

CRIAR:
  .gitignore  → .DS_Store, __pycache__/, *.pyc, .env, .env.local, node_modules/
```

### Passo 7: Criar agentes de domínio no filho

Criar em `{filho}/.claude/agents/domain/` seguindo **exatamente** os templates do
`/project-init` Passo 6 (agente por domínio + `{nome-do-projeto}-expert`):

- Nenhum `{placeholder}` pode restar nos arquivos gerados
- Os caminhos de KB referenciados devem ser os caminhos reais copiados no Passo 6
- Contexto de negócio de P6 vai para o `{projeto}-expert` — **nunca** para o acervo do template

### Passo 8: Preencher CLAUDE.md e gravar vínculo com o template

Preencher o `.claude/CLAUDE.md` do filho conforme `/project-init` Passo 7
(substituir todos os `[placeholder]` por conteúdo real de P1–P6, incluindo a tabela
de KBs copiadas e os agentes de domínio na tabela de agentes).

Criar `{filho}/.claude/template-link.yaml`:

```yaml
template_path: {caminho absoluto deste repositório}
template_version: {SHA do Passo 1}
catalog_version: {version do catalog.yaml}
created_at: "{data de hoje}"
components:
  agents: [{lista de agentes copiados}]
  kbs: [{lista de KBs copiadas}]
```

### Passo 9: Commits e relatório final

**No template** (se KBs foram criadas no Passo 5):

```bash
git add .claude/kb/ catalog.yaml
git commit -m "feat(kb): adiciona KBs ao acervo via /new-project ({nome-do-projeto})"
```

**No filho:**

```bash
cd {filho} && git init && git add . && git commit -m "feat: initialize {nome} from claude-project-template ({SHA curto})"
```

Relatório:

```text
PROJETO CRIADO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Destino: {caminho}
✓ Agentes copiados: {n} ({core} core + {opt} por match de stack)
✓ KBs copiadas: {n}  |  KBs novas no acervo central: {n}
✓ Agentes de domínio criados: {lista}
✓ CLAUDE.md preenchido  |  template-link.yaml gravado ({SHA curto})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRÓXIMOS PASSOS:
  1. cd {caminho} && abrir no Claude Code
  2. Adicionar código-fonte e rodar /sync-context
  3. Primeira feature: /brainstorm "..." ou /define "..."
```

---

## Gate de qualidade

```text
[ ] catalog.yaml lido e SHA do template capturado
[ ] Destino validado (inexistente ou vazio)
[ ] Entrevista completa (P1–P5; P6 oferecida)
[ ] Respostas normalizadas para a taxonomia do catálogo
[ ] Plano apresentado com seleção, exclusões (com motivo) e lacunas
[ ] Criação de KBs no acervo confirmada explicitamente pelo usuário
[ ] KBs novas registradas em _index.yaml E catalog.yaml
[ ] Filho contém apenas componentes selecionados (sem new-project.md, sem catalog.yaml)
[ ] _index.yaml do filho lista apenas as KBs copiadas
[ ] Agentes de domínio sem {placeholder}; KB paths reais
[ ] CLAUDE.md do filho sem [placeholder]
[ ] template-link.yaml gravado com SHA e lista de componentes
[ ] Commits feitos (template, se houve KB nova; filho sempre)
[ ] Relatório final exibido
```

---

## Casos especiais

| Situação | Ação |
|----------|------|
| Rodado fora do template (sem catalog.yaml) | Abortar: "Use /project-init dentro do projeto, ou rode /new-project no repositório do template" |
| Destino existe com conteúdo | Abortar — nunca sobrescrever |
| Stack sem mapeamento de KB | Propor criação mesmo assim — o kb-architect pesquisa |
| Usuário recusa criação de KB no acervo | Prosseguir sem ela; registrar no relatório; o filho pode criar localmente depois via /create-kb |
| Agente optional com `requires:` ausente | Excluir da cópia e informar no plano |
| git indisponível | Pular commits, registrar aviso, não bloquear |

---

## Referências

- Entrevista e templates de agentes de domínio: [.claude/commands/core/project-init.md](.claude/commands/core/project-init.md)
- Catálogo: [catalog.yaml](../../../catalog.yaml)
- Agente criador de KBs: [.claude/agents/exploration/kb-architect.md](.claude/agents/exploration/kb-architect.md)
- Fallback sem seleção: [setup.sh](../../../setup.sh) (copia tudo)
