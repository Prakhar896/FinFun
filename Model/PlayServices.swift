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
    var coveredByInsurance: Bool = false
    
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
            return [10000, 12000, 14000, 16000, 18000, 20000].randomElement()!
        } else if type == .medical {
            return [30000, 35000, 40000, 45000, 50000, 55000].randomElement()!
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

@available(iOS 16, *)
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
        let realRealTimeElapsed = realTimeElapsed * 10
        if realRealTimeElapsed.remainder(dividingBy: 2) <= 0 {
            let yearsPassed = Int((realTimeElapsed * (GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration) / Double(GameState.secondsInAYear))).rounded(.down))
            
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
                        description: "Your child has to go to school, doesn't he?\n\nThe school fees progressively increment as you child grows older. You are charged for school fees for a child until said child moves out when he's 25."
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

@available(iOS 16, *)
class InsuranceManager {
    @Published var policyPurchased: Bool = false
    @Published var monthlyPremium: Double? = nil
    @Published var policyExpiryTimestamp: Double? = nil
    
    var payouts: [String] = []
    
    init() {
        self.policyPurchased = false
        self.monthlyPremium = nil
        self.policyExpiryTimestamp = nil
    }
    
    /// Returns a monthly premium amount required to pay for the policy.
    func purchasePolicy(timeLeftSeconds: Double, forYears years: Int, realTimeElapsed: Double) -> Double {
        let premiumCost = InsuranceManager.calcPremiumFor(timeLeftSeconds: timeLeftSeconds, forYears: years)
        
        // update manager
        policyPurchased = true
        monthlyPremium = premiumCost
        policyExpiryTimestamp = realTimeElapsed + (Double(years * GameState.secondsInAYear) / GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration))
        
        return premiumCost
    }
    
    func checkForCharges(realTimeElapsed: Double) -> [Transaction] {
        var charges: [Transaction] = []
        
        if policyPurchased {
            if (policyExpiryTimestamp ?? GameState.defaultGameDuration) <= realTimeElapsed {
                // expire the insurance policy
                policyPurchased = false
                monthlyPremium = nil
                policyExpiryTimestamp = nil
            } else {
                // charge monthly premiums
                let realRealTimeElapsed = realTimeElapsed * 10
                if realRealTimeElapsed.remainder(dividingBy: 2) <= 0 {
                    charges.append(
                        Transaction(
                            title: "Insurance Premium",
                            type: .insurance,
                            posOrNeg: .negative,
                            quantity: monthlyPremium ?? 0.0,
                            description: "You are charged for your purchased insurance policy monthly with the agreed upon premium amount until the insurance policy expires."
                        )
                    )
                }
            }
        }
        
        return charges
    }
    
    func expirePolicy() {
        policyPurchased = false
        monthlyPremium = nil
        policyExpiryTimestamp = nil
    }
    
    func requestInsurancePayout(forLifeEvent lifeEvent: LifeEvent) -> Bool {
        if policyPurchased {
            payouts.append("\(lifeEvent.cost.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))) \(lifeEvent.title) experienced by \(lifeEvent.targetParty.rawValue.lowercased()).")
            return true
        } else {
            return false
        }
    }
    
    static func calcPremiumFor(timeLeftSeconds: Double, forYears years: Int) -> Double {
        let yearsLeft = Int((timeLeftSeconds / Double(GameState.secondsInAYear)).rounded(.down))
        
        var premiumCost = 0.0
        
        if years > 40 {
            premiumCost += 100
        } else if years > 25 {
            premiumCost += 600
        } else if years > 5 {
            premiumCost += 1000
        }
        if yearsLeft > 45 {
            premiumCost += 300
        } else if yearsLeft > 25 {
            premiumCost += 1000
        } else {
            premiumCost += 1500
        }
        
        return premiumCost
    }
}

@available(iOS 16, *)
class FDManager {
    @Published var fdPurchased = false
    @Published var fdExpiryTimestamp: Double? = nil
    @Published var fdAmount: Double? = nil
    @Published var fdInterestRate: Int? = nil
    
    init() {
        self.fdPurchased = false
        self.fdExpiryTimestamp = nil
        self.fdAmount = nil
        self.fdInterestRate = nil
    }
    
    func purchaseFD(withPrincipal principal: Double, forYears years: Int, realTimeElapsed: Double) -> Transaction {
        fdPurchased = true
        fdExpiryTimestamp = realTimeElapsed + (Double(years * GameState.secondsInAYear) / GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration))
        fdAmount = principal
        fdInterestRate = FDManager.rateForFD(withPrincipal: principal, forYears: years)
        
