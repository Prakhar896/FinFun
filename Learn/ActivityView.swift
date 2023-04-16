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
        ScrollViewReader { value in
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
                    .id("ActivityViewTop")
                    
                    // How It Works Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "How It Works")
                        
                        ForEach(lesson.howItWorks.sections, id: \.sectionTitle) { section in
                            LessonSection(section: section)
                        }
                    }
                    
                    // Next lesson button
                    VStack {
                        Button {
                            // update AppState to display next lesson
                            withAnimation {
                                appState.lessons[lessonIndex].completed = true
                                
                                if !appState.completedLearnCourse {
                                    appState.currentLesson = appState.lessons[lessonIndex + 1]
                                    value.scrollTo("ActivityViewTop", anchor: .top)
                                    
                                }
                            }
                        } label: {
                            Text(appState.completedLearnCourse ? "Click on 'Continue' at the top-right corner.": (lessonIndex + 1) == appState.lessons.count ? "Complete Course": "Next Lesson")
                                .foregroundColor(.accentColor)
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                        .disabled(appState.completedLearnCourse)
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
