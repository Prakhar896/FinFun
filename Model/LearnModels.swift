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

struct Lesson: Codable {
    var title: String
    var description: String
    var howItWorks: LessonHowItWorks
    var quiz: LessonQuiz
    
    static func loadDefaultLessons() -> [Lesson] {
        let fixedDeposits = Lesson(
            title: "Fixed Deposits",
            description: "Fixed deposits are tools provided by banks or other financial institutions which provide investors a higher rate of interest than a regular savings account until a given maturity date.",
            howItWorks: LessonHowItWorks(
                sections: [
                    LessonHowItWorksSection(
                        sectionTitle: "Normally...",
                        explanation: "Usually, regular savings accounts have an average interest rate of 0.20-1.00% APY (Annual Percentage Yield). This amounts to very little growth for your money over long periods of time. Fixed deposits can help with this, but do note that you cannot replace savings accounts with them.",
                        imageName: "PoorGrowth"
                    )
                ]
            ),
            quiz: LessonQuiz(
                lessonTitle: "Fixed Deposits",
                questions: [
                    LessonQuizQuestion(
                        question: "Is it a good idea to completely use fixed deposits?",
                        options: ["Yes", "No"],
                        correctOption: 0
                    )
                ]
            )
        )
        
        return [fixedDeposits]
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
    var correctOptionString: String? {
        if options.isEmpty || correctOption > (options.count - 1) {
            return nil
        }
        return options[correctOption]
    }
}
