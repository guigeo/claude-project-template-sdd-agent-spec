#!/bin/bash
# setup.sh — Inicializa um novo projeto com o claude-project-template (copia tudo)
# Para cópia SELETIVA por stack, prefira rodar /new-project no Claude Code dentro deste repo.
# Uso: ./setup.sh <nome-do-projeto> [diretorio-destino]

set -e

PROJECT_NAME=${1:-"meu-projeto"}
TARGET_DIR="${2:-"$(pwd)"}/$PROJECT_NAME"
TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
  echo "Uso: ./setup.sh <nome-do-projeto> [diretorio-destino]"
  echo "Exemplo: ./setup.sh minha-api /Users/joao/Projetos"
  echo ""
  echo "Dica: para copia seletiva por stack, rode /new-project no Claude Code dentro do template."
  exit 1
fi

# Nunca sobrescrever um destino existente com conteudo
if [ -d "$TARGET_DIR" ] && [ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
  echo "ERRO: o diretorio $TARGET_DIR ja existe e nao esta vazio. Abortando."
  exit 1
fi

echo "Criando projeto: $PROJECT_NAME"
echo "Destino: $TARGET_DIR"
echo ""

# Cria a pasta do projeto
mkdir -p "$TARGET_DIR"

# Copia toda a estrutura .claude (sem lixo do macOS)
cp -r "$TEMPLATE_DIR/.claude" "$TARGET_DIR/.claude"
find "$TARGET_DIR" -name ".DS_Store" -delete

# O CLAUDE.md do template descreve o proprio template — o filho recebe a versao placeholder
if [ -f "$TARGET_DIR/.claude/CLAUDE.md.template" ]; then
  mv "$TARGET_DIR/.claude/CLAUDE.md.template" "$TARGET_DIR/.claude/CLAUDE.md"
fi

# /new-project e /adopt sao exclusivos do template
rm -f "$TARGET_DIR/.claude/commands/new-project.md"
rm -f "$TARGET_DIR/.claude/commands/adopt.md"

# Cria .gitignore basico
cat > "$TARGET_DIR/.gitignore" << 'EOF'
.DS_Store
__pycache__/
*.pyc
.env
.env.local
node_modules/
EOF

# Inicializa git
cd "$TARGET_DIR"
git init
git add .
git commit -m "feat: initialize project from claude-project-template"

echo ""
echo "Projeto criado com sucesso em: $TARGET_DIR"
echo ""
echo "Proximos passos:"
echo "  1. cd $TARGET_DIR"
echo "  2. Abra no Claude Code (code . ou cursor .)"
echo "  3. /project-init          → instala KBs, cria agentes de dominio e preenche CLAUDE.md"
echo "  4. /sync-context          → gera arquitetura apos adicionar codigo-fonte"
echo "  5. /brainstorm '...'      → comeca a primeira feature"
