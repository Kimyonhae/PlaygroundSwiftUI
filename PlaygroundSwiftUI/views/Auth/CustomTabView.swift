//
//  CustomTabView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/16/25.
//

import SwiftUI

struct CustomTabView: View {
    var body: some View {
        TabView {
           Tab("LogOut", systemImage: "figure.run.circle") {
               Text("Logout")
           }
           Tab("Profile", systemImage: "person.crop.circle") {
               Text("Profile")
           }
        }
    }
}

#Preview {
    CustomTabView()
}
