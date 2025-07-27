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
    
    @State private var generalSelectDay: Date? = nil
    @State private var connectDates: (start: Date, end: Date)? = nil
    @State private var connectFirstDayTaped: Date? = nil
    @State private var multipleDates: [Date]? = nil
    @State private var selectSection: SectionType = .general
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var body: some View {
        VStack {
            Picker("", selection: $selectSection) {
                ForEach(SectionType.allCases, id: \.self) { section in
                    Text(section.displayName).tag(section)
                }
            }
            .pickerStyle(.segmented)
            headerView
            middleDays
            daysView
        }
        .padding()
        .onChange(of: selectSection) {
            switch selectSection {
                case .general:
                    connectDates = nil
                    multipleDates = nil
                    connectFirstDayTaped = nil
                case .connect:
                    generalSelectDay = nil
                    multipleDates = nil
                case .multiple:
                    generalSelectDay = nil
                    connectDates = nil
                    connectFirstDayTaped = nil
            }
        }
    }
    
    // TODO: 상단 현재 year, month 및 색상 뷰
    private var headerView: some View {
        HStack {
            Group {
                Button("", systemImage: "arrowshape.left.fill") {
                    if let prev = Calendar.current.date(byAdding: .month, value: -1, to: date) {
                        withAnimation(.smooth) { 
                            date = prev
                        }
                    }
                }
                Text(getDayOfWeek(date))
                Button("", systemImage: "arrowshape.right.fill") {
                    if let next = Calendar.current.date(byAdding: .month, value: 1, to: date) {
                        withAnimation(.smooth) {
                            date = next
                        }
                    }
                }
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
                    .foregroundStyle(color)
            }
        }
    }
    
    // TODO: 날짜 뷰
    private var daysView: some View {
        LazyVGrid(columns: columns) {
            ForEach(generateDaysInMonth(from: date)) { cell in
                switch selectSection {
                case .general:
                    generalDayCell(cell)
                case .connect:
                    connectDayCell(cell)
                case .multiple:
                    multipleDayCell(cell)
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

// DataStruct Define
extension CalenderView {
    enum SectionType: Equatable {
        case general
        case connect
        case multiple


        var displayName: String {
            switch self {
            case .general: return "일반"
            case .connect: return "연속 선택"
            case .multiple: return "다수 선택"
            }
        }

        static var allCases: [SectionType] {
            [
                .general,
                .connect,
                .multiple
            ]
        }
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
    
    // TODO: 일반 뷰빌더 로직
    @ViewBuilder
    private func generalDayCell(_ cell: DayCell) -> some View {
        if let date = cell.date {
            Text("\(Calendar.current.component(.day, from: date))")
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(generalSelectDay == date ? .red : color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                .id(cell.id)
                .onTapGesture {
                    generalSelectDay = date
                }
        } else {
            Text("")
        }
    }
    
    // TODO: 연속 선택 뷰빌더 로직
    @ViewBuilder
    private func connectDayCell(_ cell: DayCell) -> some View {
        if let date = cell.date {
            
            let isSelected: Bool = {
                guard let range = connectDates else { return false }
                return date >= range.start && date <= range.end
            }()
            
            let isFirst = date == connectFirstDayTaped
            Text("\(Calendar.current.component(.day, from: date))")
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(isSelected || isFirst ? .red :  color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                .id(cell.id)
                .onTapGesture {
                    if let firstDate = connectFirstDayTaped {
                        connectDates = (firstDate, date)
                        connectFirstDayTaped = nil
                    }else {
                        connectFirstDayTaped = date
                        connectDates = nil
                    }
                }
        } else {
            Text("")
        }
    }
    
    // TODO: 불연속 뷰빌더 로직
    @ViewBuilder
    private func multipleDayCell(_ cell: DayCell) -> some View {
        if let date = cell.date {
            let isSelected: Bool = {
                guard let dates = multipleDates else { return false }
                return dates.contains(date)
            }()
            
            Text("\(Calendar.current.component(.day, from: date))")
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(isSelected ? .red : color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                .id(cell.id)
                .onTapGesture {
                    if isSelected {
                        multipleDates?.removeAll { $0 == date }
                    } else {
                        if multipleDates == nil {
                            multipleDates = [date]
                        } else {
                            multipleDates?.append(date)
                        }
                    }
                }
        } else {
            Text("")
        }
    }
}
