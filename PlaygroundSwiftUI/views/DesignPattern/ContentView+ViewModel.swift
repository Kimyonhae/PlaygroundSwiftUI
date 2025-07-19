//
//  ContentView+Observed.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/19/25.
//

import SwiftUI

extension ContentView {
    
    @MainActor
    class ViewModel: ObservableObject {
        @Published var profile: Profile? = nil
        var service = ViewModelService()
        func getName() async {
            self.profile = await service.fetchProfile(of: "Kim yong hae")
        }
    }
    
    actor ViewModelService {
        func fetchProfile(of name : String) async -> Profile {
            let profile = Profile(name: name)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return profile
        }
    }
}

/// 1. ViewModel을 사용할 뷰와 직접적으로 확장을 통해 연결해주면 다른 뷰의 사용을 방지 할 수 있음
/// 2. 예전의 GCD를 Swift Concurrency로 내부 비동기 함수를 actor로 감싸고 뷰와 관련된 class를 MainActor로 넣어줌
