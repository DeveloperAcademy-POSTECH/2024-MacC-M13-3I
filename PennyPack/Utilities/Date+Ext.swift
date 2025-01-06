import Foundation

extension Date {
    var formattedCalendarDayDate: String {
        DateFormatter.calendarDayDateFormatter.string(from: self)
    }
    
    static var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
}
