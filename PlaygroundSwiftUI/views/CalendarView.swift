//
//  CalendarView.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/26/25.
//

import SwiftUI

struct DayCell: Identifiable {
    let id: UUID
    let date: Date?
    
    init(id: UUID = UUID(), date: Date? = nil) {
        self.id = id
        self.date = date
    }
}

struct CalenderView: View {
    @State private var date = Date.now
    @State private var color: Color = .blue
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var body: some View {
        VStack {
            headerView
            middleDays
            daysView
        }
        .padding()
    }
    
    // TODO: 상단 현재 year, month 및 색상 뷰
    private var headerView: some View {
        HStack {
            Group {
                Button("", systemImage: "arrowshape.left.fill"){}
                Text(getDayOfWeek(date))
                Button("", systemImage: "arrowshape.right.fill"){}
            }
            .font(.title)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Spacer()
            
            ColorPicker("", selection: $color)
        }
    }
    
    // TODO: 월 화 수 목 금 토 일
    private var middleDays: some View {
        LazyVGrid(columns: columns) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .padding()
            }
        }
    }
    
    // TODO: 날짜 뷰
    private var daysView: some View {
        LazyVGrid(columns: columns) {
            ForEach(generateDaysInMonth(from: date)) { cell in
                if let date = cell.date {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(color)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                        .id(cell.id)
                } else {
                    Text("")
                }
            }
        }
    }
}

extension CalenderView {
    var weekdays: [String] {
        ["일", "월", "화", "수", "목", "금", "토"]
    }
}


extension CalenderView {
    private func getDayOfWeek(_ date: Date) -> String {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        return "\(year)년 \(month)월"
    }
    
    private func generateDaysInMonth(from date: Date) -> [DayCell] {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        guard let monthRange = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
                  return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        var days: [DayCell] = (0..<(firstWeekday - 1)).map { _ in DayCell(id: UUID(), date: nil) }
        
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(DayCell(id: UUID() ,date: date))
            }
        }
        
        return days
    }
}
#Preview {
    CalenderView()
}
