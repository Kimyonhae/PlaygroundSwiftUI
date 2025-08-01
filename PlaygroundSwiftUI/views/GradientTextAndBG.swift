//
//  GradientTextAndBG.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 8/1/25.
//

import SwiftUI

struct GradientTextAndBG: View {
    var body: some View {
        VStack {
            Text("Text GridentColor")
                .gradientForeGround(colors: [.red, .blue])
                .font(.system(.largeTitle, design: .rounded).bold())
            Text("")
                .frame(maxWidth: 50, maxHeight: 50)
                .gradientBackground(colors: [.red, .blue])
        }
    }
}


extension View {
    func gradientForeGround(colors: [Color]) -> some View {
        self.overlay {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .mask(self)
    }
    
    func gradientBackground(colors: [Color]) -> some View {
        self.background(
            LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    GradientTextAndBG()
}
