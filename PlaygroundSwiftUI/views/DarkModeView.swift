//
//  DarkModeView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/18/25.
//

import SwiftUI


struct DarkModeView: View {
    @Environment(\.colorScheme) var isDarkMode
    
    var body: some View {
        ZStack {
            Color("ColorScheme")
            
            Text("Dark Mode")
                .onChange(of: isDarkMode) {
                    print(isDarkMode)
                }
        }
    }
}

#Preview {
    DarkModeView()
}
