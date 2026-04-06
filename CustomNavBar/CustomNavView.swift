//
//  CustomNavView.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 04.04.2026.
//

import SwiftUI

struct CustomNavView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            CustomNavBarContainerView {
                content
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        
    }
}

#Preview {
    CustomNavView {
        Color.red.ignoresSafeArea()
    }
}

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
