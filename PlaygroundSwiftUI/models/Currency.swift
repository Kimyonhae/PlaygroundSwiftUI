//
//  Currency.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import Foundation


struct Currency: Equatable, Codable, Identifiable {
    let id: UUID
    let name: String
    let rate: Double
    let symbol: String
    let code: String
    
    init(name: String, rate: Double, symbol: String = "", code: String) {
        self.id = UUID()
        self.name = name
        self.rate = rate
        self.symbol = symbol
        self.code = code
    }
    
    var flag: String {
        if self.symbol == "kr" { return "🇰🇷"}
        let base: UInt32 = 127397
        var s = ""
        for v in self.symbol.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return s
    }
}
