//
//  CustomNavBarView.swift
//  AdvancedCours
//
//  Created by Алан Парастаев on 03.04.2026.
//

import SwiftUI

struct CustomNavBarView: View {
    
    @Environment(\.dismiss) var dismiss
    let showBackButton: Bool
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack {
            if showBackButton {
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if showBackButton {
                backButton
                .opacity(0)
            }
        }
        .font(.headline)
        .padding()
        .foregroundStyle(.white)
        .background(.blue)
    }
}

#Preview {
    VStack {
        CustomNavBarView(showBackButton: true, title: "Title here", subtitle: "Subtile goes here")
        Spacer()
    }
}


extension CustomNavBarView {
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
            }
            
            
        }
    }
}
