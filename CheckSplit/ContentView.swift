import SwiftUI

struct ContentView: View {
    
    @State private var total = 0.0
    @State private var numPeople = 2
    @State private var tipPercent = 0
    @FocusState private var amountIsFocused: Bool
    
    let tipAmts = [0,10,15,20,25]
    
    var perPerson : Double {
        let peopleCount = Double(numPeople + 2)
        let tipSelection = Double(tipPercent)
        
        let tipVal = total / 100 * tipSelection
        let finalAmount = total + tipVal
        let perPersonAmt = finalAmount / peopleCount
        return perPersonAmt
    }
    
    var remaining: Double {
        let originalAmount = Decimal(perPerson)
        var decNum = originalAmount
        var roundedNum = Decimal()
        NSDecimalRound(&roundedNum, &decNum, 2, .down)

        let roundedNSDecimal = NSDecimalNumber(decimal: roundedNum)
        let remainingDouble = roundedNSDecimal.doubleValue
        let remainder = total - remainingDouble * 3
        return remainder
    }


    var body: some View {
        NavigationStack{
            Form {
                Section ("Inputs") {
                    TextField("Amount", value: $total ,format: .currency(code: Locale.current.currency?.identifier ?? "USD")
                        )
                        .focused($amountIsFocused)
                    Picker("Party Size", selection: $numPeople){
                        ForEach(2..<7){
                            Text("\($0) people")
                        }
                    }
                }
                Section ("Tip Percentage}"){
                    
                    Picker("Tip Amount", selection: $tipPercent){
                        ForEach(tipAmts, id: \.self){
                            Text($0,format: .percent)
                        }
                    }
                    
                    .pickerStyle(.segmented)
                    
                }
                Section("Amount Per Person") {
                    HStack {
                        Text("Per Person:")
                        Spacer()
                        Text(perPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                    HStack {
                        Text("Remainder:")
                        Spacer()
                        Text(remaining, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    }
                }

            }
            
            .navigationTitle("CheckPls")
            .toolbar {
                if amountIsFocused{
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }

        }
    }
}

#Preview {
    ContentView()
}
