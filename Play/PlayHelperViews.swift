//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 19/4/23.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    
    var amountText: String {
        var final = ""
        
        if transaction.posOrNeg == .positive {
            final += "+"
        } else {
            final += "-"
        }
        
        final += String(transaction.quantity.rounded())
        
        return final
    }
    
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                Image(systemName: Transaction.imageName(forTransactionType: transaction.type))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text(transaction.title)
                    .font(.system(size: 18).bold())
            }
            
            Spacer()
            
            Text(amountText)
                .foregroundColor(transaction.posOrNeg == .positive ? .green: .red)
                .font(.system(size: 18).bold())
        }
        .padding(5)
        .onTapGesture {
            alertTitle = "\(transaction.title) (\(amountText))"
            alertMessage = transaction.description ?? "Looks like there's no description for this transaction. You gotta remember to keep your receipts!"
            showingAlert = true
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
        
    }
}

@available(iOS 16, *)
struct LifeEventView: View {
    var lifeEvent: LifeEvent
    
    var insuranceText: String {
        if lifeEvent.coveredByInsurance {
            return " (Covered by Insurance)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                Image(systemName: lifeEvent.type == .accident ? "exclamationmark.triangle": "cross.case")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("\(lifeEvent.title) experienced by \(lifeEvent.targetParty.rawValue.lowercased())" + insuranceText)
                    .font(.system(size: 17).bold())
            }
            
            Spacer()
            
            Text(lifeEvent.cost.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                .foregroundColor(lifeEvent.coveredByInsurance ? .yellow: .red)
                .font(.system(size: 17).bold())
        }
        .padding(5)
    }
}

struct InvestmentOptionView: View {
    var optionTitle: String
    var optionDescription: String
    var actionCode: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(optionTitle)
                    .font(.title.weight(.heavy))
                Text(optionDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                actionCode()
            } label: {
                Text("Invest")
                    .bold()
                    .foregroundColor(.accentColor)
                    .padding(10)
            }
            .background(Color.accentColor.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(20)
        .background(.ultraThinMaterial)
    }
}

@available(iOS 16, *)
struct InsuranceInvestmentView: View {
    @ObservedObject var gameState: GameState
    @Binding var insuranceInvestmentViewIsPresenting: Bool
    
    @State var policyLifeTime: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("\(policyLifeTime) Years")
                        Spacer()
                        Stepper("Change policy lifetime span", value: $policyLifeTime, in: 0...50)
                            .labelsHidden()
                    }
                    .padding()
                } header: {
                    Text("Policy Lifetime")
                }
                
                Section {
                    HStack {
                        Text("Calculated Monthly Premium:")
                        Spacer()
                        Text(InsuranceManager.calcPremiumFor(timeLeftSeconds: gameState.timeLeft, forYears: policyLifeTime).formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                            .bold()
                    }
                    .padding()
                } footer: {
                    Text("Tip: The calculated premium above varies based on the current time left in the game and the chosen lifetime of the policy.")
                }
                
                Section {
                    Button {
                        // purchase policy
                        gameState.insuranceManager.purchasePolicy(timeLeftSeconds: gameState.timeLeft, forYears: policyLifeTime, realTimeElapsed: gameState.realTimeElapsed)
                        insuranceInvestmentViewIsPresenting = false
                    } label: {
                        Text("Purchase Policy")
                            .bold()
                            .foregroundColor(.accentColor)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .background(Color.accentColor.opacity(0.2))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .disabled(policyLifeTime == 0)
                }
            }
            .navigationTitle("Invest: Insurance Policy")
        }
    }
}


@available(iOS 16, *)
struct FDInvestmentView: View {
    @ObservedObject var gameState: GameState
    @Binding var fdPopupShowing: Bool
    
    @FocusState var principalIsFocused: Bool
    
    @State var amount: Double = 5000.0
    @State var years: Int = 2
    @State var breakFDAlertPresented = false
    
