import SwiftUI

@main
struct IMUComApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, DBController.shared.context)

        }
    }
}
