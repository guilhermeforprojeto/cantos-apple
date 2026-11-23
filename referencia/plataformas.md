# Código por plataforma

A conta é sempre a mesma: `raio_de_dentro = max(raio_de_fora − distância, 0)`, com um mínimo pequeno (≈4 px) se o resultado ficar perto de zero.

## Web (CSS)

```css
:root {
  --raio-card: 24px;
  --pad-card: 12px;
  --raio-dentro: max(calc(var(--raio-card) - var(--pad-card)), 4px);
}

.card {
  border-radius: var(--raio-card);
  padding: var(--pad-card);
}
.card .botao,
.card img {
  border-radius: var(--raio-dentro);
}

/* Foco por fora do elemento também é um "elemento de fora" */
.card:focus-visible {
  outline: 2px solid currentColor;
  outline-offset: 4px;
  /* o navegador já soma o offset ao raio do outline; confira no print */
}

/* Cantos contínuos: Chrome e Edge 139+. Safari e Firefox ficam com o arredondado comum. */
@supports (corner-shape: squircle) {
  .card,
  .card .botao,
  .card img {
    corner-shape: squircle;
  }
}
```

`corner-shape: squircle` é o mesmo que `superellipse(2)`. Com o mesmo `border-radius`, o squircle parece menos arredondado que o canto comum; compare no print e, se precisar, aumente o raio de fora (os de dentro acompanham pela conta).

Referências: [MDN `corner-shape`](https://developer.mozilla.org/en-US/docs/Web/CSS/corner-shape), [Can I use](https://caniuse.com/mdn-css_properties_corner-shape_squircle).

### Tailwind

```html
<!-- card 24px, padding 12px → dentro 12px -->
<div class="rounded-[24px] p-3">
  <button class="rounded-[12px]">Enviar</button>
</div>
```

Melhor ainda, tokens no tema (v4):

```css
@theme {
  --radius-card: 24px;
  --spacing-card: 12px;
  --radius-card-inner: calc(24px - 12px);
}
```

```html
<div class="rounded-card p-card">
  <button class="rounded-card-inner">Enviar</button>
</div>
```

## SwiftUI

Canto contínuo:

```swift
RoundedRectangle(cornerRadius: 24, style: .continuous)
```

Concêntrico automático (iOS, macOS, watchOS, tvOS e visionOS 26+):

```swift
VStack {
    Button("Enviar") { }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.tint, in: ConcentricRectangle())
}
.padding(12)
.containerShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
```

`ConcentricRectangle(corners: .concentric(minimum: 8))` evita que o canto zere quando o padding é grande. Antes do iOS 26, faça a conta:

```swift
let raioFora: CGFloat = 24
let pad: CGFloat = 12
// ...
.background(.tint, in: RoundedRectangle(cornerRadius: max(raioFora - pad, 4), style: .continuous))
```

Referência: [ConcentricRectangle](https://developer.apple.com/documentation/swiftui/concentricrectangle), [containerShape(_:)](https://developer.apple.com/documentation/swiftui/view/containershape(_:)).

## UIKit

```swift
view.layer.cornerRadius = 24
view.layer.cornerCurve = .continuous

botao.layer.cornerRadius = max(24 - 12, 4)
botao.layer.cornerCurve = .continuous
```

## Flutter (3.32+)

```dart
const raioFora = 24.0;
const pad = 12.0;

Container(
  padding: const EdgeInsets.all(pad),
  decoration: ShapeDecoration(
    color: Colors.black,
    shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(raioFora)),
  ),
  child: ClipRSuperellipse(
    borderRadius: BorderRadius.circular(raioFora - pad),
    child: Image.asset('foto.jpg'),
  ),
)
```

`RoundedSuperellipseBorder` é o formato mais próximo do iOS no Flutter; no Flutter web ele ainda desenha o arredondado comum. Evite `ContinuousRectangleBorder` para imitar o iOS: a curva não bate. Referência: [RoundedSuperellipseBorder](https://api.flutter.dev/flutter/painting/RoundedSuperellipseBorder-class.html).

## React Native

Sem canto contínuo nativo no estilo. Faça a conta:

```tsx
const R = 24, PAD = 12;
<View style={{ borderRadius: R, padding: PAD }}>
  <Pressable style={{ borderRadius: Math.max(R - PAD, 4) }} />
</View>
```

No iOS, `borderCurve: 'continuous'` dá o canto contínuo.

## Jetpack Compose

Sem squircle nativo. Faça a conta com `RoundedCornerShape` e, se o design exigir squircle, use uma biblioteca de shape (verifique manutenção e licença antes).

```kotlin
val raioFora = 24.dp
val pad = 12.dp
Box(Modifier.clip(RoundedCornerShape(raioFora)).padding(pad)) {
    Box(Modifier.clip(RoundedCornerShape(maxOf(raioFora - pad, 4.dp))))
}
```

## Figma

- Selecione a camada → painel de raio → **Corner smoothing**. 60% é o valor que o Figma marca como "iOS".
- Raio de dentro: a mesma conta. Com Auto Layout, o padding do frame é a `distância`.
