import SwiftUI

struct CellView: View {
    private var isDateInShoppingList: Bool
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isCurrentMonthDay: Bool
    
    init(
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
  
    var body: some View {
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
