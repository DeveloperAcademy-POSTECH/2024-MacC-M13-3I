//
//  ContentView.swift
//  test
//
//  Created by GREEN on 2023/06/27.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var shoppingViewModel: ShoppingViewModel
    @ObservedObject var listViewModel: ListViewModel
    @State private var month: Date = Date()
    @State private var clickedCurrentMonthDates: Date?
    @State var showSheet: Bool = false
    @State var isShopping: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("CalendarBackground")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    yearMonthView
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    VStack{
                        weekdayView
                        Divider()
                        calendarGridView
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 8)
                    .background(Color.pWhite.cornerRadius(12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pGray, lineWidth: 2)
                    )
                    .padding(.bottom, 68)
                    
                    if !isShopping {
                        Text("저장된 영수증이 없어요")
                            .font(.PTitle3)
                            .foregroundColor(.pDarkGray)
                        
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.pBlue)
                    }
                }
                ToolbarItem(placement: .principal){
                    Text("달력")
                        .font(.PTitle2)
                        .foregroundColor(.pWhite)
                }
            }
            .sheet(isPresented: $showSheet) {
                ReceiptView(shoppingViewModel: shoppingViewModel, listViewModel: listViewModel, isButton: .constant(false))
                    .presentationDetents([.height(130), .height(540)])
            }
            .onAppear {
                let dateToCheck = clickedCurrentMonthDates ?? Date() // 기본값 설정
                let formattedDate = shoppingViewModel.formatDateToDate(from: dateToCheck)
                
                for item in shoppingViewModel.dateItem {
                    let itemDate = shoppingViewModel.formatDateToDate(from: item.date)
                    
                    if itemDate == formattedDate {
                        isShopping = true
                        shoppingViewModel.selectedDateItem = item
                        showSheet.toggle()
                        break
                    }
                    else { 
                        isShopping = false
                    }
                }
            }
        }.navigationBarBackButtonHidden()
    }
    
    
    // MARK: - 연월 표시
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(
                action: {
                    changeMonth(by: -1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(canMoveToPreviousMonth() ? .pWhite : . pGray)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .background(Color("PDarkGray"))
                        .cornerRadius(24)
                    
                }
            )
            .disabled(!canMoveToPreviousMonth())
            Spacer()
            
            VStack(alignment: .center){
                Text(month, formatter: Self.calendarHeaderDateFormatterMonth)
                    .font(.PTitle1)
                    .foregroundColor(.pWhite)
                Text(month, formatter: Self.calendarHeaderDateFormatterYear)
                    .font(.PTitle3)
                    .foregroundColor(.pWhite)
            }
            
            Spacer()
            Button(
                action: {
                    changeMonth(by: 1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(canMoveToNextMonth() ? .pWhite : . pGray)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .background(Color("PDarkGray"))
                        .cornerRadius(24)
                }
            )
            .disabled(!canMoveToNextMonth())
        }
    }
    
    
    // MARK: - 요일 표시
    
    private var weekdayView: some View {
        HStack {
            ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                Text(Self.weekdaySymbols[symbol].uppercased())
                    .font(.PTitle3)
                    .foregroundColor(.pBlack)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                        let isDateInShoppingList = shoppingViewModel.dateItem.contains { dateItem in
                                                Calendar.current.isDate(dateItem.date, inSameDayAs: date)
                                            }
                        
                        
                        
                        CellView(day: day, clicked: clicked, isToday: isToday, isDateInShoppingList: isDateInShoppingList)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        CellView(day: day, isCurrentMonthDay: false, isDateInShoppingList: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = getDate(for: index)
                        clickedCurrentMonthDates = date
                        
                        clickedCurrentMonthDates.map { date in
                            let formattedDate = shoppingViewModel.formatDateToDate(from: date)
                            
                            for item in shoppingViewModel.dateItem {
                                let date = shoppingViewModel.formatDateToDate(from: item.date)
                                
                                if date == formattedDate {
                                    isShopping = true
                                    shoppingViewModel.selectedDateItem = item
                                    showSheet.toggle()
                                    break
                                }
                                
                                else {
                                    isShopping = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    private var isDateInShoppingList: Bool
  private var day: Int
  private var clicked: Bool
  private var isToday: Bool
  private var isCurrentMonthDay: Bool
    
    fileprivate init(
      day: Int,
      clicked: Bool = false,
      isToday: Bool = false,
      isCurrentMonthDay: Bool = true,
      isDateInShoppingList: Bool = false
    ) {
      self.day = day
      self.clicked = clicked
      self.isToday = isToday
      self.isCurrentMonthDay = isCurrentMonthDay
        self.isDateInShoppingList = isDateInShoppingList
    }
  
  fileprivate var body: some View {
    VStack {
        if clicked {

            Circle()
                .fill(Color.pDarkGray)
                .frame(width: 48, height:48)
                .overlay(Text(String(day)).font(.PBody))
                .foregroundColor(.pWhite)
            
            
        } else if isDateInShoppingList {
            ZStack{
                Circle()
                    .fill(Color.pBlue)
                    .frame(width: 48, height:48)
                    .overlay(Text(String(day)).font(.PBody))
                    .foregroundColor(.pWhite)
                if isToday{
                        Circle()
                            .fill(.clear)
                            .stroke(Color.pDarkGray)
                            .frame(width: 48, height:48)
                            .overlay(Text(String(day)).font(.PBody))
                            .foregroundColor(Color.pBlack)
                }
            }
            
        } else if isToday {
            Circle()
                .fill(.pWhite)
                .stroke(Color.pDarkGray)
                .frame(width: 48, height:48)
                .overlay(Text(String(day)).font(.PBody))
                .foregroundColor(Color.pBlack)
            
        } else if isCurrentMonthDay{
            Circle()
                .fill(Color.pWhite)
                .frame(width: 48, height:48)
                .overlay(Text(String(day)).font(.PBody))
                .foregroundColor(Color.pBlack)
        } else {
            Circle()
                .fill(Color.pWhite)
                .frame(width: 48, height:48)
                .overlay(Text(String(day)).font(.PBody))
                .foregroundColor(Color.pWhite)
        }
      
      Spacer()
    }
    .frame(height: 48)
  }
}

// MARK: - CalendarView Static 프로퍼티
private extension CalendarView {
  var today: Date {
    let now = Date()
    let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
    return Calendar.current.date(from: components)!
  }
  
  static let calendarHeaderDateFormatterYear: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY"
    return formatter
  }()
    
    static let calendarHeaderDateFormatterMonth: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM월"
      return formatter
    }()
    
    static let weekdaySymbols: [String] = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR") // 한국어 로케일로 설정
            return calendar.shortWeekdaySymbols // 요일 이름을 한글로 반환
        }()
}

// MARK: - 내부 로직 메서드
private extension CalendarView {
  /// 특정 해당 날짜
  func getDate(for index: Int) -> Date {
    let calendar = Calendar.current
    guard let firstDayOfMonth = calendar.date(
      from: DateComponents(
        year: calendar.component(.year, from: month),
        month: calendar.component(.month, from: month),
        day: 1
      )
    ) else {
      return Date()
    }
    
    var dateComponents = DateComponents()
    dateComponents.day = index
    
    let timeZone = TimeZone.current
    let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
    dateComponents.second = Int(offset)
    
    let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
    return date
  }
  
  /// 해당 월에 존재하는 일자 수
  func numberOfDays(in date: Date) -> Int {
    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }
  
  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
  
  /// 이전 월 마지막 일자
  func previousMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: month)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    
    return previousMonth
  }
  
  /// 월 변경
  func changeMonth(by value: Int) {
    self.month = adjustedMonth(by: value)
  }
  
  /// 이전 월로 이동 가능한지 확인
  func canMoveToPreviousMonth() -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
    
    if adjustedMonth(by: -1) < targetDate {
      return false
    }
    return true
  }
  
  /// 다음 월로 이동 가능한지 확인
  func canMoveToNextMonth() -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
    
    if adjustedMonth(by: 1) > targetDate {
      return false
    }
    return true
  }
  
  /// 변경하려는 월 반환
  func adjustedMonth(by value: Int) -> Date {
    if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
      return newMonth
    }
    return month
  }
}

// MARK: - Date 익스텐션
extension Date {
  static let calendarDayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy dd"
    return formatter
  }()
  
  var formattedCalendarDayDate: String {
    return Date.calendarDayDateFormatter.string(from: self)
  }
}

// MARK: - 프리뷰
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarView(shoppingViewModel: ShoppingViewModel(),listViewModel: ListViewModel())
  }
}
