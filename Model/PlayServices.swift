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
        
        while true {
            var newTimeStamp = Double.random(in: 20.0...115.0)
            
            var passedCheck = true
            for timestamp in timestamps {
                if newTimeStamp < (timestamp - 10) && newTimeStamp > (timestamp + 10) {
                    // check against other timestamps as well
                    continue
                } else {
                    passedCheck = false
                }
            }
            
            if passedCheck {
                return newTimeStamp
            }
        }
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
}

struct LifeManager {
    var salaryInThousands: Int
    var monthlyExpenditure: Double
    var children: [Child]
    var lifeEvents: [LifeEvent]
    
    init(salaryInThousands: Int, monthlyExpenditure: Double, children: [Child]) {
        self.salaryInThousands = salaryInThousands
        self.monthlyExpenditure = monthlyExpenditure
        self.children = children
        
        // Randomise and set-up 3 life events
        let eventTypes: [EventType] = [.accident, .medical]
        let targetTypes: [TargetParty] = [.player, .child]
        
        var tempEvents: [LifeEvent] = []
        
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
        
        self.lifeEvents = tempEvents
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
        
        // Check if any life events occur
        for eventIndex in 0..<lifeEvents.count {
            if !lifeEvents[eventIndex].occurred {
                if lifeEvents[eventIndex].occursAt < realTimeElapsed {
                    // Set life event has occurred to true
//                    lifeEvents[eventIndex].occurred = true
                    
                    charges.append(
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
        
        return charges
    }
}
