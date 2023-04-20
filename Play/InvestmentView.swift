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
    
    var yearsLeftTillPolicyExpiry: Int? {
        if gameState.insuranceManager.policyPurchased {
            var realTimeDurationToExpiry = (gameState.insuranceManager.policyExpiryTimestamp ?? 120.0) - gameState.realTimeElapsed
            var fakeSeconds = GameState.timeLeftDeductionRatePerPointOneSecond(gameDuration: GameState.defaultGameDuration) * realTimeDurationToExpiry
            var fakeYears = fakeSeconds / Double(GameState.secondsInAYear)
            return Int(fakeYears.rounded(.down))
        } else {
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            List {
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
            }
            .navigationTitle("Finance Options")
        }
        .sheet(isPresented: $insurancePopupShowing, content: {
            InsuranceInvestmentView(gameState: gameState, insuranceInvestmentViewIsPresenting: $insurancePopupShowing)
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
