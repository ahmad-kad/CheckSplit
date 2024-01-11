import SwiftUI

extension BinaryFloatingPoint {
    func rounded(toPlaces places: Int) -> Self {
        let divisor = Self(pow(10.0, Double(places)))
        return (self * divisor).rounded() / divisor
    }
}

struct ContentView: View {
    
    @State private var total = 0.0
    @State private var numPeople = 2
    @State private var tipPercent = 0
    @FocusState private var amountIsFocused: Bool

    let tipAmts = [0, 10, 15, 20, 25]

    var perPerson: Double {
        let peopleCount = Double(numPeople + 2)
        let tipSelection = Double(tipPercent)
        let tipVal = total * tipSelection / 100
        return (total + tipVal) / peopleCount
    }

    var remaining: Double {
        let perPersonAmt = perPerson
        let roundedAmount = perPersonAmt.rounded(toPlaces: 2)
        let remainder = total - roundedAmount * Double(numPeople + 2)
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
