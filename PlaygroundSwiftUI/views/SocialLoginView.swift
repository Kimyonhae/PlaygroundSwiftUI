//
//  SocialLoginView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/23/25.
//

import SwiftUI
import KakaoSDKUser
import KakaoSDKAuth

struct SocialLoginView: View {
    @StateObject var vm: SocialLoginView.KaKaoAuthViewModel = .init()
    
    var body: some View {
        if AuthApi.hasToken() && vm.isKaKaoLogin {
            VStack {
                Text("로그인 성공~")
                Button("카카오톡 로그 아웃") {
                    Task {
                        await vm.logout()
                    }
                }
            }
            .onAppear {
                print("현재 상태 : \(AuthApi.hasToken()) , isKaKaoLogin : \(vm.isKaKaoLogin)")
            }
        } else {
            VStack {
                Text("로그인")
                    .font(.title)
                
                Button(action: {
                    Task {
                        await vm.login() // logout() -> login()으로 변경하고 Task로 감쌈
                    }
                }) {
                    Text("카카오 로그인")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(.yellow)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                
                Button(action: {
                    print("네이버")
                }) {
                    Text("네이버 로그인")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(.green)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                
                Button(action: {
                    print("구글")
                }) {
                    Text("구글 로그인")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(.gray)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                
                Button(action: {
                    print("애플")
                }) {
                    Text("애플 로그인")
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
            }
            .padding()
            .onAppear {
                print("현재 상태 : \(AuthApi.hasToken()) , isKaKaoLogin : \(vm.isKaKaoLogin)")
            }
        }
    }
}

protocol LoginService {
    func login() async
    func logout() async
}

protocol KaKaoLoginService: LoginService {
    func innerHavingKaKaoAppLogin() async -> Bool
    func webviewKaKaoLogin() async -> Bool
    func logoutKaKao() async -> Bool
}
protocol NaverLoginService: LoginService {}
protocol AppleLoginService: LoginService {}
protocol GoogleLoginService: LoginService {}

// viewModel
extension SocialLoginView {
    
    @MainActor
    class KaKaoAuthViewModel: ObservableObject, KaKaoLoginService {
        @Published var isKaKaoLogin: Bool = false
        
        // TODO: KAKAO LOGIN
        func login() async {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                self.isKaKaoLogin = await innerHavingKaKaoAppLogin()
            } else {
                self.isKaKaoLogin = await webviewKaKaoLogin()
            }
        }
        
        // TODO: 카카오 로그 아웃
        func logout() async {
            let success = await logoutKaKao()
            if success {
                self.isKaKaoLogin = false
            }
        }
        
        // TODO: 카카오앱이 설치 되어 있을 경우
        internal func innerHavingKaKaoAppLogin() async -> Bool {
            await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    if let error = error {
                        print("KakaoTalk login error: \(error)")
                        continuation.resume(returning: false)
                    } else {
                        print("loginWithKakaoTalk() success.")
                        // 성공 시 동작 구현
                        _ = oauthToken
                        continuation.resume(returning: true)
                    }
                }
            }
        }
        
        // TODO: 웹뷰로 카카오 로그인
        internal func webviewKaKaoLogin() async -> Bool {
            await withCheckedContinuation { continuation in
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        print("KakaoAccount login error: \(error)")
                        continuation.resume(returning: false)
                    } else {
                        print("loginWithKakaoAccount() success.")
                        // 성공 시 동작 구현
                        _ = oauthToken
                        continuation.resume(returning: true)
                    }
                }
            }
        }
        
        // TODO: 로그아웃 내부 수행 로직
        internal func logoutKaKao() async -> Bool {
            await withCheckedContinuation { continuation in
                UserApi.shared.logout { error in
                    if let error = error {
                        print("Logout error: \(error)")
                        continuation.resume(returning: false) // 에러 시 false 반환
                    } else {
                        print("logout() success.")
                        continuation.resume(returning: true)
                    }
                }
            }
        }
    }
}
