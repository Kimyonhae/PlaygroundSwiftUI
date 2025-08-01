//
//  RemoveDeduplication.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 8/1/25.
//

import SwiftUI

struct RemoveDeduplication: View {
    @State private var isPresented: Bool? = nil
    var body: some View {
        VStack {
            Button("sheet 올리기") {
                isPresented = false
            }
        }
        .sheet(isPresented: $isPresented.presence()) {
            Text("hello Sheet")
        }
    }
}

extension Binding {
    func presence<T>() -> Binding<Bool> where Value == Optional<T> {
        return .init(get: {
            self.wrappedValue != nil
        }, set: { newValue in
            precondition(newValue == false)
            self.wrappedValue = nil
        })
    }
}


#Preview {
    RemoveDeduplication()
}
