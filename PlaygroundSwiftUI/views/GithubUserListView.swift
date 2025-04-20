//
//  GithubUserListView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import SwiftUI


struct GithubUserListView: View {
    @StateObject private var viewModel: GithubListViewModel = .init()
    var body: some View {
        ZStack {
            if viewModel.users.isEmpty {
                Text("검색 해볼까요 ✅")
                    .font(.title2).bold()
            }else {
                List {
                    ForEach(viewModel.users) { user in
                        githubRow(user: user)
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "GitHub 사용자 검색")
        .navigationTitle("깃헙 사용자 검색")
    }
    
    // MARK: 깃헙 사용자 목록 Cell
    private func githubRow(user: GithubUser) -> some View {
        HStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle.fill") // Placeholder 이미지
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            }
                
            Text(user.username)
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
