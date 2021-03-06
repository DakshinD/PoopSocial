//
//  Extensions.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI
import Combine


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

struct CustomGradientButton: ButtonStyle {
    
    var disabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.text)
            .background(configuration.isPressed ? LinearGradient(colors: [.red, .orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [.red.opacity(0.6), .orange.opacity(0.6), .yellow.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .brightness(disabled ? -0.2 : 0)
            .cornerRadius(15)
            .shadow(radius: 5)
            .scaleEffect(configuration.isPressed ? 0.9:1.0)
    }
    
}

struct CustomSolidButton: ButtonStyle {
    
    var disabled: Bool = false
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.text)
            .background(configuration.isPressed ? color : color.opacity(0.7))
            .brightness(disabled ? -0.2 : 0)
            .cornerRadius(15)
            .shadow(radius: 5)
            .scaleEffect(configuration.isPressed ? 0.9:1.0)
    }
    
}


//NOTE: - Custom Time-Ago Date Format
extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}

//NOTE: - Custom View Modifier for Text Fields
struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                        .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
            .shadow(radius: 10)
    }
}

struct GradientTextFieldBackground: TextFieldStyle {
    
    let systemImageString: String
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [
                            .red,
                            .yellow,
                            .orange
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ), lineWidth: 3.5
                )
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.secondary))
                .frame(height: 50)
                
            
            HStack {
                Image(systemName: systemImageString)
                // Reference the TextField here
                configuration
            }
            .padding(.leading)
            .foregroundColor(.gray)
        }
    }
}

// NOTE: - To dismiss keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
