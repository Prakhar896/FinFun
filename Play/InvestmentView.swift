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
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    InvestmentOptionView(optionTitle: "Insurance", optionDescription: "A risk management scheme that you can use to protect yourself from expensive life event payments.") {
                        insurancePopupShowing = true
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .sheet(isPresented: $insurancePopupShowing, content: {
                InsuranceInvestmentView(gameState: gameState, insuranceInvestmentViewIsPresenting: $insurancePopupShowing)
            })
            .navigationTitle("Finance Options")
        }
    }
}

@available(iOS 16, *)
struct InvestmentView_Previews: PreviewProvider {
    static var previews: some View {
        InvestmentView(gameState: GameState(userGameProfile: GameProfile.blankGameProfile(), balance: 10000.0, timeLeft: GameState.defaultTimeLimit, realTimeElapsed: 60.0))
    }
}
