import SwiftUI

enum PageIdentifier: String {
    case title = "Title", learn = "Learn", play = "Play"
}

struct ContentView: View {
    @State var pageShowing: PageIdentifier = .title
    
    var body: some View {
        switch pageShowing {
        case .title:
            TitleView(pageShowing: $pageShowing)
        case .learn:
            LearnView()
        case .play:
            Text("Yet to come")
//        default:
//            Text("Oops! Looks like you are caught in the middle of nowhere!\nPlease restart the app.")
        }
    }
}
