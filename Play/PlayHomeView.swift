//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 18/4/23.
//

import SwiftUI

struct PlayHomeView: View {
    @StateObject var gameState: GameState
    
    var body: some View {
        Text(gameState.timeLeftReadable)
    }
}

struct PlayHomeView_Previews: PreviewProvider {
    static var previews: some View {
        PlayHomeView(gameState: GameState(userGameProfile: GameProfile.blankGameProfile(), balance: 0.0, timeLeft: GameState.defaultTimeLimit, realTimeElapsed: 0.0))
    }
}
