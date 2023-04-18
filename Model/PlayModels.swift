//
//  File.swift
//  
//
//  Created by Prakhar Trivedi on 16/4/23.
//

import Foundation

enum SalaryOptions: String {
    case hard = "$20K (Hard)", medium = "$50K (Medium)", easy = "$100K (Easy)"
}

enum CareerGrowthOptions: String {
    case hard = "2% (Hard)", medium = "5% (Medium)", easy = "10% (Easy)"
}

class Child: Identifiable {
    var id = UUID()
    @Published var age: Int
    
    init(id: UUID = UUID(), age: Int) {
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
            return 100
        case .medium:
            return 50
        case .hard:
            return 20
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

class Transaction {
    var title: String
    var type: TransactionType
    var posOrNeg: PositiveOrNegative
    var quantity: Double
    var description: String? = nil
    
    init(title: String, type: TransactionType, posOrNeg: PositiveOrNegative, quantity: Double, description: String? = nil) {
        self.title = title
        self.type = type
        self.posOrNeg = posOrNeg
        self.quantity = quantity
        self.description = description
    }
}

class GameState: ObservableObject {
    var userGameProfile: GameProfile
    @Published var balance: Double
    @Published var transactions: [Transaction]
    @Published var timeLeft: Double // this is in seconds
    @Published var realTimeElapsed: Double
    
    @Published var lifeEvents: [LifeEvent]
    @Published var lifeManager: LifeManager
    
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
        self.balance = balance
        self.transactions = [
            Transaction(
                title: "Initial Deposit",
                type: .initialDeposit,
                posOrNeg: .positive,
                quantity: 10000,
                description: "This is an inital deposit for you to work with at the start of the game."
            )
        ]
        self.timeLeft = timeLeft
        self.realTimeElapsed = realTimeElapsed
        
        self.lifeEvents = LifeEvent.setupEventsForPlay(playerHasChildren: !userGameProfile.children.isEmpty)
        self.lifeManager = LifeManager(salaryInThousands: userGameProfile.monthlySalaryInThousands, monthlyExpenditure: userGameProfile.monthlyExpenses, children: userGameProfile.children)
    }
    
    func unitTimeDidElapse() {
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
                    lifeEvents[eventIndex].occurred = true
                    
                    newTransacts.append(
                        Transaction(
                            title: "Life Event: \(lifeEvents[eventIndex].title)",
                            type: .lifeEvent,
                            posOrNeg: .negative,
                            quantity: Double(LifeEvent.costForEvent(withEventType: lifeEvents[eventIndex].type)),
                            description: "A life event occurred; \(lifeEvents[eventIndex].targetParty.rawValue.lowercased()) experienced a/an \(lifeEvents[eventIndex].type.rawValue.lowercased())."
                        )
                    )
                }
            }
        }
    }
    
    static func timeLeftDeductionRatePerPointOneSecond(gameDuration: Double) -> Double {
        return round(defaultTimeLimit / gameDuration / 10 * 1000) / 1000 // round to 3dp
    }
    
    static let defaultTimeLimit: Double = 50 * 365 * 24 * 60 * 60
    static let secondsInAYear = 365 * 24 * 60 * 60
    static let secondsInAMonth = 30.42 * 24 * 60 * 60
}


#warning("put below on view struct later")
//var occurredLifeEvents: [LifeEvent] {
//    var events: [LifeEvent] = []
//    for lifeEvent in lifeEvents {
//        if lifeEvent.occurred {
//            events.append(lifeEvent)
//        }
//    }
//}
