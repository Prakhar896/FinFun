//
//  File.swift
//  
//
//  Created by Prakhar Trivedi on 16/4/23.
//

import Foundation
import SwiftUI

enum SalaryOptions: String {
    case hard = "$5K (Hard)", medium = "$10K (Medium)", easy = "$20K (Easy)"
}

enum CareerGrowthOptions: String {
    case hard = "2% (Hard)", medium = "5% (Medium)", easy = "10% (Easy)"
}

class Child: Identifiable {
    var id = UUID()
    @Published var age: Double
    
    init(id: UUID = UUID(), age: Double) {
        self.id = id
        self.age = age
    }
    
    static func feesForChild(_ child: Child) -> Double {
        if child.age <= 10 {
            return 300
        } else if child.age <= 18 {
            return 600
        } else if child.age <= 25 {
            return 1500
        } else {
            return 0
        }
    }
}

struct GameProfile {
    var name: String
    var monthlySalaryInThousands: Int
    var children: [Child]
    var monthlyExpenses: Double
    var careerGrowth: Int // percentage increase in salary every 5 years
    
    static let monthlySalaryOptions: [SalaryOptions] = [.easy, .medium, .hard]
    static func salaryForOption(_ option: SalaryOptions) -> Int {
        switch option {
        case .easy:
            return 20
        case .medium:
            return 10
        case .hard:
            return 5
        }
    }
    
    static let careerGrowthOptions: [CareerGrowthOptions] = [.easy, .medium, .hard]
    static func careerGrowthRate(for difficulty: CareerGrowthOptions) -> Int {
        switch difficulty {
        case .hard:
            return 2
        case .medium:
            return 5
        case .easy:
            return 10
        }
    }
    
    static func blankGameProfile() -> GameProfile {
        return GameProfile(
            name: "John Appleseed",
            monthlySalaryInThousands: 50,
            children: [
                Child(age: 2)
            ],
            monthlyExpenses: 1000,
            careerGrowth: 5
        )
    }
}

enum TransactionType {
    case salary
    case expenses
    case fd
    case savings
    case insurance
    case managedFunds
    case stocks
    case schoolFees
    case lifeEvent
    case initialDeposit
}

enum PositiveOrNegative {
    case positive, negative
}

class Transaction: Identifiable {
    var id = UUID()
    var title: String
    var type: TransactionType
    var posOrNeg: PositiveOrNegative
    var quantity: Double
    var description: String? = nil
    
    init(title: String, type: TransactionType, posOrNeg: PositiveOrNegative, quantity: Double, description: String? = nil) {
        self.id = UUID()
        self.title = title
        self.type = type
        self.posOrNeg = posOrNeg
        self.quantity = quantity
        self.description = description
    }
    
    static func imageName(forTransactionType transactionType: TransactionType) -> String {
        switch transactionType {
        case .salary:
            return "banknote"
        case .expenses:
            return "cart"
        case .fd:
            return "lock"
        case .savings:
            return "building.columns"
        case .insurance:
            return "shield"
        case .managedFunds:
            return "person.3"
        case .stocks:
            return "square.stack.3d.up"
        case .schoolFees:
            return "graduationcap"
        case .lifeEvent:
            return "exclamationmark.triangle"
        case .initialDeposit:
            return "01.circle"
        }
    }
}

@available(iOS 16, *)
class GameState: ObservableObject {
    var userGameProfile: GameProfile
    @Published var balance: Double
    @Published var transactions: [Transaction]
    @Published var timeLeft: Double // this is in seconds
    @Published var realTimeElapsed: Double
    
    @Published var lifeEvents: [LifeEvent]
    @Published var lifeManager: LifeManager
    
    @Published var insuranceManager: InsuranceManager
    
    @Published var gameEnded: Bool = false
    
    var timeLeftReadable: String {
        let years = Int(floor(timeLeft / Double(GameState.secondsInAYear)))
        let months = Int(floor((timeLeft - Double(years * GameState.secondsInAYear)) / (GameState.secondsInAMonth)))
        
        var readableString: String = ""
        if years == 1 {
            readableString += "\(years) year"
        } else {
            readableString += "\(years) years"
        }
        
        if months == 1 {
            readableString += " and \(months) month"
        } else if months != 0 {
            readableString += " and \(months) months."
        }
        
        return readableString
    }
    
