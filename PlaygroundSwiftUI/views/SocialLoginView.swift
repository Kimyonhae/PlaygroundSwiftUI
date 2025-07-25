//
//  SocialLoginView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/23/25.
//

import SwiftUI
import KakaoSDKAuth
import NidThirdPartyLogin

struct SocialLoginView: View {
    @StateObject var km: SocialLoginView.KaKaoAuthViewModel = .init()
    @StateObject var nm: SocialLoginView.NaverAuthViewModel = .init()
    
    var body: some View {
        if AuthApi.hasToken() {
            if km.isKaKaoLogin {
                loginSuccess("카카오톡 로그 아웃") {
                    Task {
                        await km.logout()
                    }
                }
            }
        } else if nm.isNaverLogin {
            loginSuccess("네이버 로그 아웃") {
                Task {
                    await nm.logout()
                }
            }
        } else {
            VStack {
                Text("로그인")
                    .font(.title)
                
                loginButton("카카오 로그인", color: .yellow) {
                    Task {
                        await km.login()
                    }
                }
                
                loginButton("네이버 로그인", color: .green) {
                    print("네이버 로그인")
                    Task {
                        await nm.login()
                    }
                }
                
                loginButton("구글 로그인", color: .gray) {
                    print("구글 로그인")
                }
                
                loginButton("애플 로그인", color: .black) {
                    print("애플 로그인")
                }
            }
            .padding()
        }
    }
    
    // TODO: 로그인 성공 뷰
    private func loginSuccess(_ text: String, action: @escaping() -> Void) -> some View {
        VStack {
            Text("로그인 성공~")
            Button(text) {
                action()
            }
        }
    }
    
    // TODO: 로그인 버튼
    private func loginButton(_ title: String,color: Color,action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(color)
                .foregroundColor(.white)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}
