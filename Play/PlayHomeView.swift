//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 18/4/23.
//

import SwiftUI

@available(iOS 16, *)
struct PlayHomeView: View {
    @StateObject var gameState: GameState
    
    @State var showingIntro: Bool = false {
        didSet {
            // trigger the start of timer because intro has stopped showing and game has begun
            if showingIntro == false {
                updateTimer("start")
            }
        }
    }
    @State var viewReloader = 0
    @State var isPaused: Bool = false
    
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // Alert properties
    @State var alertIsPresented: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    
    // Sheets
    @State var optionsSheetIsPresented = false
    @State var allTransactionsSheetIsPresented = false
    
    var occurredLifeEvents: [LifeEvent] {
        var events: [LifeEvent] = []
        for lifeEvent in gameState.lifeEvents {
            if lifeEvent.occurred {
                events.append(lifeEvent)
            }
        }
        
        events = events.sorted(by: { $0.occursAt > $1.occursAt })
        
        return events
    }
    
    var totalIncome: Double {
        var total = 0.0
        for transaction in gameState.transactions {
            if transaction.type == .salary {
                total += transaction.quantity
            }
        }
        return total
    }
    
    var totalExpenditure: Double {
        var total = 0.0
        for transaction in gameState.transactions {
            if transaction.type == .expenses {
                total += transaction.quantity
            }
        }
        return total
    }
    
    var totalSchoolFees: Double? {
        if gameState.userGameProfile.children.isEmpty {
            return nil
        } else {
            var total = 0.0
            for transaction in gameState.transactions {
                if transaction.type == .schoolFees {
                    total += transaction.quantity
                }
            }
            return total
        }
    }
    
    var totalPremium: Double? {
        if gameState.insuranceManager.policyPurchased {
            var total = 0.0
            for transaction in gameState.transactions {
                if transaction.type == .insurance {
                    total += transaction.quantity
                }
            }
            return total
        } else {
            return nil
        }
    }
    
    var body: some View {
        ZStack {
            switch showingIntro {
            case true:
                HomeIntroView(userProfile: gameState.userGameProfile, showingIntro: $showingIntro)
            case false:
                List {
                    Section {
                        // Time Left Row
                        HStack {
                            Text("Time Left:")
                                .font(.system(size: 17))
                                .padding(.leading)
                            Text(gameState.timeLeftReadable)
                                .font(.system(size: 20).bold())
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                        
                        // Cash Balance Row
                        HStack {
                            Text("Cash Balance:")
                                .font(.system(size: 17))
                                .padding(.leading)
                            Text(gameState.balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.system(size: 20).bold())
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                    } header: {
                        Text("Current Status")
                    }
                    
                    // Life Events
                    Section {
                        if occurredLifeEvents.isEmpty {
                            Text("No life events have occurred yet. When they occur, they will appear here.")
                                .font(.headline.bold())
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .multilineTextAlignment(.center)
                        } else {
                            ForEach(occurredLifeEvents) { event in
                                LifeEventView(lifeEvent: event)
                            }
                        }
                    } header: {
                        Text("Life Events")
                    }
                    
                    Section {
                        // Total Income view
                        TransactionView(transaction: Transaction(title: "Total Income", type: .salary, posOrNeg: .positive, quantity: totalIncome, description: "This grouped transaction summarises the total amount of money you have made from your monthly salary."))
                        
                        // Total Expenditure View
                        TransactionView(transaction: Transaction(title: "Total Expenditure", type: .expenses, posOrNeg: .negative, quantity: totalExpenditure, description: "This grouped transaction summarises the total amount of money you have spent in monthly expenditure."))
                        
                        if !gameState.userGameProfile.children.isEmpty {
                            // School fees view
                            TransactionView(transaction: Transaction(title: "Total School Fees", type: .schoolFees, posOrNeg: .negative, quantity: totalSchoolFees ?? 0.0, description: "This grouped transaction summarises the total amount of money you have spent on your children's school fees."))
                        }
                        
                        if gameState.insuranceManager.policyPurchased {
                            // Insurance Premium view
                            TransactionView(transaction: Transaction(title: "Total Insurance Premium", type: .insurance, posOrNeg: .negative, quantity: totalPremium ?? 0.0, description: "This grouped transaction summarises the total amount of money spent on monthly insurance premiums."))
                        }
                    } header: {
                        Text("Grouped Transactions")
                    } footer: {
                        Button("View All Transactions") {
                            allTransactionsSheetIsPresented = true
                        }
                    }
                    
                    // Transaction history
                    Section {
                        if gameState.transactions.isEmpty {
                            Text("No transactions have occurred yet. When they do occur, they will appear here.")
                                .font(.headline.bold())
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .multilineTextAlignment(.center)
                        } else {
                            ForEach(gameState.transactions.filter({ transaction in
                                return (transaction.type != .salary && transaction.type != .expenses && transaction.type != .schoolFees && transaction.type != .insurance)
                            })) { transaction in
                                TransactionView(transaction: transaction)
                            }
                        }
                    } header: {
                        Text("Ungrouped Transactions")
                    }
                }
                .onReceive(timer) { firedDate in
                    if !isPaused {
                        gameState.unitTimeDidElapse()
                        
                        if gameState.gameEnded {
                            updateTimer("stop")
                            optionsSheetIsPresented = false
                            if gameState.realTimeElapsed >= GameState.defaultGameDuration {
                                // Game ended because of time over
                                alertTitle = "Time's up!"
                                alertMessage = "Looks like your time here is done! Let's see how you did..."
                                alertIsPresented = true
                            } else {
                                // Game ended because of bankruptcy
                                alertTitle = "Looks like you're outta cash!"
                                alertMessage = "Oops! Your cash balance just hit zero, which means you're bankrupt and lost the game! Better luck next time!"
                                alertIsPresented = true
                            }
                        }
                    }
                }
                .alert(alertTitle, isPresented: $alertIsPresented) {
                    Button("Go To Results") {
                        // go to results screen
                    }
                } message: {
                    Text(alertMessage)
                }
                .sheet(isPresented: $optionsSheetIsPresented) {
                    InvestmentView(gameState: gameState)
                }
                .sheet(isPresented: $allTransactionsSheetIsPresented) {
                    NavigationView {
                        List {
                            ForEach(gameState.transactions) { transaction in
                                TransactionView(transaction: transaction)
                            }
                        }
                        .navigationTitle("All Transactions")
                    }
                }
            }
        }
        .navigationTitle("Play")
        .navigationBarBackButtonHidden()
        .onAppear {
            if showingIntro {
                updateTimer("stop")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isPaused.toggle()
                } label: {
                    Image(systemName: isPaused ? "play.fill": "pause.fill")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // segue to finance options screen
                    optionsSheetIsPresented = true
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
                .disabled(isPaused)
            }
        }
    }
    
    func updateTimer(_ option: String) {
        if option == "stop" {
            timer.upstream.connect().cancel()
        } else if option == "start" {
            timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        }
    }
}

@available(iOS 16, *)
struct PlayHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PlayHomeView(gameState: GameState(userGameProfile: GameProfile.blankGameProfile(), balance: 0.0, timeLeft: GameState.defaultTimeLimit, realTimeElapsed: 0.0))
    }
}
