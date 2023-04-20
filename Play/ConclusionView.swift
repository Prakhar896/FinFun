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
                    .padding(.bottom, 30)
                Text("Thanks for playing!")
                    .font(.title2)
            }
            .padding(.bottom, 50)
            
            Text("I hope you enjoyed playing this little game of mine! It took a lot of effort but I think the final product is actuallly quite fun. I hope you shared the same opinion.\n\nUntil next time!")
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            Spacer()
            Button {
                pageShowing = .title
            } label: {
                Text("Go Back")
                    .foregroundColor(.accentColor)
                    .padding(20)
            }
            .background(Color.accentColor.opacity(0.2))
            .cornerRadius(20)
            Spacer()
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
