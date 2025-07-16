//
//  AuthView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/16/25.
//

import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .main)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullSheetCover) { fullSheetCover in
                    coordinator.build(fullScreenCover: fullSheetCover)
                }
                .navigationTitle(Text("Auth Page"))
        }
        .environmentObject(coordinator)
    }
}
