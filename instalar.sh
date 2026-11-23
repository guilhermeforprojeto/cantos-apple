#!/usr/bin/env bash
# Instala a skill /cantos-apple no Claude Code (para todos os projetos).
# Uso: bash instalar.sh            -> ~/.claude/skills/cantos-apple
#      bash instalar.sh --projeto  -> ./.claude/skills/cantos-apple (só este projeto)
set -euo pipefail

ORIGEM="$(cd "$(dirname "$0")" && pwd)/skills/cantos-apple"
if [[ "${1:-}" == "--projeto" ]]; then
  DESTINO="./.claude/skills/cantos-apple"
else
  DESTINO="$HOME/.claude/skills/cantos-apple"
fi

[[ -f "$ORIGEM/SKILL.md" ]] || { echo "❌ Não achei skills/cantos-apple/SKILL.md. Rode a partir do repositório clonado."; exit 1; }

mkdir -p "$DESTINO"
cp "$ORIGEM/SKILL.md" "$DESTINO/SKILL.md"
echo "✅ Skill instalada em $DESTINO"
echo "   Abra o Claude Code no seu projeto e digite: /cantos-apple"
