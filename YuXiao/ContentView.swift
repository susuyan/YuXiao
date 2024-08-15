//
//  ContentView.swift
//  YuXiao
//
//  Created by 苏苏炎 on 2024/8/15.
//

import SwiftUI
import HorizonCalendar

struct ContentView: View {
    @State var selectedDate: Date? = Date() // 默认选择今天
    @State var selectedShift: (name: String, time: String)? = nil
    
    var body: some View {
        NavigationSplitView{
            VStack(alignment: .leading) {
                if let selectedDate = selectedDate, let selectedShift = selectedShift {
                    VStack(alignment: .leading, content: {
                        Text("今日 \(formattedDate(selectedDate))")
                            .font(.headline)
                        Text("\(selectedShift.name) (\(selectedShift.time))")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    })
                    
                }
                
                let calendar = Calendar.current
                
                let startDate = calendar.date(from: DateComponents(year: 2024, month: 8, day: 1))!
                let endDate = calendar.date(from: DateComponents(year: 2024, month: 12, day: 31))!
                
                CalendarViewRepresentable(
                    calendar: calendar,
                    visibleDateRange: startDate...endDate,
                    monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
                    dataDependency: nil
                )
                .monthHeaders({ month in
                    let chineseMonths = [
                        1: "一月",
                        2: "二月",
                        3: "三月",
                        4: "四月",
                        5: "五月",
                        6: "六月",
                        7: "七月",
                        8: "八月",
                        9: "九月",
                        10: "十月",
                        11: "十一月",
                        12: "十二月"
                    ]
                    
                    Text("\(chineseMonths[month.month] ?? "")")
                        .font(.title)                                        
                    
                })
                .days { [selectedDate] day in
                    let date = calendar.date(from: day.components)
                    let borderColor: UIColor = date == selectedDate ? .systemRed : .systemBlue
                    
                    VStack {
                        HStack {
                            Text("\(day.day)")
                                .font(.system(size: 18))
                        }
                        
                        // 班次规则
                        let shiftTypes: [(name: String, color: Color, time: String)] = [
                            ("下夜", Color.blue.opacity(0.2),"休息"),
                            ("白班", Color.green.opacity(0.2),"08:00 - 16:00"),
                            ("中班", Color.orange.opacity(0.2),"16:00 - 23:00"),
                            ("夜班", Color.purple.opacity(0.2),"12:00 - 次日 08:00")
                        ]
                        
                        // 计算当前日期与每月1号的距离
                        let dayOffset = day.day - 1
                        
                        // 根据距离得出对应的班次
                        let shift = shiftTypes[dayOffset % shiftTypes.count]
                        
                        // 显示班次
                        Text(shift.name)
                            .background(shift.color)
                            .cornerRadius(4)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(borderColor), lineWidth: 1)
                            }
                            .font(.system(size: 14))
                    }
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .interMonthSpacing(24)
                .verticalDayMargin(8)
                .horizontalDayMargin(8)
                .onDaySelection { day in
                    let selectedDate = calendar.date(from: day.components)
                    self.selectedDate = selectedDate
                    
                    // 根据选中日期计算班次
                    if let date = selectedDate {
                        let dayComponent = calendar.component(.day, from: date)
                        let shiftTypes = [
                            ("下夜", "休息"),
                            ("白班", "08:00 - 16:00"),
                            ("中班", "16:00 - 23:00"),
                            ("夜班", "12:00 - 次日 08:00")
                        ]
                        let dayOffset = dayComponent - 1
                        self.selectedShift = shiftTypes[dayOffset % shiftTypes.count]
                    }
                }
                .onAppear {
                    // 初始化时设置当前日期的班次
                    if let today = selectedDate {
                        let dayComponent = calendar.component(.day, from: today)
                        let shiftTypes = [
                            ("下夜", "休息"),
                            ("白班", "08:00 - 16:00"),
                            ("中班", "16:00 - 23:00"),
                            ("夜班", "12:00 - 次日 08:00")
                        ]
                        let dayOffset = dayComponent - 1
                        self.selectedShift = shiftTypes[dayOffset % shiftTypes.count]
                    }
                }
            }
            .navigationTitle("Her Time")
            .padding()
        } detail: {
            
        }
        
        
        
    }
    
    // 格式化日期
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd (EEEE)"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
