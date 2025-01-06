import Foundation

extension DateFormatter {
    /// 날짜+시간 출력
    static func formatDateToYYYYMDHHMM(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        return formatter.string(from: date)
    }
    /// 날짜 출력
    static func formatDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    /// 시간 출력
    static func formatDateToHHMM(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedTime = formatter.string(from: date)
        return formattedTime
    }
    /// 현재 요일 출력
    static func formatDateToDate(from date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day
        ))
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
    
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
}
