//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 20/4/23.
//

import SwiftUI

@available(iOS 16, *)
struct ConclusionView: View {
    @ObservedObject var gameState: GameState
    @Binding var pageShowing: PageIdentifier
    
    @State var won: Bool = false
    @State var winLoseText: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("You " + winLoseText)
                    .font(.largeTitle)
                    .foregroundColor(won ? .green: .red)
                Text("Thanks for playing!")
                    .font(.title)
            }
            
            Spacer()
            Button {
                pageShowing = .title
            } label: {
                Text("Go back")
                    .foregroundColor(.accentColor)
                    .padding(20)
            }
            .background(Color.accentColor.opacity(0.2))
            .cornerRadius(20)
        }
        .onAppear {
            let result = WinCalculator.calculateWin(gameState: gameState)
            winLoseText = result
            if result == "WON!" {
                won = true
            }
        }
    }
}

@available(iOS 16, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ConclusionView(gameState: GameState(userGameProfile: .blankGameProfile(), balance: 0.0, timeLeft: 0.0, realTimeElapsed: 0.0), pageShowing: .constant(.play))
    }
}
