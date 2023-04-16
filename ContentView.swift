import SwiftUI

enum PageIdentifier: String {
    case title = "Title", learn = "Learn", play = "Play"
}

struct ContentView: View {
    @ObservedObject var appState = AppState()
    @State var pageShowing: PageIdentifier = .learn
    
    var body: some View {
        switch pageShowing {
        case .title:
            TitleView(appState: appState, pageShowing: $pageShowing)
        case .learn:
            LearnView(appState: appState)
                .onAppear {
                    appState.lessons = Lesson.loadDefaultLessons()
                    appState.currentLesson = appState.lessons[0]
                }
        case .play:
            Text("Yet to come")
//        default:
//            Text("Oops! Looks like you are caught in the middle of nowhere!\nPlease restart the app.")
        }
    }
}
