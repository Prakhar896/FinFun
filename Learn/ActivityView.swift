import SwiftUI

struct ActivityView: View {
    @ObservedObject var appState: AppState
    
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
                    Text("Description")
                        .font(.title2.weight(.bold))
                        .padding()
                        .multilineTextAlignment(.leading)
                    Text(lesson.description)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18))
                        .padding()
                }
                
                // How It Works Section
                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "How It Works")
                    
                    ForEach(lesson.howItWorks.sections, id: \.sectionTitle) { section in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .padding(5)
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            HStack {
                                Image(section.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text(section.sectionTitle)
                                        .font(.title3.weight(.bold))
                                        .padding()
                                    Text(section.explanation)
                                        .font(.system(size: 16))
                                        .bold()
                                        .padding()
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding()
                        }
                        .padding()
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
