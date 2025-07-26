//
//  SocialLoginView+AppleAuthViewModel.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/26/25.
//

import SwiftUI
import AuthenticationServices

struct OAuthUserData {
    var oauthId: String = ""
    var idToken: String = ""
}

extension SocialLoginView {
    class AppleAuthViewModel: NSObject ,ObservableObject ,AppleLoginService {
        @Published var givenName: String = ""
        @Published var errorMessage: String = ""
        @Published var oauthUserData = OAuthUserData()
        
        func login() async {
            await withCheckedContinuation { continuation in
                let appleIdProvider = ASAuthorizationAppleIDProvider()
                let req = appleIdProvider.createRequest()
                req.requestedScopes = [.fullName, .email]
                
                let authController = ASAuthorizationController(authorizationRequests: [req])
                authController.delegate = self
                authController.presentationContextProvider = self
                authController.performRequests()
                
                continuation.resume()
            }
        }
        
        func logout() async {
            print("logout~")
        }
    }
}

extension SocialLoginView.AppleAuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let idToken = appleIDCredential.identityToken!

                oauthUserData.oauthId = userIdentifier
                oauthUserData.idToken = String(data: idToken, encoding: .utf8) ?? ""

                if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
                    self.givenName = "\(givenName) \(familyName)"
                }
            default:
                break
            }
        }
    
        func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else {
                    fatalError("No window found")
            }
            return window
        }

        func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
            errorMessage = "Authorization failed: \(error.localizedDescription)"
        }
}
