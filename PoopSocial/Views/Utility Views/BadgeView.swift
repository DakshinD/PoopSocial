//
//  BadgeView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/30/22.
//

import SwiftUI

struct Badge: View {
    
    @Binding var count: Int

    var body: some View {
        
        if count > 0 {
            ZStack(alignment: .topTrailing) {
                
                Color.clear
                
                Text(String(count))
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: 16))
                    .padding(5)
                    .background(Color.red)
                    .clipShape(Circle())
                    // custom positioning in the top-right corner
                    .alignmentGuide(.top) { $0[.bottom] }
                    .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
                
            }
        } else {
            EmptyView()
        }
    
    }
    
}


