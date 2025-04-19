//
//  GithubListViewModel.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//

import Combine

class GithubListViewModel: ObservableObject {
    @Published var users: [GithubUser] = []
    
    func fetchGithubUsers() {
        
    }
}
