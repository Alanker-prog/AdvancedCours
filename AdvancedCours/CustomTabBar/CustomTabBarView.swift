//
//  CustomTabBarView.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 30.03.2026.
//

import SwiftUI

// MARK: - CustomTabBarView

struct CustomTabBarView: View {
    
    // MARK: - Properties
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State private var localSelection: TabBarItem
    
    // MARK: - Init
    /*
     🔧 ЗАЧЕМ НУЖЕН INIT
     
     Проблема:
     @State нельзя инициализировать напрямую из другой переменной —
     на этапе объявления свойств, другие свойства ещё недоступны.
     
     ❌ Так не работает:
     @State private var localSelection: TabBarItem = selection
     // selection ещё не существует в этот момент
     
     Решение — init:
     В init все параметры уже доступны, поэтому здесь
     можно синхронизировать @State с переданным @Binding.
     
     Что делает каждая строка:
     
     self.tabs = tabs
     → обычное присвоение массива табов
     
     self._selection = selection
     → _ (нижнее подчёркивание) = обращаемся не к значению,
       а к самой обёртке @Binding
       без _ мы бы обращались к TabBarItem (значению)
       с _  мы обращаемся к Binding<TabBarItem> (обёртке)
     
     self._localSelection = State(initialValue: selection.wrappedValue)
     → аналогично — _ обращается к обёртке @State напрямую
       selection.wrappedValue — достаём реальное значение из Binding
       State(initialValue:)   — создаём @State с начальным значением
     
     Итог:
     localSelection стартует с тем же значением что и selection,
     но дальше живёт независимо — меняется только через onChange
     с анимацией, пока selection меняет контент мгновенно.
     
     Два разных процесса:
       selection      → переключает контент (мгновенно)
       localSelection → анимирует таббар   (плавно через onChange)
    */
    
    init(tabs: [TabBarItem], selection: Binding<TabBarItem>) {
        self.tabs = tabs
        self._selection = selection  // _ = обращаемся к обёртке Binding
        self._localSelection = State(initialValue: selection.wrappedValue)
        //                     ↑                   ↑
        //                   инициализируем       берём текущее значение
        //                   @State напрямую      из Binding
    }
    
    // MARK: - Body
    
    var body: some View {
        // 💡 Переключение между версиями:
        // tabBarVersion1 — простая подсветка фона
        // tabBarVersion2 — анимация с matchedGeometryEffect
        tabBarVersion2
            .onChange(of: selection) { _, newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            }
    }
}

// MARK: - Shared Logic

extension CustomTabBarView {
    
    private func switchToTab(_ tab: TabBarItem) {
        selection = tab
    }
}

// MARK: - Version 1 | Simple Background Highlight

extension CustomTabBarView {
    
    /// Простая версия — фон меняется без анимации перехода
    private func tabView1(tab: TabBarItem) -> some View {
        let isSelected = localSelection == tab
        
        return VStack(spacing: 4) {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(isSelected ? tab.color : .secondary)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(isSelected ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
    
    private var tabBarVersion1: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabView1(tab: tab)
                    .onTapGesture {
                        switchToTab(tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white)
    }
}

// MARK: - Version 2 | Matched Geometry Effect

extension CustomTabBarView {
    
    /// Продвинутая версия — фон плавно скользит между табами
    private func tabView2(tab: TabBarItem) -> some View {
        let isSelected = localSelection == tab
        
        return VStack(spacing: 4) {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(isSelected ? tab.color : .secondary)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
    
    private var tabBarVersion2: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 0)
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    let tabs: [TabBarItem] = [.home, .favorites, .profile]
    
    VStack {
        Spacer()
        CustomTabBarView(tabs: tabs, selection: .constant(tabs[0]))
    }
}
