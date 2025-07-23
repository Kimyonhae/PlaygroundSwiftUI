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
    ConnectionView(title: "Localtion Playground", destination: LocationView()),
    ConnectionView(title: "ENVTest Playground", destination: ENVTestView()),
    ConnectionView(title: "AnimatedList Playground", destination: AnimatedList()),
    ConnectionView(title: "LandMarks Playground", destination: LandMarks()),
    ConnectionView(title: "GithubUserListView Playground", destination: GithubUserListView()),
    ConnectionView(title: "Subscriber Playground", destination: SubscriberView(title: "구독 연습")),
    ConnectionView(title: "뷰 - 뷰모델의 새로운 발견", destination: ContentView()),
    ConnectionView(title: "소셜 로그인", destination: SocialLoginView())
]

struct MainView: View {
    @EnvironmentObject var coordinator: Coordinator
    var body: some View {
        List {
            ForEach(routes) { route in
                NavigationLink(destination: route.destination) {
                    Text(route.title)
                }
            }
            Text("Auth in Coordinator Playground")
                .onTapGesture {
                    coordinator.push(.login)
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

/// ** 회고 **
/// Coordinator 패턴적용은 앱 시작부분에서 하는게 정석인거 같다.
/// 기존 뷰 로직을 바꾸지 않고 할려면  Coordinator ->( 기존 Main 뷰 , 새로 추가한 Page)
/// 결론은 하나의 줄기에서 시작해야 하고 Coordinator 사용할려면 중간에 분기가 나눠지면 안됌.
///
