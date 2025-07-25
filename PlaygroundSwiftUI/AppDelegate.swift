//
//  AppDelegate.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/25/25.
//

import UIKit
import NidThirdPartyLogin

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NidOAuth.shared.initialize()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      if (NidOAuth.shared.handleURL(url) == true) { // 네이버앱에서 전달된 Url인 경우
        return true
      }
      
      return false
    }
}
