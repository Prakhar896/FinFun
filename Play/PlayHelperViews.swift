//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 19/4/23.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    
    var amountText: String {
        var final = ""
        
        if transaction.posOrNeg == .positive {
            final += "+"
        } else {
            final += "-"
        }
        
        final += String(transaction.quantity.rounded())
        
        return final
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                Image(systemName: Transaction.imageName(forTransactionType: transaction.type))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text(transaction.title)
                    .font(.system(size: 18).bold())
            }
            
            Spacer()
            
            Text(amountText)
                .foregroundColor(transaction.posOrNeg == .positive ? .green: .red)
                .font(.system(size: 18).bold())
        }
        .padding(5)
    }
}
