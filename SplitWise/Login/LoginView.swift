//
//  LoginView.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 21/06/21.
//

import SwiftUI

struct LoginView: View {
    //MARK:- PROPERTIES
    @State private var username = ""
    @State private var password = ""
    @AppStorage("userName") var storedUserName = ""
    @AppStorage("password]") var storePassword = ""
    @AppStorage("loggedStatus") var loggedStauts = false
    @State private var showingAlert = false
    @State private var message = ""
    
    var body: some View {
        NavigationView {
            VStack{
                
                VStack(spacing:15){
                    Text("Hello There")
                        .modifier(CustomText(fontName: "RobotoSlab-Bold", fontSize: 34, fontColor: Color("pink")))
                    Text("Please sign in to continue.")
                        .modifier(CustomText(fontName: "RobotoSlab-Light", fontSize: 18, fontColor: Color.primary))
                }
                .padding(.top,45)
                Spacer()
                
                VStack(spacing: 15){
                    VStack(alignment: .center, spacing: 30){
                        VStack(alignment: .center) {
                            CustomTextfield(placeholder:
                                                Text("Username"),
                                            fontName: "RobotoSlab-Light",
                                            fontSize: 18,
                                            fontColor: Color.pink,
                                            username: $username)
                            Divider()
                                .background(Color.gray)
                        }
                        VStack(alignment: .center) {
                            CustomTextfield(placeholder:
                                                Text("Password"),
                                              fontName: "RobotoSlab-Light",
                                              fontSize: 18,
                                              fontColor: Color.pink,
                                              username: $password)
                            Divider()
                                .background(Color.gray)
                        }
                    }
                }
                .padding(.horizontal,35)
                
                ZStack{
                    NavigationLink(destination:
                                    MainView(),isActive: self.$loggedStauts) {
                        Button(action: authenticateUserPassword, label: {
                            Text("LOGIN")
                                .fontWeight(.heavy)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 150)
                                .foregroundColor(Color("pink"))
                                .border(Color("pink"))
                        })
                    }
                }
                .padding(.top,35)
                Spacer()
            }.alert(isPresented: $showingAlert, content: {
                Alert(
                    title: Text("Splitwise"),
                    message: Text(message), primaryButton: .default(Text("Okay")),
                    secondaryButton: .cancel()
                )
                
            })
        }
    }
    
    func authenticateUserPassword(){
        
        if storedUserName == "" && storePassword == "" {
            
            if username.isEmpty || password.isEmpty {
                message = "Please enter username and password"
                showingAlert = true
                return
            }
            storedUserName = username
            storePassword = password
            withAnimation(.easeOut){ loggedStauts = true}
            return
        }
        
        
        if username == storedUserName && password == storePassword {
            withAnimation(.easeOut){ loggedStauts = true}
            
        }else{
            showingAlert = true
            message = "User Password Does not match"
            print("User Password Does not match")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

