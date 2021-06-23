//
//  CoreDataViewModel.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 21/06/21.
//

import Foundation

class CoreDataViewModel: ObservableObject{
    
    @Published var presenter = CoreDataPresenter()
    @Published var users = [Users]()
    
    
    func saveUser(name: String, mobile: String, amount: Double, type: String, percentage: Double, bookmark: Bool){
        presenter.userSaveAndUpdate(name: name, mobile: mobile, amount: amount, type: type, percentage: percentage, bookmark: bookmark, users: nil)
    }
    
    func updateUser(user: Users){
        presenter.userSaveAndUpdate(name: nil, mobile: nil, amount: nil, type: nil, percentage: nil, bookmark: nil, users: user)
    }
    
    func getAllUsers(){
        users = presenter.getUsersList()
    }
    
    func deleteUser(user: Users){
        presenter.deleteUser(user: user)
    }
    
    func getBookmarkUsers(){
        users = presenter.getBookmarkUserList()
    }
}
