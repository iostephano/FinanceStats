//
//  MonthScrollView.swift
//  FinanceStats
//
//  Created by Stephano Portella on 07/09/25.
//

import SwiftUI
import UIKit

struct MonthScrollView: View {
    let months: [MonthData]
    @Binding var index: Int
    var onChange: (Int) -> Void

    private let itemWidth: CGFloat = 110
    private let itemHeight: CGFloat = 44
    private let spacing: CGFloat = 16

    @State private var hoverIndex: Int = 0

    var body: some View {
        // GeometryReader propio para centrar el tilt 3D de cada ítem: UIScreen.main quedó
        // deprecado en iOS 26, y el ancho del propio carrusel es una referencia más correcta
        // de todas formas (ya viene con el padding horizontal de la pantalla descontado).
        GeometryReader { outerGeo in
            let containerFrame = outerGeo.frame(in: .global)

            CenteringCarousel(
                itemCount: months.count,
                itemSize: CGSize(width: itemWidth, height: itemHeight),
                spacing: spacing,
                index: $index,
                hoverIndex: $hoverIndex,
                onIndexChange: onChange
            ) {
                ForEach(months.indices, id: \.self) { i in
                    WheelItem(
                        title: months[i].monthName,
                        width: itemWidth,
                        height: itemHeight,
                        containerMidX: containerFrame.midX,
                        containerHalfWidth: containerFrame.width / 2
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if index != i {
                            index = i
                            onChange(i)
                        }
                    }
                }
            }
        }
        .frame(height: 56)
    }
}

// UIScrollView propio en vez de un ScrollView de SwiftUI: se necesita centrar el ítem
// seleccionado con precisión de píxel y controlar el snap manualmente.
private struct CenteringCarousel<Content: View>: UIViewRepresentable {
    let itemCount: Int
    let itemSize: CGSize
    let spacing: CGFloat
    @Binding var index: Int
    @Binding var hoverIndex: Int
    let onIndexChange: (Int) -> Void
    @ViewBuilder var content: () -> Content

    typealias Hosting = UIHostingController<AnyView>

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIScrollView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.decelerationRate = .fast
        scroll.clipsToBounds = false
        scroll.delegate = context.coordinator

        let hosted = AnyView(
            HStack(spacing: spacing) { content() }
                .frame(height: itemSize.height)
        )
        let hosting = Hosting(rootView: hosted)
        hosting.view.backgroundColor = .clear
        hosting.view.translatesAutoresizingMaskIntoConstraints = false

        scroll.addSubview(hosting.view)
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            hosting.view.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)
        ])

        context.coordinator.scrollView = scroll
        context.coordinator.hosting = hosting

        return scroll
    }

    func updateUIView(_ scroll: UIScrollView, context: Context) {
        let inset = max(0, (scroll.bounds.width - itemSize.width) / 2)
        let newInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        if scroll.contentInset != newInset { scroll.contentInset = newInset }

        if let hosting = context.coordinator.hosting {
            hosting.rootView = AnyView(
                HStack(spacing: spacing) { content() }
                    .frame(height: itemSize.height)
            )
        }

        DispatchQueue.main.async {
            context.coordinator.scrollTo(
                index: index,
                animated: true,
                force: true,
                itemWidth: itemSize.width,
                spacing: spacing
            )
        }
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: CenteringCarousel
        weak var scrollView: UIScrollView?
        weak var hosting: Hosting?

        private var isProgrammaticScroll = false

        init(_ parent: CenteringCarousel) { self.parent = parent }

        private func targetOffset(for index: Int, itemWidth: CGFloat, spacing: CGFloat) -> CGFloat {
            guard let scroll = scrollView else { return 0 }
            let step = itemWidth + spacing
            let x = CGFloat(index) * step - (scroll.bounds.width - itemWidth) / 2
            return max(
                -scroll.contentInset.left,
                min(x, scroll.contentSize.width - scroll.bounds.width + scroll.contentInset.right)
            )
        }

        func scrollTo(index: Int, animated: Bool, force: Bool, itemWidth: CGFloat, spacing: CGFloat) {
            guard let scroll = scrollView else { return }
            let target = targetOffset(for: index, itemWidth: itemWidth, spacing: spacing)
            if !force, abs(scroll.contentOffset.x - target) < 0.5 { return }
            isProgrammaticScroll = true
            scroll.setContentOffset(CGPoint(x: target, y: 0), animated: animated)
            if animated {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    guard let self, let s = self.scrollView else { return }
                    self.isProgrammaticScroll = false
                    self.updateHoverIndex(using: s)
                }
            } else {
                isProgrammaticScroll = false
                updateHoverIndex(using: scroll)
            }
        }

        /// Cálculo del índice centrado y actualización segura en main.
        private func updateHoverIndex(using scrollView: UIScrollView) {
            let step = parent.itemSize.width + parent.spacing
            let raw = (scrollView.contentOffset.x + scrollView.contentInset.left) / step
            let nearest = max(0, min(parent.itemCount - 1, Int(round(raw))))

            guard parent.hoverIndex != nearest else { return }
            if Thread.isMainThread {
                parent._hoverIndex.wrappedValue = nearest
            } else {
                DispatchQueue.main.async { [parent] in
                    parent._hoverIndex.wrappedValue = nearest
                }
            }
        }

        // MARK: UIScrollViewDelegate

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            updateHoverIndex(using: scrollView)
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate { snapToNearest(scrollView) }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            snapToNearest(scrollView)
        }

        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            updateHoverIndex(using: scrollView)
        }

        private func snapToNearest(_ scrollView: UIScrollView) {
            guard !isProgrammaticScroll else { return }
            updateHoverIndex(using: scrollView)
            let nearest = parent.hoverIndex

            let applySelection = {
                if self.parent.index != nearest {
                    self.parent._index.wrappedValue = nearest
                    self.parent.onIndexChange(nearest)
                }
                self.scrollTo(
                    index: nearest,
                    animated: true,
                    force: true,
                    itemWidth: self.parent.itemSize.width,
                    spacing: self.parent.spacing
                )
            }

            if Thread.isMainThread { applySelection() }
            else { DispatchQueue.main.async { applySelection() } }
        }
    }
}

// Ítem con inclinación 3D según su distancia al centro de la pantalla.
private struct WheelItem: View {
    let title: String
    let width: CGFloat
    let height: CGFloat
    let containerMidX: CGFloat
    let containerHalfWidth: CGFloat

    var body: some View {
        GeometryReader { geo in
            let midX = geo.frame(in: .global).midX
            // Normalizado -1…1 según distancia horizontal al centro del carrusel: izquierda ≈ -1, centro 0, derecha ≈ 1.
            let norm = containerHalfWidth > 0
                ? max(-1, min(1, (midX - containerMidX) / containerHalfWidth))
                : 0
            let t = min(1, abs(norm))

            let angle = Double(norm) * 62.0
            let falloff = pow(1 - t, 0.60)
            let scale = 0.72 + 0.28 * falloff
            let opacity = 0.55 + 0.45 * falloff
            let depthZ = 1 - Double(t)

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(DS.ColorToken.textSecondary)
                .frame(width: width, height: height)
                .rotation3DEffect(
                    .degrees(angle),
                    axis: (x: 0, y: 1, z: 0),
                    anchorZ: 0.5,
                    perspective: 1.18
                )
                .scaleEffect(scale)
                .opacity(opacity)
                .zIndex(depthZ)
                .shadow(color: .black.opacity(0.20 * (1 - falloff)), radius: 3, x: 0, y: 1)
        }
        .frame(width: width, height: height)
    }
}
