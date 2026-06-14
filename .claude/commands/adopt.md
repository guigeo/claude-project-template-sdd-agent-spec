---
name: adopt
description: Adota um projeto JÁ EXISTENTE (brownfield) para dentro do template — detecta o stack a partir do código, entende o projeto, instala a estrutura .claude/ de forma ADITIVA (sem sobrescrever nada) e grava o vínculo. O projeto vira filho de pleno direito. Read-only no template — nunca escreve no acervo.
---

# Comando Adopt (brownfield)

> Roda **no repositório do template** (bootstrap: o projeto legado ainda não tem `.claude/`,
> logo não tem este comando). Aponta para um projeto que **já existe** e o transforma em filho.
>
> **Irmão do `/new-project`:** reusa o mesmo motor de seleção via `catalog.yaml`, mas em vez de
> criar uma pasta nova e vazia, ele **detecta o stack do código existente**, copia de forma
> **aditiva e não-destrutiva**, e preenche o CLAUDE.md **analisando o código real**.
>
> **TRAVA DE SEGURANÇA — read-only no template:** o `/adopt` NUNCA escreve no acervo central.
> KB que falte vira **stub local no filho** (ou só uma anotação). O conhecimento do legado só
> volta ao template pela porta guardada `/distill` → `/contribute` (leak-check), nunca aqui.

## Uso

```bash
/adopt /Users/joao/Projetos/projeto-legado
/adopt /Users/joao/Projetos/projeto-legado "é uma API FastAPI de cobrança"
```

---

## Processo

### Passo 1: Validar ambiente

```text
Read(catalog.yaml)                       # Obrigatório — se não existir, não é o template. Abortar.
Bash(git -C . rev-parse HEAD)            # SHA do template → gravado no filho

# O DESTINO é um projeto existente:
Bash(test -d {destino})                  # tem que existir
Bash(ls -A {destino})                    # tem que ter conteúdo (código) — se vazio, use /new-project
Bash(git -C {destino} rev-parse HEAD)    # ideal ter git; se não tiver, avisar (sem bloquear)
```

Se o destino não existir ou estiver vazio: **abortar** e sugerir `/new-project` (greenfield).

### Passo 2: Detectar o stack a partir do código (read-only)

Ler os arquivos-chave do projeto para **inferir** stack/domínio/cloud (não entrevistar do zero):

```text
Linguagem/deps: pyproject.toml, requirements*.txt, package.json, go.mod, Cargo.toml, pom.xml
Frameworks:     imports e deps (fastapi, flask, django, react, next, spark, pandas...)
Cloud/infra:    *.tf, serverless.yml, Dockerfile, .github/workflows, sam template, databricks.yml
Domínio:        estrutura de pastas + entrypoints (api/ routes/ → api-web; notebooks/ dags/ → data-pipeline; cli/ → cli)
```

Montar uma proposta **normalizada para a taxonomia do `catalog.yaml`** (stacks kebab-case;
domínio e cloud canônicos) e **apresentar para o usuário confirmar/ajustar** — a detecção
pode errar; nunca seguir sem confirmação. Se o usuário passou descrição como argumento, usar
para desambiguar.

### Passo 3: Entender o projeto (relatório de entendimento)

Produzir um entendimento do projeto. **Regra de custo:** projeto **pequeno** (poucos arquivos)
→ ler o código inline (mais rápido, sem spawnar agente); projeto **grande/desconhecido**
→ invocar o **codebase-explorer**:

```text
Tarefa: "Explorar {destino} e entregar Executive Summary + Deep Dive: arquitetura, módulos
         principais, padrões, dependências, dívidas/pontos fracos e oportunidades de melhoria."
```

Consolidar a saída num **RELATÓRIO DE ENTENDIMENTO** que inclui uma seção
**"Oportunidades de melhoria (candidatos)"** — uma LISTA, não um plano priorizado. A priorização
e a reconstrução são tocadas depois pelo usuário via `/brainstorm` → `/define` (cada candidato
vira semente). Este relatório será gravado no filho no Passo 8.

