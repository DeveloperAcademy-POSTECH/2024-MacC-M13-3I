import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var calendarViewModel: CalendarViewModel
    
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
                    
                    if !calendarViewModel.isShopping {
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
            .sheet(isPresented: $calendarViewModel.showSheet) {
                ReceiptView(receiptViewModel: ReceiptViewModel(shoppingManager: calendarViewModel.shoppingManager, listManager: calendarViewModel.listManager))
                    .presentationDetents([.height(130), .height(540)])
            }
            .onAppear {
                let dateToCheck = calendarViewModel.clickedCurrentMonthDates ?? Date()
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
                
                if let latestItem = calendarViewModel.shoppingManager.receiptDate
                                .filter({ DateFormatter.formatDateToDate(from: $0.date) == formattedDate })
                                .max(by: { $0.date < $1.date }) {
                    calendarViewModel.isShopping = true
                    calendarViewModel.shoppingManager.selectedReceiptDate = latestItem
                    calendarViewModel.showSheet.toggle()
                } else {
                    calendarViewModel.isShopping = false
                }
            }
        }.navigationBarBackButtonHidden()
    }
    
    
    // MARK: - 연월 표시
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(
                action: {
                    calendarViewModel.changeMonth(by: -1)
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(calendarViewModel.canMoveToPreviousMonth() ? .pWhite : . pGray)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .background(Color("PDarkGray"))
                        .cornerRadius(24)
                    
                }
            )
            .disabled(!calendarViewModel.canMoveToPreviousMonth())
            Spacer()
            
            VStack(alignment: .center){
                Text(calendarViewModel.month, formatter: DateFormatter.calendarHeaderDateFormatterMonth)
                    .font(.PTitle1)
                    .foregroundColor(.pWhite)
                Text(calendarViewModel.month, formatter: DateFormatter.calendarHeaderDateFormatterYear)
                    .font(.PTitle3)
                    .foregroundColor(.pWhite)
            }
            
            Spacer()
            Button(
                action: {
                    calendarViewModel.changeMonth(by: 1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(calendarViewModel.canMoveToNextMonth() ? .pWhite : . pGray)
                        .padding(8)
                        .padding(.horizontal, 2)
                        .background(Color("PDarkGray"))
                        .cornerRadius(24)
                }
            )
            .disabled(!calendarViewModel.canMoveToNextMonth())
        }
    }
    
    
    // MARK: - 요일 표시
    private var weekdayView: some View {
        HStack {
            ForEach(Date.weekdaySymbolsInKorean.indices, id: \.self) { symbol in
                Text(Date.weekdaySymbolsInKorean[symbol].uppercased())
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
        let daysInMonth: Int = calendarViewModel.numberOfDays(in: calendarViewModel.month)
        let firstWeekday: Int = calendarViewModel.firstWeekdayOfMonth(in: calendarViewModel.month) - 1
        let lastDayOfMonthBefore = calendarViewModel.numberOfDays(in: calendarViewModel.previousMonth())
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = calendarViewModel.getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let clicked = calendarViewModel.clickedCurrentMonthDates == date
                        let isToday = date.formattedCalendarDayDate == Date.today.formattedCalendarDayDate
                        let isDateInShoppingList = calendarViewModel.shoppingManager.receiptDate.contains { receiptDate in
                            Calendar.current.isDate(receiptDate.date, inSameDayAs: date)
                        }
                        
                        CellView(day: day, clicked: clicked, isToday: isToday, isDateInShoppingList: isDateInShoppingList)
                    } else if let prevMonthDate = Calendar.current.date(
                        byAdding: .day,
                        value: index + lastDayOfMonthBefore,
                        to: calendarViewModel.previousMonth()
                    ) {
                        let day = Calendar.current.component(.day, from: prevMonthDate)
                        
                        CellView(day: day, isCurrentMonthDay: false, isDateInShoppingList: false)
                    }
                }
                .onTapGesture {
                    if 0 <= index && index < daysInMonth {
                        let date = calendarViewModel.getDate(for: index)
                        calendarViewModel.clickedCurrentMonthDates = date
                        
                        calendarViewModel.clickedCurrentMonthDates.map { date in
                            let formattedDate = DateFormatter.formatDateToDate(from: date)
                            for item in calendarViewModel.shoppingManager.receiptDate {
                                let date = DateFormatter.formatDateToDate(from: item.date)
                                
                                if date == formattedDate {
                                    calendarViewModel.isShopping = true
                                    calendarViewModel.shoppingManager.selectedReceiptDate = item
                                    calendarViewModel.showSheet.toggle()
                                    break
                                }
                                
                                else {
                                    calendarViewModel.isShopping = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    CalendarView(calendarViewModel: CalendarViewModel(shoppingManager: ShoppingManager(), listManager: ListManager()))
}
