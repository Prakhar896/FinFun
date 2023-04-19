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
    
    var occurredLifeEvents: [LifeEvent] {
        var events: [LifeEvent] = []
        for lifeEvent in gameState.lifeEvents {
            if lifeEvent.occurred {
                events.append(lifeEvent)
            }
        }
        
        return events
    }
    
    var body: some View {
        ZStack {
            switch showingIntro {
            case true:
                HomeIntroView(userProfile: gameState.userGameProfile, showingIntro: $showingIntro)
            case false:
                List {
                    Section {
                        Text(gameState.timeLeftReadable)
                            .font(.system(size: 18).bold())
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                    } header: {
                        Text("Time Left")
                    }
                    
                    Section {
                        if occurredLifeEvents.isEmpty {
                            Text("No life events have occurred yet. When they occur, they will appear here.")
                                .font(.headline.bold())
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .multilineTextAlignment(.center)
                        } else {
                            ForEach(occurredLifeEvents) { event in
                                Text(event.title + " occurred.")
                            }
                        }
                    } header: {
                        Text("Life Events")
                    }
                    
                    Section {
                        Text("Transactions will appear here.")
                    } header: {
                        Text("Transactions")
                    }
                }
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
