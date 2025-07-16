//
//  Coordinator.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/16/25.
//

import SwiftUI

enum Page: String, Identifiable {
    case main
    case login
    case register
    case loginSuccess

    var id: String {
        self.rawValue
    }
}


enum Sheet: String, Identifiable {
    case logout
    
    var id: String {
        self.rawValue
    }
}

enum FullSheetCover: String, Identifiable {
    case profile
    
    var id: String {
        self.rawValue
    }
}


class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullSheetCover: FullSheetCover?
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func present(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(_ fullSheetCover: FullSheetCover) {
        self.fullSheetCover = fullSheetCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func allPop() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullSheetCover() {
        self.fullSheetCover = nil
    }
}

extension Coordinator {
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
            case .main:
                MainView()
            case .login:
                LoginPage()
            case .register:
                RegisterPage()
            case .loginSuccess:
                CustomTabView()
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
            case .logout:
                LogOutPage()
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullSheetCover) -> some View {
        switch fullScreenCover {
            case .profile:
                ProfilePage()
        }
    }
}
