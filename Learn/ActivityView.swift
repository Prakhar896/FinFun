//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 10/4/23.
//

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
        VStack {
            Text(lesson.description)
                .font(.footnote)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(appState: AppState())
    }
}
