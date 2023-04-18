//
//  SwiftUIView.swift
//  
//
//  Created by Prakhar Trivedi on 17/4/23.
//

import SwiftUI

struct ProfileSetupView: View {
    @State var name: String = ""
    @State var monthlySalary: SalaryOptions = .easy
    @State var monthlyExpenses: Double = 0.0
    @State var careerGrowth: CareerGrowthOptions = .easy
    @State var children: [Child] = []
    
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
                        }
                        
                        // Monthly Expenses
                        HStack {
                            Text("Monthly Expenses:")
                            TextField("For e.g, $2000", value: $monthlyExpenses, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
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
                        Button {
                            // check values, create profile and segue to game screen
                            completeButtonTapped()
                        } label: {
                            Text("Complete")
                                .bold()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.accentColor)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .navigationTitle("Game Profile")
                .alert(alertTitle, isPresented: $alertIsPresented) {
                    Button("OK", role: .cancel) { alertIsPresented = false }
                } message: {
                    Text(alertMessage)
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
    
    func completeButtonTapped() {
        if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            presentAlert(withTitle: "Uh Oh!", andMessage: "Please enter a valid name for your profile!")
            return
        }
        
        let userProfile = GameProfile(name: name, monthlySalaryInThousands: GameProfile.salaryForOption(monthlySalary), children: children, monthlyExpenses: monthlyExpenses, careerGrowth: GameProfile.careerGrowthRate(for: careerGrowth))
        
        // services testing
        print("hello here 1")
        var lifeManager = LifeManager(salaryInThousands: GameProfile.salaryForOption(monthlySalary), monthlyExpenditure: monthlyExpenses, children: children)
        print("hello reached here 2")
        print(lifeManager.checkForCharges(realTimeElapsed: 0.1))
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
        ProfileSetupView()
    }
}
