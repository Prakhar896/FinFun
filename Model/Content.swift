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
                    explanation: "Usually, regular savings accounts have an average interest rate of 0.20-1.00% APY (Annual Percentage Yield). This amounts to very little growth for your money over long periods of time.\n\nFixed deposits (FDs) can help with this, but do note that you cannot replace savings accounts with them.",
                    imageName: "calendar.badge.exclamationmark"
                ),
                LessonHowItWorksSection(
                    sectionTitle: "The Details",
                    explanation: "First, you open a FD account and select a time period (you will not be able to access the money during this period) for which you'd like to store your money.\n\nNext, your financial institution (bank, credit union etc.) will give you an interest rate based on the time period and initial sum.\n\nNote that you should think ahead when setting aside your FD investment to avoid a penalty fee some institutions impose should you break your FD.",
                    imageName: "list.number"
                ),
                LessonHowItWorksSection(
                    sectionTitle: "Comparison",
                    explanation: "An FD of $1000 set for 10 years with an interest rate of 7% per annum would result in a final sum of $2145 as compared to a much lower sum of around $1082 from a savings account at a rate of 0.8% for the same time period.",
                    imageName: "percent"
                )
            ]
        )
    )
    
    static let managedFunds = Lesson(
        title: "Managed Funds",
        description: "Managed funds are investment funds run on behalf of an investor, usually alongside other investors, by an agent, bank or insurance company. Don't worry if it takes a second for you to digest this advanced concept.",
        howItWorks: LessonHowItWorks(
            sections: [
                LessonHowItWorksSection(
                    sectionTitle: "Why Managed Funds?",
                    explanation: "In order to properly invest money in the market by yourself, you need to have prior knowledge, experience and a refined skillset. Many, however, would like to skip this step and rather outsource the investment itself to a third party running managed funds.",
                    imageName: "person.fill.questionmark"
                ),
                LessonHowItWorksSection(
                    sectionTitle: "The Process",
                    explanation: "First, a bank starts a \"virtual\" fund and divides it into a certain number of units (that can be purchased by investors). For simplicity's sake, let's say a fund has 100 units, each priced at $10. Let's say you purchase 10 units of this fund, thus investing $100.\n\nNext, the institution goes on to invest the money in the market across various stocks and shares. The returns, on which an admin fee may be imposed, from the investment are divided amongst all unit holders.",
                    imageName: "arrow.triangle.2.circlepath"
                ),
                LessonHowItWorksSection(
                    sectionTitle: "Risky Business",
                    explanation: "No, this section does not have anything to do with the Tom Cruise film unfortunately.\n\nInvesting in managed funds is always risky because of various reasons. One of them is market risk, where the value of the investments decline because of unavoidable risks, such as recessions, that affect the entire market.\n\nAnother one is liquidity risk where a managed fund can't sell an investment that's declining in value because there are no buyers, i.e you cannot access your money by selling your unit because no one wants to buy it. Thus, you have to be aware and careful about how you invest in managed funds.",
                    imageName: "exclamationmark.octagon.fill"
                )
            ]
        )
    )
}
