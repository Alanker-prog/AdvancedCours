//
//  TabBarItemsPreferenceKey.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 31.03.2026.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemsViewModifiers: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1 : 0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    
    func tabBarItem(_ tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemsViewModifiers(tab: tab, selection: selection))
    }
}
