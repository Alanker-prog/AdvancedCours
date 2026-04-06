//
//  AppNavBarView.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 03.04.2026.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink(destination:
                                Text("Screen 2 goes here")
                    .customNavigationTitle("Second screen title")
                    .customNavigationSubtitle("Second screen subtitle")
                ) {
                    Text("Transition for 2 screen")
                }
            }
            .customNavBarItems(title: "Custom Title", subtitle: "Custom subtitle", isHidden: true)
        }
    }
}

#Preview {
    AppNavBarView()
}
 

extension AppNavBarView {
    
    private var defaultNavView: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea()
                
                NavigationLink {
                    Text("View2")
                        .navigationTitle("Screen2")
                } label: {
                    Text("Screen2 ->")
                }

            }
            .navigationTitle("Nav Title 1")
        }
    }
}
