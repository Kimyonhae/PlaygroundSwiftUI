//
//  ContentView+Observed.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/19/25.
//

import SwiftUI

extension ContentView {
    class Observed: ObservableObject {
        @Published var profile: Profile? = nil
        
        private func getName() {
            let profile = Profile(name: "김용해")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.profile = profile
            }
        }
    }
}
