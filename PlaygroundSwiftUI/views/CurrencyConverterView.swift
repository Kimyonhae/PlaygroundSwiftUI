//
//  CurrencyConverterView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 4/19/25.
//
import Foundation
import SwiftUI

struct CurrencyConverterView: View {
    @EnvironmentObject var userData: UserData
    @State private var baseAmonut: String = "1.0"
    @State private var isEditing: Bool = false
    @State private var lastUpdated: String = ""
    var body: some View {
        let doubleValue: Double = Double($baseAmonut.wrappedValue) ?? 1.0
        
        return ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                Text("From:").bold().foregroundStyle(.gray)
                HStack {
                    Text("\(userData.baseCurrency.flag)").padding(5)
                    VStack(alignment: .leading) {
                        Text("\(userData.baseCurrency.code)").foregroundStyle(.white)
                        Text("\(userData.baseCurrency.name)").foregroundStyle(.white)
                    }
                    Spacer()
                    TextField("1.0", text: $baseAmonut).foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill()
                                .border(Color(red: 0.7, green: 0.7, blue: 0.7), width: 1)
                                .padding()
                        )
                }
                .padding()
                .background(.blue).clipShape(RoundedRectangle(cornerRadius: 5))
                Text("To:").bold().foregroundStyle(.gray)
                List {
                    ForEach(userData.userCurrency) { currency in
                        CurrencyItemView(currency: currency, baseAmount: doubleValue, isEditing: $isEditing)
                            .onTapGesture {
                                userData.baseCurrency = currency
                            }
                    }
//                    .onAppear(perform: loadCurrencies)
                    .navigationBarItems(trailing: Button(action: { self.isEditing.toggle() }) {
                            if !self.isEditing {
                                Text("Edit")
                            } else {
                                Text("Done").bold()
                            }
                    })
                    Text("Last Updated: \(lastUpdated)").bold().foregroundStyle(.gray)
                }
                .navigationTitle("한율 계산기")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .padding()
    }
    
    // API 통신
    private func loadCurrencies() {
        let url = URL(string: "https://api.currencyfreaks.com/v2.0/rates/latest?base=USD&symbols=pkr,usd,cad,eur&apikey=apikey")!
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, res, error in
            
            if let data = data {
                if let decoded: CurrencyList = self.decodeData(CurrencyList.self, data) {
                    self.lastUpdated = decoded.date
                    
                    // generate currency data
                    var newCurrencies = [Currency]()
                    for key in decoded.rates.keys {
                        let newCurrency = Currency(name: CurrencyList.getSupportedCurrencies[key]?[0] ?? "Unknown", rate: 1.0 / (decoded.rates[key] ?? 1.0), symbol: CurrencyList.getSupportedCurrencies[key]?[1] ?? "", code: key)
                        newCurrencies.append(newCurrency)
                    }
                    
                    DispatchQueue.main.async {
                        self.userData.allCurrencies = newCurrencies
                        
                        if let base = self.userData.allCurrencies.filter({ $0.symbol == self.userData.baseCurrency.symbol }).first {
                            self.userData.baseCurrency = base
                        }
                        
                        var tempNewUserCurrency = [Currency]()
                        let userCurrencies = self.userData.userCurrency.map{ $0.code }
                        for c in self.userData.allCurrencies {
                            if userCurrencies.contains(c.code){
                                tempNewUserCurrency.append(c)
                            }
                        }
                        
                        self.userData.userCurrency = tempNewUserCurrency
                    }
                }
            }
        })
        task.resume()
    }
}

#Preview {
    NavigationStack {
        CurrencyConverterView()
            .environmentObject(UserData())
    }
}

private extension CurrencyConverterView {
    func decodeData<T>(_ decodeObject: T.Type, _ data: Data) -> T? where T: Codable {
        let decoder = JSONDecoder()
        do
        {
            return try decoder.decode(decodeObject.self, from: data)
        }
        catch let jsonErr
        {
            print("Error decoding Json ", jsonErr)
            return nil
        }
    }
}

struct CurrencyItemView: View {
    @EnvironmentObject var userData: UserData
    let currency: Currency
    let baseAmount: Double
    @Binding var isEditing: Bool
    
    var body: some View {
        let currency = self.currency
        let converstionRate = String(format: "%.4f", currency.rate / userData.baseCurrency.rate)
        let totalAmount = String(format: "%.3f", baseAmount * ( userData.baseCurrency.rate / currency.rate))
        
        return HStack {
            if isEditing {
                // This is for delete mode
                HStack(alignment: .center){
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                        .onTapGesture {
                            print("삭제가 있음")
                        }
                }
                
                Text(currency.flag).font(.title)
                VStack(alignment: .leading){
                    Text("\(currency.code)")
                    Text("\(currency.name)").foregroundStyle(.gray)
                }
            }
            else {
                // This is normal mode
                HStack{
                    // Flag
                    Text(currency.flag).font(.largeTitle)
                    // Code and name
                    VStack(alignment: .leading){
                        Text("\(currency.code)").font(.headline)
                        Text("\(currency.name)").font(.footnote).foregroundStyle(.gray)
                    }
                    Spacer()
                    // Amount and conversion
                    VStack(alignment: .trailing){
                        Text("\(totalAmount)")
                        // Would be 1 this currency = xxx base currency
                        Text("1 \(currency.code) = \(converstionRate) \(userData.baseCurrency.code)").foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}
