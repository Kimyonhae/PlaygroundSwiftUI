//
//  LoginPage.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/16/25.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
            Group {
                TextField("Write email", text: $email)
                TextField("Write Password", text: $password)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
            }
            buttonStyle("Login",color: .blue) {
                // move login completion view
                coordinator.push(.loginSuccess)
            }
            buttonStyle("Register Move", color: .red) {
                coordinator.push(.register)
            }
        }
        .padding()
        .navigationTitle("로그인")
    }
    
    // TODO: UICommon Button Style
    private func buttonStyle(_ title: String, color: Color, completion: @escaping() -> Void) -> some View {
        Button(title) {
            completion()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: 12))
    }
}


#Preview {
    LoginPage()
        .environmentObject(Coordinator())
}
