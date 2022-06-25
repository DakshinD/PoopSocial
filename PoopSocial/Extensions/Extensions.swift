//
//  Extensions.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI


//NOTE: - Custom Button Style

struct CustomButton: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.accentSecondary:Color.accent)
            .cornerRadius(25)
            .shadow(radius: 5)
            .scaleEffect(configuration.isPressed ? 0.9:1.0)
    }
}