### Passo 4: Seleção de componentes via catálogo

Aplicar as MESMAS regras do `/new-project` Passo 3 (ver `catalog.yaml`):

```text
scope: core          → SEMPRE copiar
scope: template-only → NUNCA copiar (este comando, /new-project)
scope: optional      → só se TODAS as dimensões declaradas casarem (AND entre dimensões,
                       não OR achatado) com o stack/domínio/cloud detectados no Passo 2
requires: {tool}     → verificar com `which {tool}`; ausente → excluir e registrar motivo
```

**KBs:** comparar stack detectado com a seção `kbs:` do catálogo:

```text
KB existe no acervo  → entra na lista "copiar"
KB NÃO existe        → vira STUB LOCAL no filho (ou anotação) — NUNCA criar no acervo central
```

### Passo 5: Confirmar o plano

```text
PLANO DE ADOÇÃO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Projeto existente:  {destino}   (git: {sim/não})
Stack detectado:    {stacks} | Domínio: {dominio} | Cloud: {cloud}   (confirmado pelo usuário)

Já existe .claude/ no projeto? {sim/não}
  → se sim: a cópia é por arquivo, merge cuidadoso, PERGUNTA em cada conflito

Agentes a copiar ({n}):  core: {lista} | optional: {lista c/ motivo} | excluídos: {motivos}
KBs do acervo a copiar ({n}): {lista}
KBs faltantes (stub local no filho, NÃO no acervo): {lista}
Agentes de domínio a criar NO FILHO: {projeto}-expert + {por domínio}

Relatório de entendimento → docs/UNDERSTANDING_{projeto}.md
Commit: NÃO (você revisa o diff)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Confirmar? (sim / ajustar)
```

### Passo 6: Cópia ADITIVA e não-destrutiva

Copiar a seleção para o destino existente, **sem nunca sobrescrever artefato do projeto**:

```text
COPIAR (igual /new-project, mas ADITIVO):
  .claude/commands/ (exceto new-project.md e adopt.md)  | .claude/sdd/  | .claude/dev/
  .claude/kb/_templates/  | .claude/kb/{KBs selecionadas}  | .claude/agents/{selecionados}
  .claude/agents/_template.md.example  | .claude/agents/domain/ (vazia)
  .claude/kb/_index.yaml → conter APENAS as KBs copiadas

REGRAS DE NÃO-DESTRUIÇÃO:
  • Arquivo do projeto que JÁ existe (código, README, .gitignore, configs) → NUNCA tocar
  • Se já existe .claude/{arquivo} → comparar; conflito real → PERGUNTAR (manter / mesclar / pular)
  • CLAUDE.md já existe no projeto → NÃO sobrescrever (tratar no Passo 8 por anexação)
  • .gitignore já existe → acrescentar entradas faltantes, não substituir

NÃO COPIAR: catalog.yaml, setup.sh, README.md (do template), .claude/CLAUDE.md (do template),
            new-project.md, adopt.md, .DS_Store
```

### Passo 7: Criar agentes de domínio no filho

Igual `/new-project` Passo 7 / `/project-init` Passo 6: criar em `{destino}/.claude/agents/domain/`
o `{projeto}-expert` + agentes por domínio. O contexto de negócio (derivado do código + do que
o usuário informou) vai para o `{projeto}-expert` — **nunca** para o acervo. Sem `{placeholder}`.

### Passo 8: CLAUDE.md, vínculo e relatório

```text
1. CLAUDE.md:
   - NÃO existe no projeto → criar a partir de CLAUDE.md.template, preenchido com o que foi
     DETECTADO/ANALISADO no código (não inventar) + domínio/restrições confirmados
   - JÁ existe → preservar; ANEXAR uma seção "## AgentSpec / SDD" apontando para os comandos,
     agentes e KBs instalados (sem reescrever o conteúdo do usuário)

2. Gravar o relatório do Passo 3 em: {destino}/docs/UNDERSTANDING_{projeto}.md

3. Criar {destino}/.claude/template-link.yaml:
     template_path: {caminho absoluto deste repositório}
     template_version: {SHA do Passo 1}
     catalog_version: {version do catalog.yaml}
     created_at: "{hoje}"
     created_via: adopt
     selection: { stacks, domains, clouds }
     components: { agents: [...], kbs: [...] }
```

