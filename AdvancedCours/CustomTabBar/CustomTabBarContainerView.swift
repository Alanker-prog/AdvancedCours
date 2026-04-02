//
//  CustomTabBarContainerView.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 30.03.2026.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

#Preview {
    
    let tabs: [TabBarItem] = [.home, .favorites, .profile]
    
    CustomTabBarContainerView(selection: .constant(.home)) {
        Color.red
    }
}
