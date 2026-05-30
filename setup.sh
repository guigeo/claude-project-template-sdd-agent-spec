#!/bin/bash
# setup.sh — Inicializa um novo projeto com o claude-project-template
# Uso: ./setup.sh <nome-do-projeto> [diretorio-destino]

set -e

PROJECT_NAME=${1:-"meu-projeto"}
TARGET_DIR=${2:-"$(pwd)/$PROJECT_NAME"}
TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
  echo "Uso: ./setup.sh <nome-do-projeto> [diretorio-destino]"
  echo "Exemplo: ./setup.sh minha-api /Users/joao/Projetos"
  exit 1
fi

echo "Criando projeto: $PROJECT_NAME"
echo "Destino: $TARGET_DIR"
echo ""

# Cria a pasta do projeto
mkdir -p "$TARGET_DIR"

# Copia toda a estrutura .claude
cp -r "$TEMPLATE_DIR/.claude" "$TARGET_DIR/.claude"

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
echo "  3. /sync-context          → gera CLAUDE.md com contexto real do projeto"
echo "  4. /create-kb 'fastapi'   → cria KB para o seu stack"
echo "  5. /brainstorm '...'      → começa a primeira feature"
echo ""
echo "Para criar agentes de dominio:"
echo "  Copie .claude/agents/_template.md.example para .claude/agents/domain/"
