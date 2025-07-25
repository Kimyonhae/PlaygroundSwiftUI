//
//  KaKaoViewModel.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/24/25.
//

import Foundation
import KakaoSDKUser
import NidThirdPartyLogin

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
        private func innerHavingKaKaoAppLogin() async -> Bool {
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
        private func webviewKaKaoLogin() async -> Bool {
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
        private func logoutKaKao() async -> Bool {
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
