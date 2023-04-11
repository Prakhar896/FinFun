//
//  LearnView.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import SwiftUI

struct LearnView: View {
    @ObservedObject var appState: AppState
    
    var lessons: [Lesson] {
        appState.lessons
    }
    
    var body: some View {
        NavigationView {
            // Navigation
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(lessons) { lesson in
                        Button {
                            // Switch to the page
                            appState.currentLesson = lesson
                            print(lesson.id)
                            print(appState.lessons)
                        } label: {
                            HStack {
                                Image(systemName: lesson.completed ? "checkmark.circle.fill": "circle")
                                    .foregroundColor(lesson.completed ? .green: .secondary)
                                    .transition(.scale.combined(with: .opacity))
                                Text(lesson.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding(10)
                        }
                        .padding(10)
                        .background(appState.currentLesson.id == lesson.id ? Color.accentColor.opacity(0.1): .clear)
                        .cornerRadius(10)
                    }
                }
                .padding(10)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Learn")
            
            // Lesson Activity
            ActivityView(appState: appState)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Aint nothing gonna happen LMAO (but fr tho segue to play section")
                        } label: {
                            Text("Continue")
                                .foregroundColor(appState.lessonsCompleted != appState.lessons.count ? .secondary: .blue)
                        }
                        .disabled(appState.lessonsCompleted != appState.lessons.count)
                    }
                }
        }
        .onAppear {
            print(appState.currentLesson.id)
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView(appState: AppState())
    }
}
