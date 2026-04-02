//
//  AppTabBarView.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 30.03.2026.
//

import SwiftUI
/*
🟢 value: Это имя(Ключ) для selection, по нему selection сравнивает какой Tab выбран
 
🔴 Старый метод у TabView: вместо Tab(новый iOS 18+), вызываем .tabItem(iOS 17 и более ранних версий
 
 ◉ Старый способ работы с TabView:
 TabView(selection: $selection) {
        Color.red
           .tabItem {
                Image(systemName: "house")
                Text("Home")
           }
*/
struct AppTabBarView: View {
    
    @State private var selection: String = "Home"
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            Color.blue
                .tabBarItem(.home, selection: $tabSelection)
            
            Color.green
                .tabBarItem(.favorites, selection: $tabSelection)
            
            Color.orange
                .tabBarItem(.profile, selection: $tabSelection)
            
                
        }
    }
}

#Preview {
    AppTabBarView()
}


extension AppTabBarView {
    
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house", value: "home") {
                            Color.red
                        }
                        
                        Tab("Favorites", systemImage: "heart", value: "favorites") {
                            Color.blue
                        }
                        
                        Tab("Profile", systemImage: "person", value: "profile") {
                            Color.orange
                        }
        }
    }
}
