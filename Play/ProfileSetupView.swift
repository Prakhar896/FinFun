//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 17/4/23.
//

import SwiftUI

struct ProfileSetupView: View {
    @Binding var pageShowing: PageIdentifier
    
    @State var name: String = ""
    @State var monthlySalary: SalaryOptions = .easy
    @State var monthlyExpenses: Double = 0.0
    @State var careerGrowth: CareerGrowthOptions = .easy
    @State var children: [Child] = []
    
    @FocusState var nameIsFocused: Bool
    @FocusState var expensesIsFocused: Bool
    
    var generatedGameProfile: GameProfile {
        return GameProfile(
            name: name,
            monthlySalaryInThousands: GameProfile.salaryForOption(monthlySalary),
            children: children,
            monthlyExpenses: monthlyExpenses,
            careerGrowth: GameProfile.careerGrowthRate(for: careerGrowth)
        )
    }
    
    // Alert properties
    @State var alertIsPresented: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                Form {
                    // Instructions Section
                    Section {
                        Text("Before you play, you need to set-up a game profile below. The settings you choose below will determine the difficulty of the game you play and the amount you need to make to win in the game itself.")
                            .padding(20)
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    } header: {
                        Text("Instructions")
                    }
                    
                    // Player details section
                    Section {
                        // Name
                        HStack {
                            Text("Name:")
                            TextField("John Appleseed", text: $name)
                                .multilineTextAlignment(.trailing)
                                .focused($nameIsFocused)
                        }
                        .padding([.vertical])
                        
                        // Monthly Expenses
                        HStack {
                            Text("Monthly Expenses:")
                            TextField("For e.g, $2000", value: $monthlyExpenses, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($expensesIsFocused)
                        }
                        
                        // Monthly Salary
                        Picker("Monthly Salary:", selection: $monthlySalary) {
                            ForEach(GameProfile.monthlySalaryOptions, id: \.self) { salaryOption in
                                Text(salaryOption.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        // Career Growth Rate
                        Picker("Career Growth Rate:", selection: $careerGrowth) {
                            ForEach(GameProfile.careerGrowthOptions, id: \.self) { growthRateOption in
                                Text(growthRateOption.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                    } header: {
                        Text("About You")
                    }
                    
                    Section {
                        HStack {
                            Text("Children: \(children.count)")
                                .bold()
                            
                            Spacer()
                            
                            // Plus Button
                            Button {
                                // add a child
                                withAnimation {
                                    children.append(Child(age: 2))
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                            .disabled(children.count == 5)
                        }
                        .padding(.vertical)
                        
                        ForEach(0..<children.count, id: \.self) { childIndex in
                            HStack {
                                Text("Child \(childIndex + 1) Age:")
                                TextField("Child's age here.", value: $children[childIndex].age, format: .number)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .onDelete(perform: removeChild)
                    } footer: {
                        Text("Tip: Swipe left on a child's row to destroy your children if you are evil.")
                    }
                    
                    Section {
                        NavigationLink {
                            PlayHomeView(
                                gameState: GameState(userGameProfile: generatedGameProfile, balance: 0.0, timeLeft: GameState.defaultTimeLimit, realTimeElapsed: 0.0), pageShowing: $pageShowing
                            )
                            // Text("Hello World!")
                        } label: {
                            HStack {
                                Text("Play!")
                                    .foregroundColor(.accentColor)
                                    .bold()
                                    .padding([.horizontal])
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines) == "")
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .navigationTitle("Game Profile")
                .alert(alertTitle, isPresented: $alertIsPresented) {
                    Button("OK", role: .cancel) { alertIsPresented = false }
                } message: {
                    Text(alertMessage)
                }
//                .onAppear {
//                    #warning("Below code setups up a debug game profile by default for testing purposes. Remove before production.")
//                    name = "Prakhar"
//                    monthlyExpenses = 1000.0
//                    monthlySalary = .medium
//                    careerGrowth = .medium
//                    children = [Child(age: 13), Child(age: 20)]
//                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            nameIsFocused = false
                            expensesIsFocused = false
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            Text("Sorry! This game requires iOS 16 or higher to play. Please try updating your device and come back again!")
        }
    }
    
    func removeChild(at offsets: IndexSet) {
        children.remove(atOffsets: offsets)
    }
    
    func presentAlert(withTitle title: String, andMessage message: String) {
        alertTitle = title
        alertMessage = message
        alertIsPresented = true
        return
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(pageShowing: .constant(.play))
    }
}
