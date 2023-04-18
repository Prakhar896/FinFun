//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 18/4/23.
//

import SwiftUI

struct PlayHomeView: View {
    @StateObject var gameState: GameState
    
    @State var showingIntro: Bool = true
    
    var body: some View {
        ZStack {
            switch showingIntro {
            case true:
                HomeIntroView(userProfile: gameState.userGameProfile, showingIntro: $showingIntro)
            case false:
                Text("Let the games begin.")
            }
        }
            .navigationTitle("Play")
            .navigationBarBackButtonHidden()
    }
}

struct PlayHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PlayHomeView(gameState: GameState(userGameProfile: GameProfile.blankGameProfile(), balance: 0.0, timeLeft: GameState.defaultTimeLimit, realTimeElapsed: 0.0))
    }
}
