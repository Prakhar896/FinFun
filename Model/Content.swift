//
//  Content.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import Foundation

struct Content {
    // MARK: Default Lesson Data
    static let fixedDeposits = Lesson(
        title: "Fixed Deposits",
        description: "Fixed deposits are tools provided by banks or other financial institutions which provide investors a higher rate of interest than a regular savings account until a given maturity date.",
        howItWorks: LessonHowItWorks(
            sections: [
                LessonHowItWorksSection(
                    sectionTitle: "Normally...",
                    explanation: "Usually, regular savings accounts have an average interest rate of 0.20-1.00% APY (Annual Percentage Yield). This amounts to very little growth for your money over long periods of time.\nFixed deposits (FDs) can help with this, but do note that you cannot replace savings accounts with them.",
                    imageName: "calendar.badge.exclamationmark"
                ),
                LessonHowItWorksSection(
                    sectionTitle: "The Details",
                    explanation: "First, you open a FD account and select a time period (you will not be able to access the money during this period) for which you'd like to store your money.\nNext, your financial institution (bank, credit union etc.) will give you an interest rate based on the time period and initial sum.\nNote that you should think ahead when setting aside your FD investment to avoid a penalty fee some institutions impose should you break your FD.",
                    imageName: "list.number"
                ),
                LessonHowItWorksSection(
                    sectionTitle: "Comparison",
                    explanation: "An FD of $1000 set for 10 years with an interest rate of 7% per annum would result in a final sum of $2145 as compared to a much lower sum of around $1082 from a savings account at a rate of 0.8% for the same time period.",
                    imageName: "percent"
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
                ),
                LessonQuizQuestion(
                    question: "You lose any gained interest if you decide to break your FD before the end of its tenure.",
                    options: ["Yes", "No"],
                    correctOption: 1
                )
            ]
        )
    )
    
    
}
