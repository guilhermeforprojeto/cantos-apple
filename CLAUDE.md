# AGENTS.md — cantos-apple

Você (IA) recebeu o link deste repositório. O objetivo é deixar os cantos arredondados da interface do usuário no padrão da Apple: **concêntricos** (raio de dentro = raio de fora − distância) e **contínuos** (squircle) onde a plataforma suporta.

## O que fazer

1. **Leia** [`skills/cantos-apple/SKILL.md`](skills/cantos-apple/SKILL.md). Ele é o procedimento completo: mapear, calcular, aplicar, conferir e relatar.
2. **Descubra a plataforma** do projeto (web/CSS, Tailwind, React Native, SwiftUI, UIKit, Flutter, Compose) e use o trecho correspondente de [`referencia/plataformas.md`](referencia/plataformas.md).
3. **Pergunte uma vez** se o usuário quer:
   - **corrigir agora** (você segue o SKILL.md no projeto aberto), ou
   - **instalar a skill** para usar `/cantos-apple` quando quiser. Para instalar, peça permissão e rode, a partir de um clone deste repositório:
     - macOS/Linux: `bash instalar.sh` (ou `bash instalar.sh --projeto` para instalar só no projeto atual)
     - Windows: `powershell -ExecutionPolicy Bypass -File instalar.ps1`
     - ou `npx skills add guilhermeforprojeto/cantos-apple`
   Se o usuário já pediu um dos dois de forma clara, não pergunte.
4. **Antes de editar,** confira se o projeto está num repositório git com as mudanças salvas, para dar para desfazer. Se não estiver, avise.
5. **Entregue** a tabela do passo "Relatar" do SKILL.md e, se possível, prints antes e depois.

## Regras

- Mude só raios de canto (e `corner-shape`/`cornerCurve`/`style: .continuous`). Se o concêntrico exigir mudar padding, pergunte.
- Não arredonde o que era reto por decisão de design.
- Não troque `border-radius` por SVG ou `clip-path` para imitar squircle.
- Na web, `corner-shape` só vale dentro de `@supports (corner-shape: squircle)`. Safari e Firefox ainda não suportam; a conta concêntrica vale em todos.
