import SwiftUI
import SwiftData

@main
struct PennyPackApp: App {
    
    var modelContainer: ModelContainer = {
        let schema = Schema([ListManager.self, ShoppingManager.self])    // ModelContainer를 생성하려면 우선 사용할 모델들을 스키마로 만들어준다.
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        // ModelConfiguration을 생성해 모델 관리 규칙을 설정해준다.
        // ModelConfiguration 옵션으로는 여러 가지가 있는데, (프리뷰 등에서 데이터를 메모리 상에서만 관리할지 여부를 결정하는) inStoredInMemoryOnly, (CloudKit을 사용할 때 데이터베이스를 설정하는) cloudKitbataBase 등이 있다.

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        // 마지막으로 이렇게 만든 Schema와 ModelConfiguration을 사용해 ModelContainer를 만들어준다.
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView(mainViewModel: MainViewModel(shoppingManager: [ShoppingManager()], listManager: [ListManager()]))
        }
        .modelContainer(modelContainer)
    }
}
