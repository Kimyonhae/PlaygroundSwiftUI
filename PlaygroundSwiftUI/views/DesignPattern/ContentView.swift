//
//  ContentView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/19/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        Text("hello My Name is \(viewModel.profile?.name ?? "loading...")")
            .task {
                await viewModel.getName()
            }
    }
}

#Preview {
    ContentView()
}
