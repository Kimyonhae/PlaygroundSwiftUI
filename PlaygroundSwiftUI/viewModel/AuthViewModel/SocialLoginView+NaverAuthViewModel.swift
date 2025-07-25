//
//  SocialLoginView+NaverAuthViewModel.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/25/25.
//

import Foundation
import NidThirdPartyLogin

extension SocialLoginView {
    
    @MainActor
    class NaverAuthViewModel: ObservableObject, NaverLoginService {
        let auth = NidOAuth.shared
        @Published var isNaverLogin: Bool = false
        func login() async {
            await withCheckedContinuation { continuation in
                if let accessToken = auth.accessToken,
                     !accessToken.isExpired {
                    print("AccessToken: ", accessToken.tokenString)
                } else {
                  // AccessToken이 없거나 유효하지 않은 경우
                  auth.requestLogin { [weak self] result in
                      switch result {
                        case .success(let loginResult):
                          print("Access Token: ", loginResult.accessToken.tokenString)
                          Task { @MainActor in
                              self?.isNaverLogin = true
                          }
                        case .failure(let error):
                          print("Error: ", error.localizedDescription)
                          Task { @MainActor in
                              self?.isNaverLogin = false
                          }
                        }
                  }
                }
                continuation.resume()
            }
        }
        
        func logout() async {
            await withCheckedContinuation { continuation in
                auth.logout()
                Task { @MainActor in
                    self.isNaverLogin = false
                }
                continuation.resume()
            }
        }
    }
}
