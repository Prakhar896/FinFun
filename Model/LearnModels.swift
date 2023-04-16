//
//  Models.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import Foundation

enum LessonTypes: String {
    case fd = "Fixed Deposits", stocks = "Stocks", funds = "Managed Funds", insurance = "Insurance"
}

struct Lesson: Codable, Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var howItWorks: LessonHowItWorks
    var completed: Bool = false
    
    static func loadDefaultLessons() -> [Lesson] {
        return [
            Content.fixedDeposits,
            Content.managedFunds
        ]
    }
    
    static func firstIndexOfLesson(_ lesson: Lesson, in array: [Lesson]) -> Int {
        return array.firstIndex(where: { $0.id == lesson.id }) ?? 0
    }
}

struct LessonHowItWorks: Codable {
    var sections: [LessonHowItWorksSection]
}

struct LessonHowItWorksSection: Codable {
    var sectionTitle: String
    var explanation: String
    var imageName: String
}
