//
//  CustomNavLink.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 04.04.2026.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View {
    
    let label: Label
    let destination: Destination
    
    init(destination: Destination, @ViewBuilder label: () -> Label ) {
        self.destination = destination
        self.label = label()
    }
    
    
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
        } label: {
            label
        }

    }
}

#Preview {
    CustomNavView {
        CustomNavLink(destination: Text("Destination")) {
            Text("Kleck ME")
        }
    }
    }
