---
name: cantos-apple
description: Corrige os cantos arredondados de uma interface no padrão da Apple. Deixa elementos aninhados concêntricos (raio de dentro = raio de fora menos o espaço entre eles) e troca o arredondado comum por cantos contínuos (squircle) onde a plataforma permite. Use quando pedirem /cantos-apple, "cantos da Apple", "cantos concêntricos", "squircle", "border-radius aninhado" ou quando um card, botão, input, modal ou imagem dentro de outro elemento arredondado parecer "torto".
---

# /cantos-apple

Duas regras fazem um canto parecer "de Apple":

1. **Concentricidade.** Quando um elemento arredondado está dentro de outro, as duas curvas têm o mesmo centro. Na prática:

   ```
   raio_de_dentro = max(raio_de_fora − distância, 0)
   distância = padding + largura da borda do elemento de fora (no canto)
   ```

   Usar o mesmo raio dentro e fora é o erro mais comum: o canto de dentro fica "gordo" e o espaço no canto fica mais largo que nas laterais.

2. **Curvatura contínua (squircle).** O `border-radius` comum é um quarto de círculo colado numa reta, e a curvatura salta de zero para o máximo de uma vez. A Apple usa uma curva que começa suave na reta e vai fechando aos poucos. Use o recurso nativo de cada plataforma (tabela abaixo) e nunca troque o arredondado por SVG ou máscara feita à mão só por isso.

## Como trabalhar

### 1. Mapear

Procure no projeto todos os arredondamentos:

- **CSS/SCSS/Tailwind:** `border-radius`, `rounded-*`, `rounded-[...]`, variáveis como `--radius`.
- **React Native:** `borderRadius`.
- **SwiftUI/UIKit:** `cornerRadius`, `RoundedRectangle`, `.clipShape`, `layer.cornerRadius`.
- **Flutter:** `BorderRadius`, `RoundedRectangleBorder`, `ClipRRect`.
- **Jetpack Compose:** `RoundedCornerShape`.

Para cada elemento arredondado, descubra se ele está **dentro** de outro elemento arredondado (componente pai, wrapper, card, modal, sheet, input com botão dentro, imagem dentro de card, item de lista dentro de container). São esses pares que importam.

### 2. Calcular

Para cada par (fora → dentro):

| Dado | Como achar |
| --- | --- |
| `raio_de_fora` | Raio do elemento de fora |
| `distância` | Padding do elemento de fora no lado do canto + borda dele. Se o de dentro tiver margem até o de fora, some a margem |
| `raio_de_dentro` | `max(raio_de_fora − distância, 0)` |

Regras de borda:

- **Padding diferente na horizontal e na vertical:** use o menor dos dois e sugira igualar o padding perto dos cantos, porque concêntrico perfeito com distâncias diferentes não existe com arcos simples.
- **Resultado muito pequeno (menor que 4 px):** prefira um mínimo pequeno (4 px) em vez de canto reto, a menos que o design seja de cantos retos. É o que o `concentric(minimum:)` da Apple faz.
- **Pílula (`9999px`, `rounded-full`, raio = metade da altura):** se o de fora é pílula e o padding é igual em volta, o de dentro também é pílula. Não calcule; mantenha `9999px`/`rounded-full`.
- **Vários níveis (card → bloco → botão):** calcule de fora para dentro, cada nível usando o resultado do anterior.
- **O elemento de dentro encosta na borda (padding 0), como imagem no topo do card:** use o mesmo raio de fora nos cantos que encostam e `overflow: hidden`/`clip` no pai.

### 3. Aplicar

**Prefira tokens a números soltos.** Na web:

```css
.card {
  --r: 24px;
  --pad: 12px;
  border-radius: var(--r);
  padding: var(--pad);
}
.card > .inner {
  border-radius: max(calc(var(--r) - var(--pad)), 4px);
}

/* Cantos contínuos onde o navegador suporta (Chrome e Edge 139+). Nos outros, fica o arredondado comum. */
@supports (corner-shape: squircle) {
  .card, .card > .inner { corner-shape: squircle; }
}
```

No Tailwind, use valor arbitrário com a conta explícita (`rounded-[calc(24px-12px)]`) ou crie tokens no tema; não escolha o `rounded-*` "mais parecido".

Código por plataforma em `referencia/plataformas.md` (no repositório `guilhermeforprojeto/cantos-apple`), resumo:

| Plataforma | Contínuo | Concêntrico |
| --- | --- | --- |
| Web (CSS) | `corner-shape: squircle` dentro de `@supports` | `max(calc(R − pad), 4px)` |
| SwiftUI | `RoundedRectangle(cornerRadius:, style: .continuous)` | iOS 26+: `ConcentricRectangle()` + `.containerShape(...)` no pai; antes: a conta |
| UIKit | `layer.cornerCurve = .continuous` | a conta |
| Flutter 3.32+ | `RoundedSuperellipseBorder` / `ClipRSuperellipse` (na web cai para arredondado comum) | a conta |
| Jetpack Compose | sem nativo: biblioteca de squircle ou manter `RoundedCornerShape` | a conta |
| Figma | Corner smoothing 60% (iOS) | a conta |

### 4. Conferir

- Se houver Playwright ou navegador disponível, tire print **antes e depois** dos componentes alterados e olhe os cantos de perto (zoom). O espaço entre as duas curvas deve ter a mesma largura do padding das laterais.
- Confira estados (hover, focus ring, selecionado): um `outline` ou `box-shadow` de foco por fora do elemento também é um "elemento de fora" e precisa de raio `R + distância`.
- Rode os testes visuais/snapshot do projeto, se existirem, e avise quais mudaram.

### 5. Relatar

Entregue uma tabela curta:

| Componente | Arquivo | Antes | Depois | Por quê |
| --- | --- | --- | --- | --- |
| Botão dentro do input | `src/components/Search.tsx` | 16px | 10px | input 16px − padding 6px |

E diga onde o canto contínuo foi ativado e onde não há suporte (Safari/Firefox na web, Compose, Flutter web).

## Não faça

- Não aplique o mesmo raio em tudo "para padronizar". Padronize o **raio de fora** e calcule os de dentro.
- Não arredonde elementos que eram retos por decisão de design (tabelas, divisores, imagens de borda a borda).
- Não troque `border-radius` por `clip-path`/SVG para imitar squircle sem o usuário pedir: quebra borda, sombra e foco.
- Não mexa em cores, espaçamentos ou layout além do necessário para os cantos. Se o padding precisar mudar para o concêntrico funcionar, pergunte.
