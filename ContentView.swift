import SwiftUI

enum PageIdentifier: String {
    case title = "Title", learn = "Learn", play = "Play"
}

@available(iOS 16, *)
struct ContentView: View {
    @StateObject var appState = AppState()
    @State var pageShowing: PageIdentifier = .title
    
    var body: some View {
        switch pageShowing {
        case .title:
            TitleView(appState: appState, pageShowing: $pageShowing)
        case .learn:
            LearnView(appState: appState, pageShowing: $pageShowing)
        case .play:
            ProfileSetupView(pageShowing: $pageShowing)
        }
    }
}
