//import SwiftUI
//
//struct TestView: View {
//    @ObservedObject var linkListStore: LinkListStore = LinkListStore()
//    
//    @State private var listText = ""
//    var body: some View {
//        NavigationStack{
//            ZStack{
//                Color.rBackgroundGray
//                    .ignoresSafeArea()
//                VStack{
//                    Color.rBlack
//                        .ignoresSafeArea()
//                        .frame(height: 339)
//                    Spacer()
//                }
//                
//                VStack(spacing: 24){
//                    HStack{
//                        Text("PennyPack")
//                            .font(.RMainTitle)
//                            .foregroundColor(.white)
//                        Spacer()
//                    }.padding(.horizontal)
//                    
//                    HStack{
//                        Image("France")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 35)
//                        Text("프랑스")
//                        Spacer()
//                        Text("€ 1 = ₩ 1499.62")
//                        Text("(EUR/KRW)")
//                    }
//                    .padding(.vertical, 12)
//                    .padding(.horizontal)
//                    .background(
//                        Color.white
//                            .cornerRadius(12)
//                    )
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.rStrokeGray, lineWidth: 1)
//                        
//                    )
//                    .padding(.horizontal)
//                    
//                    VStack(spacing: 0){
//                        HStack{
//                            Text("오늘의 장보기 리스트")
//                            Spacer()
//                        }
//                        .padding()
//                        .background(
//                            Rectangle()
//                                .foregroundColor(.white)
//                                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
//                        )
//                        .padding(.horizontal)
//                        ZStack{
//                            Rectangle()
//                                .foregroundColor(.rLightGray)
//                                .clipShape(RoundedCorner(radius: 12, corners: [.bottomLeft, .bottomRight]))
//                            
//                            VStack(spacing: 0){
//                                List{
//                                    ForEach($linkListStore.linkLists, id: \.id){ $item in
//                                        TextField("마트에서 살 물건을 이곳에 적어주세요.", text: $item.title)
//                                        
//                                    }
//                                    .listRowBackground(
//                                        Rectangle()
//                                            .foregroundColor(.white)
//                                            .cornerRadius(12)
//                                    )
//                                    Button {
//                                        linkListStore.addLinkList(title: listText)
//                                        
//                                    } label: {
//                                        HStack{
//                                            Spacer()
//                                            Image(systemName: "plus.circle.fill")
//                                                .font(.system(size: 18))
//                                                .foregroundStyle(.gray, .rBackgroundGray)
//                                            Spacer()
//                                        }
//                                    }
//                                    .listRowBackground(
//                                        Rectangle()
//                                            .foregroundColor(.white)
//                                            .cornerRadius(12)
//                                    )
//                                }.listRowSpacing(8)
//                                    .listStyle(PlainListStyle())
//                                    .padding(.horizontal)
//                                    .background(.rLightGray)
//                                
//                                
//                            }.padding(.vertical)
//                        }.padding(.horizontal)
//                        HStack{
//                            Image(systemName: "cart")
//                                .font(.system(size: 24))
//                            Text("장보기 시작")
//                        }.foregroundColor(.white)
//                            .padding(.vertical,13)
//                            .padding(.horizontal,111)
//                        .background(
//                            Rectangle()
//                                .foregroundColor(.rMainBlue)
//                                .cornerRadius(24)
//                        )
//                        .padding(.top,24)
//                        .padding(.bottom)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//
//
//#Preview {
//    TestView()
//}