### Passo 9: SEM commit + relatório final

**Não commitar** — o projeto já tem história; o usuário revisa o diff antes.
**Não escrever nada no template** (read-only): nenhuma KB no acervo, nenhum commit no template.

```text
PROJETO ADOTADO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Projeto: {destino}  (NÃO commitado — revise o diff: git -C {destino} status)
✓ Stack: {stacks} | Domínio: {dominio} | Cloud: {cloud}
✓ Agentes copiados: {n}  |  KBs copiadas: {n}  |  KBs stub local: {n}
✓ Agentes de domínio criados: {lista}
✓ CLAUDE.md: {criado | seção anexada}  |  template-link.yaml gravado ({SHA curto})
✓ Entendimento: docs/UNDERSTANDING_{projeto}.md ({n} oportunidades de melhoria listadas)
✓ Template: inalterado (read-only)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRÓXIMOS PASSOS (no projeto adotado):
  1. Revisar o diff e commitar quando estiver satisfeito
  2. Ler docs/UNDERSTANDING_{projeto}.md
  3. Escolher uma oportunidade de melhoria → /brainstorm "..." (ela é a semente)
  4. /define → /design → /build → /ship
  5. Conhecimento genérico volta ao template via /distill → /contribute
```

---

## Gate de qualidade

```text
[ ] catalog.yaml lido e SHA do template capturado
[ ] Destino validado: existe E tem conteúdo (senão → /new-project)
[ ] Stack detectado do código e CONFIRMADO pelo usuário (detecção pode errar)
[ ] Relatório de entendimento gerado (com seção de oportunidades — lista, não plano priorizado)
[ ] Seleção via catálogo com regra AND entre dimensões; exclusões com motivo
[ ] KBs faltantes viraram stub local — NENHUMA escrita no acervo do template
[ ] Cópia ADITIVA: nenhum arquivo do projeto sobrescrito; conflitos em .claude/ perguntados
[ ] CLAUDE.md: criado (se não havia) ou seção anexada (se havia) — sem destruir conteúdo do usuário
[ ] Agentes de domínio sem {placeholder}; negócio só no filho
[ ] template-link.yaml gravado (created_via: adopt)
[ ] UNDERSTANDING_{projeto}.md gravado em docs/
[ ] NENHUM commit (nem no filho, nem no template); template inalterado
[ ] Relatório final exibido
```

---

## Casos especiais

| Situação | Ação |
|----------|------|
| Rodado fora do template (sem catalog.yaml) | Abortar — o /adopt vive só no template |
| Destino não existe ou está vazio | Abortar — use `/new-project` (greenfield) |
| Destino já tem `.claude/` completo (já é filho) | Avisar — provavelmente quer `/template-update`, não `/adopt` |
| Conflito de arquivo em `.claude/` | Perguntar: manter o do projeto / mesclar / pular |
| Stack não detectável com confiança | Perguntar ao usuário (cai no modo entrevista do /new-project) |
| Projeto sem git | Avisar (diff manual), seguir sem bloquear |
| KB faltante para o stack | Stub local no filho — NUNCA criar no acervo central |

---

## Referências

- Irmão greenfield: [.claude/commands/new-project.md](new-project.md)
- Entrevista e templates de agentes de domínio: [.claude/commands/project-init.md](project-init.md)
- Catálogo e regra de seleção: [catalog.yaml](../../../catalog.yaml)
- Explorador do código: [.claude/agents/exploration/codebase-explorer.md](../agents/exploration/codebase-explorer.md)
- Porta de volta ao acervo: [.claude/commands/distill.md](distill.md) → [.claude/commands/contribute.md](contribute.md)
