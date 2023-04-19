//
//  File.swift
//  
//
//  Created by Prakhar Trivedi on 17/4/23.
//
import Foundation

enum TargetParty: String {
    case player = "Player", child = "Child"
}
enum EventType: String {
    case accident = "Accident", medical = "Medical Emergency"
}

class LifeEvent: Identifiable {
    var id: UUID = UUID()
    var title: String
    var type: EventType
    var targetParty: TargetParty
    var occursAt: Double // the timestamp at which it occurs (real time)
    var cost: Int
    
    @Published var occurred: Bool = false
    var description: String? = nil
    
    init(title: String, type: EventType, targetParty: TargetParty, occursAt: Double, cost: Int, occurred: Bool = false, description: String? = nil) {
        self.id = UUID()
        self.title = title
        self.type = type
        self.targetParty = targetParty
        self.occursAt = occursAt
        self.cost = cost
        self.occurred = occurred
        self.description = description
    }
    
    static func safelyGenerateNewRandomTimestamp(generatedEvents events: [LifeEvent]) -> Double {
        var timestamps: [Double] = []
        
        for event in events {
            timestamps.append(event.occursAt)
        }
        
        let newTimeStamp = Double.random(in: 20.0...115.0)
        
        return newTimeStamp
    }
    
    static func costForEvent(withEventType type: EventType) -> Int {
        if type == .accident {
            return [2000, 3000, 4000, 5000].randomElement()!
        } else if type == .medical {
            return [6000, 7000, 8000, 9000, 10000].randomElement()!
        } else {
            return 5000
        }
    }
    
    static func setupEventsForPlay(playerHasChildren: Bool) -> [LifeEvent] {
        var tempEvents: [LifeEvent] = []
        
        let eventTypes: [EventType] = [.accident, .medical]
        var targetTypes: [TargetParty] = [.player]
        if playerHasChildren {
            targetTypes.append(.child)
        }
        
        for _ in 0...2 {
            let event = eventTypes.randomElement() ?? .accident
            let party = targetTypes.randomElement() ?? .player
            
            tempEvents.append(
                LifeEvent(
                    title: event.rawValue,
                    type: event,
                    targetParty: party,
                    occursAt: LifeEvent.safelyGenerateNewRandomTimestamp(generatedEvents: tempEvents),
                    cost: LifeEvent.costForEvent(withEventType: event)
                )
            )
        }
        
        return tempEvents
    }
}

class LifeManager {
    @Published var salaryInThousands: Int // can change with career growth
    var monthlyExpenditure: Double
    var careerGrowthRate: Int
    @Published var children: [Child] // age of children can change with time
    //    var lifeEvents: [LifeEvent]
    
    init(salaryInThousands: Int, monthlyExpenditure: Double, careerGrowthRate: Int, children: [Child]) {
        self.salaryInThousands = salaryInThousands
        self.monthlyExpenditure = monthlyExpenditure
        self.children = children
        self.careerGrowthRate = careerGrowthRate
    }
    
    func checkForCharges(realTimeElapsed: Double) -> [Transaction] {
        // Run every 0.1 seconds
        var charges: [Transaction] = []
        
        // Age the children (reference type so make a manual copy)
        var childrenCopy: [Child] = []
        for child in children {
            childrenCopy.append(Child(age: child.age))
        }
        // actually age them
        for childIndex in 0..<childrenCopy.count {
            // convert rate (which is in seconds) to years by dividing by seconds in a year
            childrenCopy[childIndex].age += realTimeElapsed * (GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration) / Double(GameState.secondsInAYear))
        }
        
        // Issue monthly charges
        var realRealTimeElapsed = realTimeElapsed * 10
        if realRealTimeElapsed.remainder(dividingBy: 2) <= 0 {
            var yearsPassed = Int((realTimeElapsed * (GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration) / Double(GameState.secondsInAYear))).rounded(.down))
            
            // Salary charge
            charges.append(
                Transaction(
                    title: "Monthly Salary",
                    type: .salary,
                    posOrNeg: .positive,
                    quantity: LifeManager.salaryWithGrowthRateBonus(principalSalaryInThousands: Double(salaryInThousands), careerGrowthRatePercentage: careerGrowthRate, forYears: yearsPassed)
                )
            )
            
            // Expenditure charge
            charges.append(
                Transaction(
                    title: "Monthly Expenditure",
                    type: .expenses,
                    posOrNeg: .negative,
                    quantity: monthlyExpenditure
                )
            )
            
            // School fees charges
            for childIndex in 0..<childrenCopy.count {
                charges.append(
                    Transaction(
                        title: "School Fees for Child \(childIndex + 1)",
                        type: .schoolFees,
                        posOrNeg: .negative,
                        quantity: Child.feesForChild(childrenCopy[childIndex]),
                        description: "Your child has to go school, doesn't he?\nThe school fees progressively increment as you child grows older. You are charged for school fees for a child until said child moves out when he's 25."
                    )
                )
            }
        }
        
        return charges
    }
    
    static func salaryWithGrowthRateBonus(principalSalaryInThousands: Double, careerGrowthRatePercentage: Int, forYears years: Int) -> Double {
        let principal = principalSalaryInThousands * 1000
        let result = principal * Double(truncating: pow(Decimal(1 + careerGrowthRatePercentage / 100), years) as NSNumber)
        
        return result
    }
}