    var yearsLeftTillFDExpiry: Int? {
        if gameState.fdManager.fdPurchased {
            let realTimeDurationToExpiry = (gameState.fdManager.fdExpiryTimestamp ?? 120.0) - gameState.realTimeElapsed
            let fakeSeconds = GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration) * realTimeDurationToExpiry
            let fakeYears = fakeSeconds / Double(GameState.secondsInAYear)
            return Int(fakeYears.rounded(.down))
        } else {
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                if !gameState.fdManager.fdPurchased {
                    Section {
                        // Inital amount
                        HStack {
                            Text("Initial Amount:")
                            TextField("For e.g, $5000", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($principalIsFocused)
                        }
                        .padding()
                        
                        // FD Lifetime
                        HStack {
                            Text("\(years) Years")
                            Spacer()
                            Stepper("Change FD lifetime span", value: $years, in: 2...49)
                                .labelsHidden()
                        }
                        .padding()
                    }
                } else {
                    Section {
                        Text("\(yearsLeftTillFDExpiry ?? 0) Years To Fixed Deposit Expiry")
                            .bold()
                            .padding(20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                    } header: {
                        Text("Current Fixed Deposit Status")
                    }
                }
                
                Section {
                    Button {
                        // purchase policy
                        if !gameState.fdManager.fdPurchased {
                            var initial = gameState.fdManager.purchaseFD(withPrincipal: amount, forYears: years, realTimeElapsed: gameState.realTimeElapsed)
                            withAnimation {
                                gameState.transactions.insert(initial, at: 0)
                                gameState.applyTransactions([initial])
                            }
                            fdPopupShowing = false
                        } else {
                            breakFDAlertPresented = true
                        }
                    } label: {
                        Text(gameState.fdManager.fdPurchased ? "Break Fixed Deposit": "Purchase Fixed Deposit")
                            .bold()
                            .foregroundColor(gameState.fdManager.fdPurchased ? .red: .accentColor)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .background(gameState.fdManager.fdPurchased ? .red.opacity(0.2): Color.accentColor.opacity(0.2))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .navigationTitle("Invest: Fixed Deposits")
            .alert("Break fixed deposit?", isPresented: $breakFDAlertPresented) {
                Button("Cancel", role: .cancel) {}
                
                Button("Break", role: .destructive) {
                    var penalty = gameState.fdManager.breakFD()
                    withAnimation {
                        gameState.transactions.insert(penalty, at: 0)
                        gameState.applyTransactions([penalty])
                    }
                    fdPopupShowing = false
                }
            } message: {
                Text("Are you sure you'd like to break your fixed deposit? Do note that breaking an FD before its maturity date will cause you to incur a penalty fee.")
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            principalIsFocused = true
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 16, *)
struct StockInvestmentView: View {
    @ObservedObject var gameState: GameState
    @Binding var stockPopupShowing: Bool
    
    @State var alertType: StockOptions = .iago
    @State var alertPresented = false
    @State var numShares: Int = 0
    
    var totalCost: Double {
        if alertType == .iago {
            return Double(numShares) * Stock.stockPriceWithRateApplied(gameState.stockManager.iago.currentTrendRate, stockPrice: gameState.stockManager.iago.sharePrice)
        } else {
            return Double(numShares) * Stock.stockPriceWithRateApplied(gameState.stockManager.aladdin.currentTrendRate, stockPrice: gameState.stockManager.aladdin.sharePrice)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // Iago
                Section {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(StockOptions.iago.rawValue)
                                .font(.title2.weight(.heavy))
                            if gameState.stockManager.iago.purchased {
                                Text("\(gameState.stockManager.iago.numShares ?? 0) Shares Purchased")
                                    .font(.subheadline)
                            }
                            Text(gameState.stockManager.iago.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Image(systemName: gameState.stockManager.iago.currentTrend == .upwards ? "arrowtriangle.up.fill": "arrowtriangle.down.fill")
                            Text("\(gameState.stockManager.iago.currentTrendRate.rounded())")
                                .font(.system(size: 17).bold())
                        }
                        .foregroundColor(gameState.stockManager.iago.currentTrend == .upwards ? .green: .red)
                        
                        Button {
                            // buy/sell shares
                            if gameState.stockManager.iago.purchased {
                                // sell shares
                                let charges = gameState.stockManager.sellShare(ofStock: .iago, realTimeElapsed: gameState.realTimeElapsed)
                                withAnimation {
                                    gameState.transactions.insert(contentsOf: charges, at: 0)
                                    gameState.applyTransactions(charges)
                                }
                            } else {
                                // bring up alert
                                alertType = .iago
                                alertPresented = true
                            }
                        } label: {
                            Text(gameState.stockManager.iago.purchased ? "Sell": "Buy")
                                .foregroundColor(gameState.stockManager.iago.purchased ? .red: .green)
                                .padding(10)
                                .background(gameState.stockManager.iago.purchased ? .red.opacity(0.2): .green.opacity(0.2))
                        }
                        .cornerRadius(10)
                    }
                    .padding()
                }
                
                // Aladdin
                Section {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(StockOptions.aladdin.rawValue)
                                .font(.title2.weight(.heavy))
                            if gameState.stockManager.aladdin.purchased {
                                Text("\(gameState.stockManager.aladdin.numShares ?? 0) Shares Purchased")
                                    .font(.subheadline)
                            }
                            Text(gameState.stockManager.aladdin.description)
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Image(systemName: gameState.stockManager.aladdin.currentTrend == .upwards ? "arrowtriangle.up.fill": "arrowtriangle.down.fill")
                            Text("\(gameState.stockManager.aladdin.currentTrendRate.rounded())")
                                .font(.system(size: 17).bold())
                        }
                        .foregroundColor(gameState.stockManager.aladdin.currentTrend == .upwards ? .green: .red)
                        
                        Button {
                            // buy/sell shares
                            if gameState.stockManager.aladdin.purchased {
                                // sell shares
                                let charges = gameState.stockManager.sellShare(ofStock: .aladdin, realTimeElapsed: gameState.realTimeElapsed)
                                withAnimation {
                                    gameState.transactions.insert(contentsOf: charges, at: 0)
                                    gameState.applyTransactions(charges)
                                }
                            } else {
                                // bring up alert
                                alertType = .aladdin
                                alertPresented = true
                            }
                        } label: {
                            Text(gameState.stockManager.aladdin.purchased ? "Sell": "Buy")
                                .foregroundColor(gameState.stockManager.aladdin.purchased ? .red: .green)
                                .padding(10)
                                .background(gameState.stockManager.aladdin.purchased ? .red.opacity(0.2): .green.opacity(0.2))
                        }
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Invest: Stocks")
            .alert("Buy \(alertType.rawValue)", isPresented: $alertPresented) {
                TextField("Number of shares", value: $numShares, format: .number)
                Button("Cancel", role: .cancel) {}
                
                Button("Buy") {
                    // actually buy shares
                    if alertType == .iago {
                        let charges = gameState.stockManager.purchaseShare(ofStock: .iago, numShares: numShares, realTimeElapsed: gameState.realTimeElapsed)
                        withAnimation {
                            gameState.transactions.insert(contentsOf: charges, at: 0)
                            gameState.applyTransactions(charges)
                        }
                    } else {
                        let charges = gameState.stockManager.purchaseShare(ofStock: .aladdin, numShares: numShares, realTimeElapsed: gameState.realTimeElapsed)
                        withAnimation {
                            gameState.transactions.insert(contentsOf: charges, at: 0)
                            gameState.applyTransactions(charges)
                        }
                    }
                }
            } message: {
                Text("You are now buying shares of \(alertType.rawValue). Enter the number of shares you would like to buy.\n\nTotal Cost: \(totalCost.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))")
            }

        }
    }
}
