//
//  InvestmentView.swift
//  
//
//  Created by Prakhar Trivedi on 20/4/23.
//

import SwiftUI

@available(iOS 16, *)
struct InvestmentView: View {
    @ObservedObject var gameState: GameState
    
    @State var insurancePopupShowing: Bool = false
    @State var fdPopupShowing: Bool = false
    @State var stocksPopupShowing: Bool = false
    
    var yearsLeftTillPolicyExpiry: Int? {
        if gameState.insuranceManager.policyPurchased {
            let realTimeDurationToExpiry = (gameState.insuranceManager.policyExpiryTimestamp ?? 120.0) - gameState.realTimeElapsed
            let fakeSeconds = GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration) * realTimeDurationToExpiry
            let fakeYears = fakeSeconds / Double(GameState.secondsInAYear)
            return Int(fakeYears.rounded(.down))
        } else {
            return nil
        }
    }
    
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
    
    var stocksPurchased: String {
        var stocks: [String] = []
        if gameState.stockManager.iago.purchased {
            stocks.append(StockOptions.iago.rawValue)
        }
        if gameState.stockManager.aladdin.purchased {
            stocks.append(StockOptions.aladdin.rawValue)
        }
        
        if stocks == [] {
            return "None"
        } else {
            return stocks.joined(separator: ", ")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // Insurance
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Insurance")
                                .font(.title.weight(.heavy))
                            if gameState.insuranceManager.policyPurchased {
                                Text("\(yearsLeftTillPolicyExpiry ?? 0) Years Left Till Policy Expiry")
                                    .font(.subheadline)
                            }
                        
                            Text("A risk management scheme that you can use to protect yourself from expensive life event payments.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack {
                            Button {
                                // action code
                                insurancePopupShowing = true
                            } label: {
                                Text(gameState.insuranceManager.policyPurchased ? "Invested": "Invest")
                                    .bold()
                                    .foregroundColor(gameState.insuranceManager.policyPurchased ? .secondary: .accentColor)
                                    .padding(10)
                            }
                            .background(gameState.insuranceManager.policyPurchased ? Color.green.opacity(0.2): Color.accentColor.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .disabled(gameState.insuranceManager.policyPurchased)
                            
                            if gameState.insuranceManager.policyPurchased {
                                Button {
                                    // cancel policy
                                    withAnimation {
                                        gameState.insuranceManager.expirePolicy()
                                    }
                                } label: {
                                    Text("Cancel Policy")
                                        .font(.system(size: 15))
                                        .foregroundColor(.red)
                                        .padding()
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                // Fixed Deposits
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Fixed Deposits")
                                .font(.title.weight(.heavy))
                            if gameState.fdManager.fdPurchased {
                                Text("\(yearsLeftTillFDExpiry ?? 0) Years Left Till Policy Expiry")
                                    .font(.subheadline)
                            }
                        
                            Text("Allows you to make a long-term deposit with higher annual interest rates compared to savings accounts.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button {
                            // action code
                            fdPopupShowing = true
                        } label: {
                            Text("Manage")
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
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                // Stocks
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Stocks")
                                .font(.title.weight(.heavy))
                            Text("Stocks Purchased: \(stocksPurchased)")
                                .font(.subheadline)
                        
                            Text("Invest in the global market for a chance to share in the profit of company's growth by buying shares of their company.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button {
                            // action code
                            stocksPopupShowing = true
                        } label: {
                            Text("Manage")
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
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationTitle("Finance Options")
        }
        .sheet(isPresented: $insurancePopupShowing, content: {
            InsuranceInvestmentView(gameState: gameState, insuranceInvestmentViewIsPresenting: $insurancePopupShowing)
        })
        .sheet(isPresented: $fdPopupShowing, content: {
            FDInvestmentView(gameState: gameState, fdPopupShowing: $fdPopupShowing)
        })
        .sheet(isPresented: $stocksPopupShowing, content: {
            StockInvestmentView(gameState: gameState, stockPopupShowing: $stocksPopupShowing)
        })
        .navigationTitle("Finance Options")
    }
}

@available(iOS 16, *)
struct InvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentView(gameState: GameState(userGameProfile: GameProfile.blankGameProfile(), balance: 10000.0, timeLeft: GameState.defaultTimeLimit, realTimeElapsed: 60.0))
    }
}
