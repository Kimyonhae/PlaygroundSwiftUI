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
    @StateObject var vm: SocialLoginView.ViewModel = .init()
    
    var body: some View {
        if AuthApi.hasToken() && vm.isKaKaoLogin {
            VStack {
                Text("로그인 성공~")
                Button("카카오톡 로그 아웃") {
                    vm.logoutKaKao()
                }
            }
        }else {
            VStack {
                Text("로그인")
                    .font(.title)
                
                Button(action: {
                    // 카카오톡 실행 가능 여부 확인
                    vm.loginKaKao()
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
                print("token의 상태 : \(AuthApi.hasToken())")
            }
        }
    }
}


extension SocialLoginView {
    class ViewModel: ObservableObject {
        @Published var isKaKaoLogin: Bool = false
            
        
        // TODO: KAKAO LOGIN
        func loginKaKao() {
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoTalk() success.")
                        
                        // 성공 시 동작 구현
                        self.isKaKaoLogin = true
                    }
                }
            }else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        // 성공 시 동작 구현
                        self.isKaKaoLogin = true
                    }
                }
            }
        }
        
        // TODO: 카카오 로그 아웃
        func logoutKaKao() {
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                }
            }
            self.isKaKaoLogin = false
        }
    }
}
