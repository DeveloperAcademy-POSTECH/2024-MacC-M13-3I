import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject{
    @Published var shoppingManager: ShoppingManager
    @Published var listManager: ListManager
    
    @Published var month: Date = Date()
    @Published var clickedCurrentMonthDates: Date?
    @Published var showSheet: Bool = false
    @Published var isShopping: Bool = false
    
    init(shoppingManager: ShoppingManager, listManager: ListManager) {
        self.shoppingManager = shoppingManager
        self.listManager = listManager
    }
    
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
    
    // MARK: 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
      return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // MARK: 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
      let components = Calendar.current.dateComponents([.year, .month], from: date)
      let firstDayOfMonth = Calendar.current.date(from: components)!
      
      return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    // MARK: 이전 월 마지막 일자
    func previousMonth() -> Date {
      let components = Calendar.current.dateComponents([.year, .month], from: month)
      let firstDayOfMonth = Calendar.current.date(from: components)!
      let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
      
      return previousMonth
    }
    
    // MARK: 월 변경
    func changeMonth(by value: Int) {
      self.month = adjustedMonth(by: value)
    }
    
    // MARK: 이전 월로 이동 가능한지 확인
    func canMoveToPreviousMonth() -> Bool {
      let currentDate = Date()
      let calendar = Calendar.current
      let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
      
      if adjustedMonth(by: -1) < targetDate {
        return false
      }
      return true
    }
    
    // MARK: 다음 월로 이동 가능한지 확인
    func canMoveToNextMonth() -> Bool {
      let currentDate = Date()
      let calendar = Calendar.current
      let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
      
      if adjustedMonth(by: 1) > targetDate {
        return false
      }
      return true
    }
    
    // MARK: 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
      if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
        return newMonth
      }
      return month
    }
}
