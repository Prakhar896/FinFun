//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 19/4/23.
//

import SwiftUI

struct HomeIntroView: View {
    var userProfile: GameProfile
    
    @Binding var showingIntro: Bool
    
    // Control for animations
    @State var yearTextOpacity = 0.0
    @State var subheadlineTextOpacity = 0.0
    
    @State var purposeTextOpacity = 0.0
    @State var beginButtonOpacity = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\(userProfile.name), the year is 2080.")
                .font(.title.weight(.bold))
                .padding(.bottom, 30)
                .opacity(yearTextOpacity)
                .onAnimationCompleted(for: yearTextOpacity) {
                    withAnimation(.linear(duration: 3)) {
                        subheadlineTextOpacity = 1
                    }
                }
            
            Text("The cost of living has never been higher and the world is ever more desperate to make money.")
                .font(.headline)
                .padding(.bottom, 50)
                .multilineTextAlignment(.center)
                .opacity(subheadlineTextOpacity)
                .onAnimationCompleted(for: subheadlineTextOpacity) {
                    withAnimation(.linear(duration: 1)) {
                        purposeTextOpacity = 1
                    }
                }
            
            VStack {
                Text("Your aim is to make as much money as possible within 50 years (2 minutes in your dimensions' time)with the various finance options available to grow your assets.")
                Text("Whether you have won this game of life will be determined at the end.\nFor now, all you have to do is start your venture into the unknown.")
                    .padding(.bottom, 50)
            }
            .multilineTextAlignment(.center)
            .opacity(purposeTextOpacity)
            .onAnimationCompleted(for: purposeTextOpacity) {
                withAnimation(.linear(duration: 0.5)) {
                    beginButtonOpacity = 1
                }
            }
                
            Button {
                withAnimation {
                    showingIntro = false
                }
            } label: {
                Text("Begin")
                    .font(.system(size: 18).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.blue)
            }
            .cornerRadius(10)
            .opacity(beginButtonOpacity)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5)) {
                yearTextOpacity = 1 //  triggers all following animation callbacks
            }
        }
    }
}

struct HomeIntroView_Previews: PreviewProvider {
    static var previews: some View {
        HomeIntroView(userProfile: GameProfile.blankGameProfile(), showingIntro: .constant(true))
    }
}
