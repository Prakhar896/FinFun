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
    var currentLesson: Lesson {
        appState.currentLesson
    }
    
    var body: some View {
        NavigationView {
            // Navigation
            List {
                Section {
                    ForEach(lessons) { lesson in
                        HStack {
                            Image(systemName: lesson.completed ? "checkmark.circle.fill": "circle")
                                .foregroundColor(lesson.completed ? .green: .secondary)
                            Text(lesson.title)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Learn")
            
            // Lesson Activity
            Text(currentLesson.description)
                .font(.title3)
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView(appState: AppState())
    }
}
