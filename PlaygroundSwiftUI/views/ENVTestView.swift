//
//  ENVTestView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import SwiftUI

struct ENVTestView: View {
    var body: some View {
        VStack {
            Text("EnvFile")
            Text("\(String(describing: Bundle.main.object(forInfoDictionaryKey: "ENVTEST_KEY")!))")
        }
    }
}

#Preview {
    ENVTestView()
}
