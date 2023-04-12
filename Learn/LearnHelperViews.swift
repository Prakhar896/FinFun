//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 11/4/23.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title2.weight(.bold))
            .padding()
            .multilineTextAlignment(.leading)
    }
}

struct LessonSection: View {
    var section: LessonHowItWorksSection
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: section.imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .padding()
                    .padding(.leading, 5)
                    .frame(width: 80, height: 80)
                    .background(Color.accentColor.cornerRadius(10).opacity(0.1))
                    .padding(.leading, 5)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(section.sectionTitle)
                        .font(.title3.weight(.bold))
                        .padding()
                    Text(section.explanation)
                        .font(.system(size: 16))
                        .padding()
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct LearnHelperViews_Previews: PreviewProvider {
    static var previews: some View {
        LessonSection(section: Lesson.loadDefaultLessons()[0].howItWorks.sections[0])
    }
}