        return Transaction(
            title: "Fixed Deposit: Initial Amount",
            type: .fd,
            posOrNeg: .negative,
            quantity: principal,
            description: "You purchased a Fixed Deposit with a principal amount of \(principal.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))) for \(years) years. This is the charge on your balance for the initial amount."
        )
    }
    
    func breakFD() -> Transaction {
        var penaltyFee: Double = 0.0
        
        if (fdAmount ?? 0.0) > 150000 {
            penaltyFee = 100000
        } else if (fdAmount ?? 0.0) > 100000 {
            penaltyFee = 80000
        } else {
            penaltyFee = 15000
        }
        
        return Transaction(
            title: "Fixed Deposit: FD Break Penalty Fee",
            type: .fd,
            posOrNeg: .negative,
            quantity: penaltyFee,
            description: "You recently broke your FD. Breaking FDs cuase you to incur a penalty fee for breaking the fixed deposit before its maturity date."
        )
    }
    
    func checkForCharges(realTimeElapsed: Double) -> [Transaction] {
        var charges: [Transaction] = []
        
        if fdPurchased {
            if (fdExpiryTimestamp ?? 0.0) <= realTimeElapsed {
                // expire fixed deposit and return profited money
                fdPurchased = false
                fdExpiryTimestamp = nil
                fdInterestRate = nil
                
                let amount = fdAmount ?? 0.0
                fdAmount = nil
                charges.append(
                    Transaction(
                        title: "Fixed Deposit: End of Deposit Payout",
                        type: .fd,
                        posOrNeg: .positive,
                        quantity: amount,
                        description: "Your FD closed and you got your hard-grown money back into your balance! Congratulations!"
                    )
                )
            } else {
                // check if year has passed
                let realRealTimeElapsed = realTimeElapsed * 10
                if realRealTimeElapsed.remainder(dividingBy: 24) == 0 {
                    // one year passed
                    fdAmount = Double(((100 + fdInterestRate!) / 100)) * fdAmount!
                }
            }
        }
        
        return charges
    }
    
    
    static func rateForFD(withPrincipal principal: Double, forYears years: Int) -> Int {
        if principal > 150000 {
            return 12
        } else if principal > 100000 {
            return 9
        } else if principal > 50000 {
            return 6
        } else if principal > 10000 {
            return 4
        } else {
            return 2
        }
    }
}

enum StockTrend {
    case upwards, downwards
}

enum StockOptions: String {
    case iago = "Iago Inc.", aladdin = "Aladdin Co."
}

class Stock {
    var name: String
    var description: String
    var sharePrice: Double
    @Published var currentTrend: StockTrend
    @Published var currentTrendRate: Double
    @Published var purchased: Bool = false
    @Published var numShares: Int? = nil
    
    init(name: String, description: String, sharePrice: Double, realTimeElapsed: Double) {
        self.name = name
        self.description = description
        self.sharePrice = sharePrice
        
        let trendRate = Stock.trendForTimeElapsed(realTimeElapsed, stockName: name)
        if trendRate < 0 {
            self.currentTrend = .downwards
        } else {
            self.currentTrend = .upwards
        }
        
        self.currentTrendRate = abs(trendRate)
    }
    
    func refreshTrend(realTimeElapsed: Double, stockName: String) {
        let trendRate = Stock.trendForTimeElapsed(realTimeElapsed, stockName: stockName)
        if trendRate < 0 {
            currentTrend = .downwards
        } else {
            currentTrend = .upwards
        }
        
        currentTrendRate = abs(trendRate)
    }
    
    static func trendForTimeElapsed(_ timeElapsed: Double, stockName stock: String) -> Double {
        if stock == StockOptions.iago.rawValue {
            if timeElapsed < 20 {
                return 2.4
            } else if timeElapsed < 40 {
                return 5.6
            } else if timeElapsed < 60 {
                return 5
            } else if timeElapsed < 100 {
                return 7
            } else {
                return -3.7
            }
        } else if stock == StockOptions.aladdin.rawValue {
            if timeElapsed < 20 {
                return -3.5
            } else if timeElapsed < 40 {
                return -1.2
            } else if timeElapsed < 60 {
                return 2.8
            } else if timeElapsed < 80 {
                return 4.8
            } else if timeElapsed < 110 {
                return 7.6
            } else {
                return 3.6
            }
        } else {
            return 0
        }
    }
    
