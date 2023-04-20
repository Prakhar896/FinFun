import SwiftUI

enum PageIdentifier: String {
    case title = "Title", learn = "Learn", play = "Play"
}

@available(iOS 16, *)
struct ContentView: View {
    @StateObject var appState = AppState()
    @State var pageShowing: PageIdentifier = .play
    
    var body: some View {
        switch pageShowing {
        case .title:
            TitleView(appState: appState, pageShowing: $pageShowing)
        case .learn:
            LearnView(appState: appState, pageShowing: $pageShowing)
                .onAppear {
                    #warning("Below are lines of code meant for debug phase only (they prevent data persistence). Remove before final submission.")
                    appState.lessons = Lesson.loadDefaultLessons()
                    
                    // Set all lessons to completed
                    for i in 0..<appState.lessons.count {
                        appState.lessons[i].completed = true
                    }
                }
        case .play:
            ProfileSetupView(pageShowing: $pageShowing)
//        default:
//            Text("Oops! Looks like you are caught in the middle of nowhere!\nPlease restart the app.")
        }
    }
}
