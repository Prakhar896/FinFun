import SwiftUI

enum PageIdentifier: String {
    case title = "Title", learn = "Learn", play = "Play"
}

struct ContentView: View {
    @ObservedObject var appState = AppState()
    @State var pageShowing: PageIdentifier = .title
    
    var body: some View {
        switch pageShowing {
        case .title:
            TitleView(appState: appState, pageShowing: $pageShowing)
        case .learn:
            LearnView(appState: appState)
        case .play:
            Text("Yet to come")
//        default:
//            Text("Oops! Looks like you are caught in the middle of nowhere!\nPlease restart the app.")
        }
    }
}
