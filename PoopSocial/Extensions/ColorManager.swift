//
//  ColorManager.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI

extension Color {
    
    static let background = Color("Background")
    static let secondary = Color("Secondary")
    static let text = Color("Text")
    static let accent = Color("Accent")
    static let accentSecondary = Color("ButtonPressed")
    static let tertiary = Color("Tertiary")
    static let tertiaryText = Color("TertiaryText")
    static let normalGradient = LinearGradient(colors: [.red, .orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let dimGradient = LinearGradient(colors: [.red.opacity(0.6), .orange.opacity(0.6), .yellow.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
}
