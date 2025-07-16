//
//  RegisterPage.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/16/25.
//

import SwiftUI

struct RegisterPage: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    var body: some View {
        VStack {
            Group {
                TextField("Write email", text: $email)
                TextField("Write Password", text: $password)
                TextField("Write confirmPassword", text: $confirmPassword)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1)
            }
            buttonStyle("Register", color: .blue) {
                coordinator.push(.login)
            }
            buttonStyle("Login Move", color: .red) {
                coordinator.pop()
            }
        }
        .padding()
        .navigationTitle("회원가입")
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
