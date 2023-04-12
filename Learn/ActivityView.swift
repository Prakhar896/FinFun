import SwiftUI

struct ActivityView: View {
    @ObservedObject var appState: AppState
    
    @State var lessonSectionAnimationDegrees = 0
    @State var lessonSectionAnimationScale = 1.0
    
    var lesson: Lesson {
        appState.currentLesson
    }
    var lessonIndex: Int {
        Lesson.firstIndexOfLesson(lesson, in: appState.lessons)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Description
                VStack(alignment: .leading, spacing: 0) {
                    SectionHeader(title: "Description")
                    Text(lesson.description)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18))
                        .padding()
                }
                
                // How It Works Section
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "How It Works")
                    
                    ForEach(lesson.howItWorks.sections, id: \.sectionTitle) { section in
                        LessonSection(section: section)
                    }
                }
            }
        }
        .navigationTitle(lesson.title)
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityView(appState: AppState())
        }
    }
}
