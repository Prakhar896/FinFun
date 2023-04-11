//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 11/4/23.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title2.weight(.bold))
            .padding()
            .multilineTextAlignment(.leading)
    }
}
