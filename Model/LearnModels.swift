//
//  Models.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import Foundation

enum LessonTypes: String {
    case fd = "Fixed Deposits", savings = "Savings", funds = "Managed Funds", insurance = "Insurance"
}

struct Lesson: Codable, Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var howItWorks: LessonHowItWorks
    var quiz: LessonQuiz
    var completed: Bool = false
    
    static func loadDefaultLessons() -> [Lesson] {
        return [
            Content.fixedDeposits
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

struct LessonQuiz: Codable {
    var lessonTitle: String
    var questions: [LessonQuizQuestion]
}

struct LessonQuizQuestion: Codable {
    var question: String
    var options: [String]
    var correctOption: Int
    var userSelectedOption: Int? = nil
    
    /// Returns a string which represents the correct answer based on the provided correctOption integer safely from the options array
    var correctOptionString: String? {
        if options.isEmpty || correctOption > (options.count - 1) {
            return nil
        }
        return options[correctOption]
    }
    
    /// Requires userSelectedOption to have a value within the index range of the options array.
    var userIsCorrect: Bool? {
        if let userSelectedOption = userSelectedOption {
            if userSelectedOption > (options.count - 1) { // Out of range
                return nil
            }
            
            if correctOptionString == options[userSelectedOption] {
                return true
            } else {
                return false
            }
        }
        return nil
    }
}
