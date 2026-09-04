# FinanceStats — estadísticas de gastos por categoría en SwiftUI

Pantalla de estadísticas de un presupuesto personal: un anillo de gasto por categoría,
un carrusel de periodos (semana, mes, año) con un efecto 3D al desplazar, y una leyenda
con el detalle de cada categoría. Pensada como pieza de portafolio para mostrar
composición de vistas con `UIViewRepresentable`, geometría de UI aislada y testeable, y
cálculo monetario con `Decimal` en un contexto de reportes financieros.

<img width="1315" height="767" alt="FinanceStats" src="https://github.com/user-attachments/assets/6ecd0a26-3381-421c-b94b-d47f918ae357" />

---

## Tecnologías usadas

- Swift 6, con verificación estricta de concurrencia
- SwiftUI, con un carrusel propio sobre `UIViewRepresentable`/`UIScrollView`
- `@Observable`, `@MainActor`
- `Decimal` para todo importe de gasto
- Swift Testing para pruebas
- Integración continua con GitHub Actions
- Cero dependencias externas

---

## Cómo está organizado el proyecto

```
FinanceStats/
├── FinanceStatsApp.swift   Punto de entrada
├── Design/                  Tokens de color/espaciado (DS)
├── Models/
│   ├── CategoryKind.swift   Catálogo cerrado de categorías (nombre + color)
│   ├── ExpenseModels.swift  Period, ExpenseCategory, MonthData
│   ├── MockDataStore.swift  Datos de ejemplo (semana/mes/año)
│   └── Money.swift          Formateo de Decimal a texto ("$1.2K", "$450")
├── ViewModels/
│   └── StatisticsViewModel.swift
└── Views/
    ├── StatisticsView.swift      Pantalla principal
    ├── PeriodSelectorView.swift  Selector Semana/Mes/Año
    ├── MonthScrollView.swift     Carrusel con tilt 3D
    ├── ExpenseRingView.swift     Anillo de gasto
    ├── RingLayout.swift          Geometría pura del anillo (testeable)
    ├── ExpenseLegendView.swift   Leyenda de categorías
    └── Components.swift          Pill, Dot
```

---

## Cómo funciona / flujo principal

1. `StatisticsViewModel` carga el conjunto de datos del periodo activo (`MockDataStore`) y
   selecciona el primer elemento.
2. Al tocar Semana/Mes/Año se recarga el conjunto de datos correspondiente y se reinicia
   la selección.
3. Al deslizar el carrusel de meses/semanas, cada tarjeta se centra sola y dispara la
   actualización del mes seleccionado.
4. El anillo (`ExpenseRingView` + `RingLayout`) dibuja un segmento por categoría con gasto,
   proporcional a su participación en el total, con una animación de entrada.
5. La leyenda muestra el monto exacto de cada categoría debajo del anillo.

---

## Funcionalidades / qué demuestra

- Geometría del anillo (gaps visibles, mínimo angular por categoría, renormalización para
  que el anillo cierre en 100%) separada en `RingLayout`, sin depender de SwiftUI — se
  puede probar con datos arbitrarios.
- Catálogo de categorías como `enum CaseIterable` en vez de `String` sueltos: antes una
  categoría completa (Entretenimiento) se perdía en silencio del total por un typo de
  nombre entre el catálogo y los datos; con el enum esa clase de error ya no compila.
- Carrusel centrado con inclinación 3D construido a mano sobre `UIScrollView`.
- Formateo de `Decimal` a texto compacto ("$56.5K") y plano ("$10417"), con locale fijo.

---

## Pruebas

14 pruebas con Swift Testing sobre la lógica de negocio (sin UI):

- `RingLayout` — los segmentos llenan el anillo, todo monto positivo recibe al menos el
  mínimo angular, una lista vacía no produce segmentos, un total en cero no genera `NaN`.
- `MockDataStore` — cada mes trae las nueve categorías en el orden del catálogo, ninguna
  categoría se pierde del total (cubre directamente el bug de Entretenimiento), y los tres
  periodos tienen datos.
- `StatisticsViewModel` — estado inicial, recarga y reinicio de selección al cambiar de
  periodo, `setIndex` dentro y fuera de rango.
- Formateo monetario (`Decimal.formattedCompact`/`formattedPlain`).

```bash
xcodebuild test \
  -project FinanceStats.xcodeproj \
  -scheme FinanceStats \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro"
```

---

## Cosas pendientes o limitadas (a propósito)

Es una pantalla de estadísticas, no una app de finanzas completa:

- Los datos son fijos (`MockDataStore`); no hay entrada de transacciones ni persistencia.
- No hay backend ni sincronización — todo vive en memoria durante la sesión.
- El botón "atrás" y el "..." de la barra superior son solo visuales.

---

## Cómo correr el proyecto

1. Clonar el repositorio y abrir `FinanceStats.xcodeproj` en Xcode 26 o superior.
2. Seleccionar el esquema `FinanceStats` y un simulador de iOS 26.
3. Ejecutar (⌘R). No requiere configuración adicional ni claves de API.

---

## Autor

Stephano Portella
