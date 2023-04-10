//
//  TitleView.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import SwiftUI

struct TitleView: View {
    @Binding var pageShowing: PageIdentifier
    
    @State private var appDescAndNextButtonIsShowing = false
    @State private var titleAndIconOffsetDeduction = 0.0
    @State private var segueExecuted = false
    
    var body: some View {
        VStack(spacing: 50) {
            VStack { // Welcome and Icon
                Image("UpscaledIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(20)
                Text("Welcome to\nFinFun!")
                    .font(.largeTitle.weight(.heavy))
                    .multilineTextAlignment(.center)
            }
            .offset(x: 0, y: 30 - titleAndIconOffsetDeduction)
            
            if appDescAndNextButtonIsShowing {
                VStack { // A bit of explanatory text
                    Text("FinFun is a fun and interactive app where you can learn some basic personal finance methods in a gamified manner! It was designed to be a stepping stone for all teenagers or young adults out there who may be starting to manage their own finances as they grow older.")
                        .padding()
                    Text("This app has two sections: Learn, and Play. In Learn, you will pick up some basic personal finance knowledge to play the game in Play. You will find out what Play involves yourself!")
                        .padding()
                }
                .font(.headline)
                .multilineTextAlignment(.center)
                
                Button {
                    withAnimation {
                        pageShowing = .learn
                    }
                } label: {
                    HStack {
                        Text("Next")
                            .bold()
                        Image(systemName: "arrow.right")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(blendDuration: 1.5)) {
                appDescAndNextButtonIsShowing = true
                titleAndIconOffsetDeduction = 30
            }
        }
        
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(pageShowing: .constant(.title))
    }
}
