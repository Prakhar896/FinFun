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
    
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
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
        .onTapGesture {
            alertTitle = "\(transaction.title) (\(amountText))"
            alertMessage = transaction.description ?? "Looks like there's no description for this transaction. You gotta remember to keep your receipts!"
            showingAlert = true
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }

    }
}

@available(iOS 16, *)
struct LifeEventView: View {
    var lifeEvent: LifeEvent
    
    var insuranceText: String {
        if lifeEvent.coveredByInsurance {
            return " (Covered by Insurance)"
        } else {
            return ""
        }
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 15) {
                Image(systemName: lifeEvent.type == .accident ? "exclamationmark.triangle": "cross.case")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                Text("\(lifeEvent.title) experienced by \(lifeEvent.targetParty.rawValue.lowercased())" + insuranceText)
                    .font(.system(size: 17).bold())
            }
            
            Spacer()
            
            Text(lifeEvent.cost.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                .foregroundColor(lifeEvent.coveredByInsurance ? .yellow: .red)
                .font(.system(size: 17).bold())
        }
        .padding(5)
    }
}
