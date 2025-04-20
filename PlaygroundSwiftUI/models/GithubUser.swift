//
//  GithubUser.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import Foundation

// TODO: Github에게 가져올 API 내용 모델링
struct SearchResponse: Codable {
    let total_count: Int
    var items: [GithubUser]
}


struct GithubUser: Codable, Identifiable {
    let id: UInt32
    let username: String
    let avatarUrl: String
    
    enum CodingKeys: String ,CodingKey {
        case id
        case username = "login"
        case avatarUrl = "avatar_url"
    }
}
