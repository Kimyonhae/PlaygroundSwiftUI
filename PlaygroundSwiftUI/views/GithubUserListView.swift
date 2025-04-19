//
//  GithubUserListView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import SwiftUI


struct GithubUserListView: View {
    @StateObject private var viewModel: GithubListViewModel = .init()
    @State private var searchText: String = ""
    var body: some View {
        List {
            githubRow
        }
        .searchable(text: $searchText, prompt: "GitHub 사용자 검색")
        .navigationTitle("깃헙 사용자 검색")

    }
    
    // MARK: 깃헙 사용자 목록 Cell
    private var githubRow: some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.largeTitle)
            Text("123")
                .font(.title2).bold()
        }
        .padding(.vertical)
    }
}

#Preview {
    NavigationStack {
        GithubUserListView()
    }
}
