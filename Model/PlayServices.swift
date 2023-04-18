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

class LifeEvent {
    var title: String
    var type: EventType
    var targetParty: TargetParty
    var occursAt: Double // the timestamp at which it occurs (real time)
    var cost: Int
    
    @Published var occurred: Bool = false
    var description: String? = nil
    
    init(title: String, type: EventType, targetParty: TargetParty, occursAt: Double, cost: Int, occurred: Bool = false, description: String? = nil) {
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
        
        var newTimeStamp = Double.random(in: 20.0...115.0)
        
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
    @Published var children: [Child] // age of children can change with time
    //    var lifeEvents: [LifeEvent]
    
    init(salaryInThousands: Int, monthlyExpenditure: Double, children: [Child]) {
        self.salaryInThousands = salaryInThousands
        self.monthlyExpenditure = monthlyExpenditure
        self.children = children
    }
    
    func checkForCharges(realTimeElapsed: Double) -> [Transaction] {
        // Run every 0.1 seconds
        var charges: [Transaction] = []
        
        // Issue monthly charges
        if realTimeElapsed.remainder(dividingBy: 2) == 0 {
            // Salary charge
            charges.append(
                Transaction(
                    title: "Monthly Salary",
                    type: .salary,
                    posOrNeg: .positive,
                    quantity: Double(salaryInThousands * 10000)
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
            for childIndex in 0..<children.count {
                charges.append(
                    Transaction(
                        title: "School Fees for Child \(childIndex)",
                        type: .schoolFees,
                        posOrNeg: .negative,
                        quantity: Child.feesForChild(children[childIndex])
                    )
                )
            }
        }
        
        return charges
    }
}