    static func stockPriceWithRateApplied(_ rate: Double, stockPrice: Double) -> Double {
        return ((100 + rate) / 100) * stockPrice
    }
}

class StockManager {
    @Published var iago: Stock
    @Published var aladdin: Stock
    
    init(realTimeElapsed: Double) {
        iago = Stock(name: StockOptions.iago.rawValue, description: "A multi-conglomerate artifical intelligence provider that powers government and corporate technologies worldwide, from ordering food to banking.", sharePrice: 3500, realTimeElapsed: realTimeElapsed)
        aladdin = Stock(name: StockOptions.aladdin.rawValue, description: "A popular fitness e-commerce website in the United States that sells high quality fitness products marketed as luxury products in 2080.", sharePrice: 2800, realTimeElapsed: realTimeElapsed)
    }
    
    func purchaseShare(ofStock stock: StockOptions, numShares: Int, realTimeElapsed: Double) -> [Transaction] {
        var charges: [Transaction] = []
        
        iago.refreshTrend(realTimeElapsed: realTimeElapsed, stockName: stock.rawValue)
        aladdin.refreshTrend(realTimeElapsed: realTimeElapsed, stockName: stock.rawValue)
        
        if stock == .iago {
            iago.purchased = true
            iago.numShares = numShares
            
            let amountDue = Stock.stockPriceWithRateApplied(iago.currentTrendRate, stockPrice: iago.sharePrice) * Double(numShares)
            charges.append(
                Transaction(
                    title: "Stock Purchase: \(stock.rawValue)",
                    type: .stocks,
                    posOrNeg: .negative,
                    quantity: amountDue,
                    description: "You purchased \(numShares) shares of \(stock.rawValue) recently."
                )
            )
        } else {
            aladdin.purchased = true
            aladdin.numShares = numShares
            
            let amountDue = Stock.stockPriceWithRateApplied(aladdin.currentTrendRate, stockPrice: aladdin.sharePrice) * Double(numShares)
            charges.append(
                Transaction(
                    title: "Stock Purchase: \(stock.rawValue)",
                    type: .stocks,
                    posOrNeg: .negative,
                    quantity: amountDue,
                    description: "You purchased \(numShares) shares of \(stock.rawValue) recently."
                )
            )
        }
        
        return charges
    }
    
    func sellShare(ofStock stock: StockOptions, realTimeElapsed: Double) -> [Transaction] {
        var charges: [Transaction] = []
        
        iago.refreshTrend(realTimeElapsed: realTimeElapsed, stockName: stock.rawValue)
        aladdin.refreshTrend(realTimeElapsed: realTimeElapsed, stockName: stock.rawValue)
        
        if stock == .iago {
            let moneyBack = Stock.stockPriceWithRateApplied(iago.currentTrendRate, stockPrice: iago.sharePrice) * Double(iago.numShares ?? 1)
            charges.append(
                Transaction(
                    title: "Stock Sell: \(stock.rawValue)",
                    type: .stocks,
                    posOrNeg: .positive,
                    quantity: moneyBack,
                    description: "You sold \(iago.numShares ?? 1) shares of \(stock.rawValue) recently."
                )
            )
            
            iago.purchased = false
            iago.numShares = nil
        } else {
            let amountDue = Stock.stockPriceWithRateApplied(aladdin.currentTrendRate, stockPrice: aladdin.sharePrice) * Double(aladdin.numShares ?? 1)
            charges.append(
                Transaction(
                    title: "Stock Sell: \(stock.rawValue)",
                    type: .stocks,
                    posOrNeg: .positive,
                    quantity: amountDue,
                    description: "You sold \(aladdin.numShares ?? 1) shares of \(stock.rawValue) recently."
                )
            )
            
            aladdin.purchased = false
            aladdin.numShares = nil
        }
        
        return charges
    }
    
    func refreshTrends(realTimeElapsed: Double) {
        let iagoTrend = Stock.trendForTimeElapsed(realTimeElapsed, stockName: StockOptions.iago.rawValue)
        iago.currentTrend = iagoTrend < 0 ? .downwards: .upwards
        iago.currentTrendRate = abs(iagoTrend)
        
        let aladdinTrend = Stock.trendForTimeElapsed(realTimeElapsed, stockName: StockOptions.aladdin.rawValue)
        aladdin.currentTrend = aladdinTrend < 0 ? .downwards: .upwards
        iago.currentTrendRate = abs(aladdinTrend)
    }
}
