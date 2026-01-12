//
//  ScrollViewOffsetPreferenceKeyBinding.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 12.01.2026.
//

import SwiftUI

// MARK: - PreferenceKey

struct ScrollViewOffsetPreferenceKeyBin: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - View Extension (Binding instead of closure)

extension View {
    func onScrollViewOffsetChange(_ offset: Binding<CGFloat>) -> some View {
        self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ScrollViewOffsetPreferenceKeyBin.self,
                            value: geo.frame(in: .global).minY
                        )
                }
            }
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) {
                offset.wrappedValue = $0
            }
    }
}

// MARK: - Main View

struct ScrollViewOffsetPreferenceKeyBinding: View {

    let title: String = "New Title Here!"
    @State private var scrollViewOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()

            ScrollView {
                VStack {
                    titleLayer
                        .opacity(Double(scrollViewOffset) / 78.0)
                        .onScrollViewOffsetChange($scrollViewOffset)

                    contentLayer
                }
                .padding()
            }
            .overlay {
                Text("\(scrollViewOffset)")
            }
            .overlay(alignment: .top) {
                navBarLayer
                    .opacity(scrollViewOffset < -7.0 ? 1.0 : 0.0)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollViewOffsetPreferenceKeyBinding()
}

// MARK: - Subviews

extension ScrollViewOffsetPreferenceKeyBinding {

    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var contentLayer: some View {
        ForEach(0..<30, id: \.self) { _ in
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 300, height: 200)
                .foregroundStyle(Color.blue.opacity(0.5))
        }
    }

    private var navBarLayer: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.red)
    }
}
