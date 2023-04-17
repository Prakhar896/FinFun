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

struct Child: Identifiable {
    var id = UUID()
    var age: Int
    
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
}

enum PositiveOrNegative {
    case positive, negative
}

struct Transaction {
    var title: String
    var type: TransactionType
    var posOrNeg: PositiveOrNegative
    var quantity: Double
    var description: String? = nil
}

struct GameState {
    var userGameProfile: GameProfile
    var balance: Double
    var timeLeft: Double // this is in seconds
    var realTimeElapsed: Double
    
    var timeLeftReadable: String {
        let secondsInAYear = 365 * 24 * 60 * 60
        let secondsInAMonth = 30.42 * 24 * 60 * 60
        
        let years = Int(floor(timeLeft / Double(secondsInAYear)))
        let months = Int(floor((timeLeft - Double(years * secondsInAYear)) / (secondsInAMonth)))
        
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
    
    static let defaultTimeLimit: Double = 50 * 365 * 24 * 60 * 60
}
