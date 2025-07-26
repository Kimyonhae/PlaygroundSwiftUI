//
//  PlaygroundSwiftUIApp.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/17/25.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon
import NidThirdPartyLogin

@main
struct PlayGroundSwiftUI: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let kakao_apiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String ?? ""
        KakaoSDK.initSDK(appKey: kakao_apiKey)
    }
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .onOpenURL(perform: { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}

