//
//  LearnView.swift
//  FinFun
//
//  Created by Prakhar Trivedi on 10/4/23.
//

import SwiftUI

struct LearnView: View {
    var body: some View {
        NavigationView {
            Text("You have reached the Learn page.")
                .navigationTitle("Learn")
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
