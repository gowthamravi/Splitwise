//
//  AddContactView.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 22/06/21.
//



import SwiftUI

struct AddContactView: View {
    @State var name: String = ""
    @State var mobile: String = ""
    @State var amount: String = ""
    @State var type: String = ""
    @State private var alertText = "Please enter all fields"
    @State private var showingAlert = false
    
    @State private var percentage: Double = 0
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Form{
                Text("Enter Name:")
                TextField("Name", text: $name)
                Text("Enter Mobile No:")
                TextField("Number", text: $mobile)
                Text("Total amount:")
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
               
     
                Text("Split by Percentage:")
                Slider(value: $percentage, in: 0...100, step: 10.0)
                Text("\(percentage, specifier: "%.f")")
                
            }
            Button(action:save){
                HStack{
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("SplitWise"), message: Text(alertText), dismissButton: .default(Text("Okay")))
            })
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(15.0)
        }
        .toolbar{
            ToolbarItem(placement: .principal){
                VStack{
                    Text("Add Person").font(.headline)
                }
            }
        }
    }
    
    func save(){
        if !name.isEmpty && !mobile.isEmpty && !amount.isEmpty && percentage > 0 {
            if !textFieldValidatorNumber(mobile) {
                alertText = "Please enter valid mobile no"
                showingAlert = true
                return
            }
            guard let totalCost = Double(amount), totalCost > 0 else {
                alertText = "Please enter valid amount"
                showingAlert = true
                return
            }
                        
            self.coreDataViewModel.saveUser(name: name, mobile: mobile, amount: totalCost, type: "Debit",percentage: percentage, bookmark: false)
            self.presentationMode.wrappedValue.dismiss()
        }else{
            showingAlert = true
        }
    }
    
    func textFieldValidatorNumber(_ string: String) -> Bool {
        if string.count > 10 {
            return false
        }
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: string)
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView()
    }
}
