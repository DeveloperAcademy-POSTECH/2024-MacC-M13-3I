//
//// MARK: - 일자 셀 뷰
//private struct CellView: View {
//  private var day: Int
//  private var clicked: Bool
//  private var isToday: Bool
//  private var isCurrentMonthDay: Bool
//  private var textColor: Color {
//    if clicked {
//      return Color.white
//    } else if isCurrentMonthDay {
//      return Color.black
//    } else {
//      return Color.gray
//    }
//  }
//  private var backgroundColor: Color {
//    if clicked {
//      return Color.black
//    } else if isToday {
//      return Color.gray
//    } else {
//      return Color.white
//    }
//  }
//  
//  fileprivate init(
//    day: Int,
//    clicked: Bool = false,
//    isToday: Bool = false,
//    isCurrentMonthDay: Bool = true
//  ) {
//    self.day = day
//    self.clicked = clicked
//    self.isToday = isToday
//    self.isCurrentMonthDay = isCurrentMonthDay
//  }
//  
//  fileprivate var body: some View {
//    VStack {
//      Circle()
//        .fill(backgroundColor)
//        .overlay(Text(String(day)))
//        .foregroundColor(textColor)
//      
//      Spacer()
//      
//      if clicked {
//        RoundedRectangle(cornerRadius: 10)
//          .fill(.red)
//          .frame(width: 10, height: 10)
//      } else {
//        Spacer()
//          .frame(height: 10)
//      }
//    }
//    .frame(height: 50)
//  }
//}
//
//// MARK: - CalendarView Static 프로퍼티
//private extension CalendarView {
//  var today: Date {
//    let now = Date()
//    let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
//    return Calendar.current.date(from: components)!
//  }
//  
//  static let calendarHeaderDateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "YYYY.MM"
//    return formatter
//  }()
//  
//  static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
//}
//
//// MARK: - 내부 로직 메서드
//private extension CalendarView {
//  /// 특정 해당 날짜
//  func getDate(for index: Int) -> Date {
//    let calendar = Calendar.current
//    guard let firstDayOfMonth = calendar.date(
//      from: DateComponents(
//        year: calendar.component(.year, from: month),
//        month: calendar.component(.month, from: month),
//        day: 1
//      )
//    ) else {
//      return Date()
//    }
//    
//    var dateComponents = DateComponents()
//    dateComponents.day = index
//    
//    let timeZone = TimeZone.current
//    let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
//    dateComponents.second = Int(offset)
//    
//    let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
//    return date
//  }
//  
//  /// 해당 월에 존재하는 일자 수
//  func numberOfDays(in date: Date) -> Int {
//    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
//  }
//  
//  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
//  func firstWeekdayOfMonth(in date: Date) -> Int {
//    let components = Calendar.current.dateComponents([.year, .month], from: date)
//    let firstDayOfMonth = Calendar.current.date(from: components)!
//    
//    return Calendar.current.component(.weekday, from: firstDayOfMonth)
//  }
//  
//  /// 이전 월 마지막 일자
//  func previousMonth() -> Date {
//    let components = Calendar.current.dateComponents([.year, .month], from: month)
//    let firstDayOfMonth = Calendar.current.date(from: components)!
//    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
//    
//    return previousMonth
//  }
//  
//  /// 월 변경
//  func changeMonth(by value: Int) {
//    self.month = adjustedMonth(by: value)
//  }
//  
//  /// 이전 월로 이동 가능한지 확인
//  func canMoveToPreviousMonth() -> Bool {
//    let currentDate = Date()
//    let calendar = Calendar.current
//    let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
//    
//    if adjustedMonth(by: -1) < targetDate {
//      return false
//    }
//    return true
//  }
//  
//  /// 다음 월로 이동 가능한지 확인
//  func canMoveToNextMonth() -> Bool {
//    let currentDate = Date()
//    let calendar = Calendar.current
//    let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
//    
//    if adjustedMonth(by: 1) > targetDate {
//      return false
//    }
//    return true
//  }
//  
//  /// 변경하려는 월 반환
//  func adjustedMonth(by value: Int) -> Date {
//    if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
//      return newMonth
//    }
//    return month
//  }
//}
//
//// MARK: - Date 익스텐션
//extension Date {
//  static let calendarDayDateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMMM yyyy dd"
//    return formatter
//  }()
//  
//  var formattedCalendarDayDate: String {
//    return Date.calendarDayDateFormatter.string(from: self)
//  }
//}
