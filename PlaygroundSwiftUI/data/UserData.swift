//
//  UserData.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//

import Combine
import SwiftUI

private let defaultCurrencies: [Currency] = [
    Currency(name: "KR 원", rate: 1.0, symbol: "KR", code: "원"),
    Currency(name: "US dollar", rate: 1.0, symbol: "US", code: "USD"),
    Currency(name: "Canadian dollar", rate: 1.0, symbol: "CA", code: "CAD")
]

@propertyWrapper
struct UserDefaultValue<Value: Codable> {
    var wrappedValue: Value
    let key: String
    
    var value: Value {
        get {
            let data = UserDefaults.standard.data(forKey: key)
            let value = data.flatMap {
                try? JSONDecoder().decode(Value.self, from: $0)}
            return value ?? wrappedValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

final class UserData: ObservableObject {
    let didChange = PassthroughSubject<UserData, Never>()
    
    @UserDefaultValue(wrappedValue: defaultCurrencies, key: "allCurrencies")
    var allCurrencies: [Currency] {
        didSet {
            didChange.send(self)
        }
    }
    
    @UserDefaultValue(wrappedValue: defaultCurrencies[0], key: "baseCurrency")
    var baseCurrency: Currency {
        didSet {
            didChange.send(self)
        }
    }
    
    @UserDefaultValue(wrappedValue: defaultCurrencies, key: "userCurrency")
    var userCurrency: [Currency] {
        didSet {
            didChange.send(self)
        }
    }
}
