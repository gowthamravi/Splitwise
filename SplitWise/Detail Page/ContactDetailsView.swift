//
//  ContactDetailsView.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 22/06/21.
//

import SwiftUI

struct ContactDetailsView: View {

    let user: Users
    @State private var showingAlert = false
    @State private var bookmarkImage = "bookmark"
    
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Text("Friend Name: \(user.name ?? "")")
                    Text("Total Amount paid by you: \(user.amount, specifier: "%.f")")
                    let value = (user.amount)/100 * user.percentage
                    Text("Total Amount you lent: ₹\(value, specifier: "%.f")")
                    
                }
                Button(action:update){
                    HStack{
                        if user.type == "Debit"{
                            Image(systemName: "checkmark")
                        }else{
                            Text("Paid").bold()
                                .foregroundColor(Color.white)
                        }
                    }
                }.alert(isPresented: $showingAlert, content: {
                    Alert(
                        title: Text("Splitwise"),
                        message: Text(("Are you sure to update?")),
                        primaryButton: .default(Text("Paid")) {
                            user.type = "Credit"
                            self.coreDataViewModel.updateUser(user: user)
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                    
                })
                .foregroundColor(Color.white)
                .padding()
                .background(Color("pink"))
                .cornerRadius(15.0)
            }
            .navigationTitle(user.name ?? "")
            .toolbar {
                Button(action: {
                    user.bookmark = !user.bookmark
                    if user.bookmark {
                        bookmarkImage = "bookmark.fill"
                    } else{
                        bookmarkImage = "bookmark"
                    }
                    coreDataViewModel.updateUser(user: user)
                }) {
                    Image(systemName: bookmarkImage).onAppear {
                        if user.bookmark {
                            bookmarkImage = "bookmark.fill"
                        } else{
                            bookmarkImage = "bookmark"
                        }
                    }
                }
            }
        }
    }
    
    func update(){
        if user.type == "Debit"{
            showingAlert = true
        }
    }
    
}

