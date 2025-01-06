import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var calendarViewModle: CalendarViewModel
    
    @State private var month: Date = Date()
    
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
                    
                    if !calendarViewModle.isShopping {
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
            .sheet(isPresented: $calendarViewModle.showSheet) {
                ReceiptView(receiptViewModel: ReceiptViewModel(shoppingManager: calendarViewModle.shoppingManager, listManager: calendarViewModle.listManager))
                    .presentationDetents([.height(130), .height(540)])
            }
            .onAppear {
                let dateToCheck = calendarViewModle.clickedCurrentMonthDates ?? Date()
                let formattedDate = DateFormatter.formatDateToDate(from: dateToCheck)
                
//                for item in calendarViewModle.shoppingManager.receiptDate {
//                    let itemDate = DateFormatter.formatDateToDate(from: item.date)
//                    
//                    if itemDate == formattedDate {
//                        calendarViewModle.isShopping = true
//                        calendarViewModle.shoppingManager.selectedReceiptDate = item
//                        calendarViewModle.showSheet.toggle()
//                        break
//                    }
//                    else { 
//                        calendarViewModle.isShopping = false
//                    }
//                }
                
                if let latestItem = calendarViewModle.shoppingManager.receiptDate
                                .filter({ DateFormatter.formatDateToDate(from: $0.date) == formattedDate })
                                .max(by: { $0.date < $1.date }) {
                                
                    calendarViewModle.isShopping = true
                    calendarViewModle.shoppingManager.selectedReceiptDate = latestItem
                        calendarViewModle.showSheet.toggle()
                            } else {
                                calendarViewModle.isShopping = false
                            }
            }
        }.navigationBarBackButtonHidden()
    }
    
    
    // MARK: - 연월 표시
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(
                action: {
                    calendarViewModle.changeMonth(by: -1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(calendarViewModle.canMoveToPreviousMonth() ? .pWhite : . pGray)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .background(Color("PDarkGray"))
                        .cornerRadius(24)
                    
                }
            )
            .disabled(!calendarViewModle.canMoveToPreviousMonth())
            Spacer()
            
            VStack(alignment: .center){
                Text(calendarViewModle.month, formatter: DateFormatter.calendarHeaderDateFormatterMonth)
                    .font(.PTitle1)
                    .foregroundColor(.pWhite)
                Text(calendarViewModle.month, formatter: DateFormatter.calendarHeaderDateFormatterYear)
                    .font(.PTitle3)
                    .foregroundColor(.pWhite)
            }
            
            Spacer()
            Button(
                action: {
                    calendarViewModle.changeMonth(by: 1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(calendarViewModle.canMoveToNextMonth() ? .pWhite : . pGray)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .background(Color("PDarkGray"))
                        .cornerRadius(24)
                }
            )
            .disabled(!calendarViewModle.canMoveToNextMonth())
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
        let daysInMonth: Int = calendarViewModle.numberOfDays(in: calendarViewModle.month)
        let firstWeekday: Int = calendarViewModle.firstWeekdayOfMonth(in: calendarViewModle.month) - 1
        let lastDayOfMonthBefore = calendarViewModle.numberOfDays(in: calendarViewModle.previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = calendarViewModle.getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = calendarViewModle.clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == Date.today.formattedCalendarDayDate
                        let isDateInShoppingList = calendarViewModle.shoppingManager.receiptDate.contains { receiptDate in
                            Calendar.current.isDate(receiptDate.date, inSameDayAs: date)
                        }
                        
                        CellView(day: day, clicked: clicked, isToday: isToday, isDateInShoppingList: isDateInShoppingList)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: calendarViewModle.previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        CellView(day: day, isCurrentMonthDay: false, isDateInShoppingList: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = calendarViewModle.getDate(for: index)
                            calendarViewModle.clickedCurrentMonthDates = date
                        
                            calendarViewModle.clickedCurrentMonthDates.map { date in
                            let formattedDate = DateFormatter.formatDateToDate(from: date)
                            for item in calendarViewModle.shoppingManager.receiptDate {
                                let date = DateFormatter.formatDateToDate(from: item.date)
                                
                                if date == formattedDate {
                                    calendarViewModle.isShopping = true
                                    calendarViewModle.shoppingManager.selectedReceiptDate = item
                                        calendarViewModle.showSheet.toggle()
                                    break
                                }
                                
                                else {
                                    calendarViewModle.isShopping = false
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
    
    
    static let weekdaySymbols: [String] = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            return calendar.shortWeekdaySymbols
        }()
}

#Preview {
    CalendarView(calendarViewModle: CalendarViewModel(shoppingManager: ShoppingManager(), listManager: ListManager()))
}
