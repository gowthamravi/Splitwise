//
//  ContentView.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 21/06/21.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("loggedStatus") var loggedStauts = false
    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    @State var lend: Double = 0
    @State var received: Double = 0
    @State var spend: Double = 0
    @State var imageName = "bookmark"
    
    var body: some View {
        
        if loggedStauts {
            NavigationView{
                VStack{
                    HStack{
                        Text("Total amount Spend:")
                            .padding(.leading, 20)
                        Spacer()
                        Text("\(spend, specifier: "₹%.f")")
                            .padding(.leading, 35)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Text("Total amount lend:")
                            .padding(.leading, 20)
                        Spacer()
                        Text("\(lend, specifier: "₹%.f")")
                            .padding(.leading, 52)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        Text("Total amount received:")
                            .padding(.leading, 20)
                        Spacer()
                        Text("\(received, specifier: "₹%.f")")
                            .padding(.leading, 20)
                        Spacer()
                    }
                    Spacer()
                    List{
                        ForEach(coreDataViewModel.users, id: \.self) { user in
                            NavigationLink(
                                destination: ContactDetailsView(user: user),
                                label: {
                                    HStack{
                                        Image(systemName: "person.crop.circle.fill")
                                            .imageScale(.large)
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(user.name ?? "")
                                                .modifier(CustomText(fontName: "RobotoSlab-Bold", fontSize: 18, fontColor: Color("pink")))
                                            Text("You paid: ₹\(user.amount, specifier: "%.f")")
                                                .modifier(CustomText(fontName: "RobotoSlab-Light", fontSize: 14, fontColor: Color.primary))
                                            
                                        }
                                        Spacer()
                                        VStack(alignment: .leading, spacing: nil){
                                            Text("you lent")
                                                .modifier(CustomText(fontName: "RobotoSlab-Light", fontSize: 10, fontColor: Color.primary))
                                                let value = (user.amount)/100 * user.percentage
                                                Text("₹\(value, specifier: "%.f")")
                                            Spacer()

                                            if user.bookmark {
                                                Image(systemName: "bookmark.fill")
                                            }else{
                                                Image(systemName: "bookmark")
                                            }
                                        }
                                    }
                                })
                        }.onDelete(perform: { indexSet in
                            indexSet.forEach{ index in
                                let user = coreDataViewModel.users[index]
                                coreDataViewModel.deleteUser(user: user)
                                coreDataViewModel.getAllUsers()
                                self.totalAmountSpend(users: coreDataViewModel.users)
                            }
                        })
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Friends")
                .navigationBarItems(
                    trailing:
                        HStack {
                            Button {
                                loggedStauts = false
                            } label: {
                                Text("Logout")
                            }
                            Spacer()
                            NavigationLink(
                                destination: AddContactView()){
                                Image(systemName: "square.and.pencil")
                                    .imageScale(.large)
                            }
                        }
                )
                .onAppear(perform: {
                    coreDataViewModel.getAllUsers()
                    self.totalAmountSpend(users: coreDataViewModel.users)
                })
            }.navigationBarHidden(true)
        }else{
            LoginView()
                .preferredColorScheme(.light)
                .navigationBarHidden(true)
        }
    }
    
    func totalAmountSpend(users: [Users]){
        lend = 0
        received = 0
        spend = 0
        for user in users {
            let value = (user.amount)/100 * user.percentage
            spend += user.amount
            if(user.type == "Debit"){
                lend += value
            }else{
                received += value
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

