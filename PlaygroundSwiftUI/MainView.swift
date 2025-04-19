//
//  MainView.swift
//  SwiftPlayground
//
//  Created by 김용해 on 4/17/25.
//

import SwiftUI

struct ConnectionView: Identifiable {
    let id: UUID = UUID()
    let title: String
    let destination: AnyView
    
    init<T: View>(title: String, destination: T) {
        self.title = title
        self.destination = AnyView(destination)
    }
}

let routes: [ConnectionView] = [
    ConnectionView(title: "Chart Playground", destination: ChartView(title: "Chart Playground")),
    ConnectionView(title: "DarkMode Playground", destination: DarkModeView()),
    ConnectionView(title: "Localtion Playground", destination: LocationView())
]

struct MainView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(routes) { route in
                    NavigationLink(destination: route.destination) {
                        Text(route.title)
                    }
                }
            }
        }
        .navigationTitle("Swift Playground")
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
