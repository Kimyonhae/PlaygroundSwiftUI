//
//  ContentView.swift
//  CombineCharts
//
//  Created by 김용해 on 4/17/25.
//

import SwiftUI
import Charts

// 차트 모델
struct ChartData: Identifiable {
    let id: UUID = UUID()
    let x: Double
    let y: Double
}

// 다양한 TextField의 모델
struct InputCoordinatePair: Identifiable {
    let id = UUID()
    var x: String = ""
    var y: String = ""
}

struct ChartView: View {
    let title: String
    @State private var inputPairs: [InputCoordinatePair] = [InputCoordinatePair()]
    @State private var inputX: String = ""
    @State private var inputY: String = ""
    var chartData: [ChartData] {
            inputPairs.compactMap { pair in
                guard let xValue = Double(pair.x), let yValue = Double(pair.y) else {
                    return nil
                }
                return ChartData(x: xValue, y: yValue)
            }
        }
    
    var body: some View {
        VStack {
            inputsForm
            if chartData.isEmpty {
                Text("입력값을 넣어주세요")
                    .font(.title2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else {
                Chart(chartData){ data in
                    BarMark(
                        x: .value("\(data.x)", data.x),
                        y: .value("\(data.y)", data.y)
                    )
                }
            }
        }
        .padding()
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus", action: {
                    inputPairs.append(InputCoordinatePair())
                })
            }
        }
    }
    
    
    // MARK: 입력 창을 분리
    private var inputsForm: some View {
        ScrollView {
            ForEach ($inputPairs) { $pair in
                HStack {
                    TextField("X", text: $pair.x)
                        .keyboardType(.asciiCapableNumberPad)
                        .padding()
                        .border(.blue, width: 1)
                    TextField("Y", text: $pair.y)
                        .keyboardType(.asciiCapableNumberPad)
                        .padding()
                        .border(.blue, width: 1)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        ChartView(title: "Chart Playground")
    }
}