    init(userGameProfile: GameProfile, balance: Double, timeLeft: Double, realTimeElapsed: Double) {
        self.userGameProfile = userGameProfile
        self.balance = balance + 10000
        
        let initialDeposit = Transaction(
            title: "Initial Deposit",
            type: .initialDeposit,
            posOrNeg: .positive,
            quantity: 10000,
            description: "This is an inital deposit for you to work with at the start of the game."
        )
        self.transactions = [initialDeposit]
        
        self.timeLeft = timeLeft
        self.realTimeElapsed = realTimeElapsed
        
        self.lifeEvents = LifeEvent.setupEventsForPlay(playerHasChildren: !userGameProfile.children.isEmpty)
        self.lifeManager = LifeManager(salaryInThousands: userGameProfile.monthlySalaryInThousands, monthlyExpenditure: userGameProfile.monthlyExpenses, careerGrowthRate: userGameProfile.careerGrowth, children: userGameProfile.children)
        
        self.insuranceManager = InsuranceManager()
    }
    
    func unitTimeDidElapse() {
        timeLeft = timeLeft - GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration)
        realTimeElapsed += 0.1
        
        // Check if time over
        if realTimeElapsed >= GameState.defaultGameDuration {
            gameEnded = true
        }
        
        // Update all services and apply transactions
        var newTransacts: [Transaction] = []
        
        // Get updates from LifeManager
        let lmTransactions = lifeManager.checkForCharges(realTimeElapsed: realTimeElapsed)
        newTransacts.append(contentsOf: lmTransactions)
        
        // Check on life events
        for eventIndex in 0..<lifeEvents.count {
            if !lifeEvents[eventIndex].occurred {
                if lifeEvents[eventIndex].occursAt < realTimeElapsed {
                    // Set life event has occurred to true
                    withAnimation {
                        lifeEvents[eventIndex].occurred = true
                    }
                    
                    // Check if covered by insurance
                    var eventCost: Double = Double(LifeEvent.costForEvent(withEventType: lifeEvents[eventIndex].type))
                    if insuranceManager.policyPurchased {
                        if insuranceManager.requestInsurancePayout(forLifeEvent: lifeEvents[eventIndex]) {
                            // all costs are paid for by insurance policy
                            eventCost = 0.0
                            lifeEvents[eventIndex].coveredByInsurance = true
                        }
                    }
                    
                    newTransacts.append(
                        Transaction(
                            title: "Life Event: \(lifeEvents[eventIndex].title) \(lifeEvents[eventIndex].coveredByInsurance ? "(Covered by Insurance)": "")",
                            type: .lifeEvent,
                            posOrNeg: .negative,
                            quantity: eventCost,
                            description: "A life event occurred; \(lifeEvents[eventIndex].targetParty.rawValue.lowercased()) experienced a/an \(lifeEvents[eventIndex].type.rawValue.lowercased()). \(lifeEvents[eventIndex].coveredByInsurance ? "All costs for this life event were covered by your purchased insurance policy.": "")"
                        )
                    )
                }
            }
        }
        
        // Check on insurance charges
        var insuranceCharges = insuranceManager.checkForCharges(realTimeElapsed: realTimeElapsed)
        newTransacts.append(contentsOf: insuranceCharges)
        
        withAnimation {
            transactions.insert(contentsOf: newTransacts, at: 0)
            applyTransactions(newTransacts)
        }
        
        // Check if player becomes broke
        if balance <= 0 {
            gameEnded = true
            // view struct can do checking of whether game ended because time over or broke
        }
    }
    
    func applyTransactions(_ transactions: [Transaction]) {
        for transaction in transactions {
            if transaction.posOrNeg == .positive {
                balance += transaction.quantity
            } else {
                balance -= transaction.quantity
            }
        }
    }
    
    static func timeLeftDeductionRatePerPointOneSecond(gameDuration: Double) -> Double {
        return round(defaultTimeLimit / gameDuration / 10 * 1000) / 1000 // round to 3dp
    }
    
    static let defaultTimeLimit: Double = 50 * 365 * 24 * 60 * 60
    static let defaultGameDuration: Double = 120.0
    static let secondsInAYear = 365 * 24 * 60 * 60
    static let secondsInAMonth = 30.42 * 24 * 60 * 60
}
