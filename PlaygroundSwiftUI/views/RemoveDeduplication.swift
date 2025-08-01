//
//  RemoveDeduplication.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 8/1/25.
//

import SwiftUI

struct RemoveDeduplication: View {
    @State private var isPresented: Bool? = nil
    @State private var size: CGSize = .zero
    var body: some View {
        VStack {
            Button("sheet 올리기") {
                isPresented = false
            }
            HStack {
                Text("크기 측정")
                    .readSize { size = $0 }
                    
            }
            Text("부모가 자식의 크기를 알아내는 방법 : \(size)")
        }
        .sheet(isPresented: $isPresented.presence()) {
            Text("hello Sheet")
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(completion: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: completion)
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
