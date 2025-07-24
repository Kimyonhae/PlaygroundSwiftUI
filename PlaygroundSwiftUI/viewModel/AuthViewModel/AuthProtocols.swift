//
//  AuthProtocols.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/24/25.
//

protocol LoginService {
    func login() async
    func logout() async
}

protocol KaKaoLoginService: LoginService {}
protocol NaverLoginService: LoginService {}
protocol AppleLoginService: LoginService {}
protocol GoogleLoginService: LoginService {}
