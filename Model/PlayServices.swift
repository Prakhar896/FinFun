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

struct LifeEvent {
    var title: String
    var targetParty: TargetParty
    var occursAt: Double // the timestamp at which it occurs (real time)
    var cost: Int
    
    var occurred: Bool = false
    var description: String? = nil
    
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
                    targetParty: party,
                    occursAt: LifeEvent.safelyGenerateNewRandomTimestamp(generatedEvents: tempEvents),
                    cost: LifeEvent.costForEvent(withEventType: event)
                )
            )
        }
        
        self.lifeEvents = tempEvents
    }
    
    func checkForCharges(realTimeElapsed: Double, timeLeft: Double) -> [Transaction] {
        // Run every 0.1 seconds
        var charges: [Transaction] = []
        
        // Issue salary
        
        
        
        
        return charges
    }
}
