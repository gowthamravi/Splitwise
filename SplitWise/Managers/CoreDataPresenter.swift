//
//  CoreData.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 21/06/21.
//

import Foundation
import CoreData


protocol DefaultCoreDataPresenter {
    func userSaveAndUpdate(name: String?, mobile: String?, amount: Double?, type: String?, percentage: Double?, bookmark:Bool?, users: Users?)
    func getUsersList() -> [Users]
    func deleteUser(user: Users)
    func getBookmarkUserList() -> [Users]
}

class CoreDataPresenter: DefaultCoreDataPresenter {
    
    
    private static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SplitWise")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    init() { }
    
    func userSaveAndUpdate(name: String?, mobile: String?, amount: Double?, type: String?, percentage: Double?, bookmark:Bool?, users: Users?) {
        let context = CoreDataPresenter.container.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
        let predicate = NSPredicate(format: "mobileno = '\(users?.mobileno ?? "")'")
        fetchRequest.predicate = predicate
        do
          {
            let object = try context.fetch(fetchRequest)
            if object.count == 1
            {
              let userToUpdate = object.first as! NSManagedObject
              userToUpdate.setValue(users?.name, forKeyPath: "name")
              userToUpdate.setValue(users?.mobileno, forKeyPath: "mobileno")
              userToUpdate.setValue(users?.amount, forKeyPath: "amount")
              userToUpdate.setValue(users?.type, forKeyPath: "type")
              userToUpdate.setValue(users?.percentage, forKeyPath: "percentage")
              userToUpdate.setValue(users?.bookmark, forKeyPath: "bookmark")
              do{
                try context.save()
              }
              catch
              {
                print(error)
              }
            } else {
              let managedContext = CoreDataPresenter.container.viewContext
              let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext)!
              let userToAdd = NSManagedObject(entity: entity, insertInto: managedContext)
              userToAdd.setValue(name, forKeyPath: "name")
              userToAdd.setValue(mobile, forKeyPath: "mobileno")
              userToAdd.setValue(amount, forKeyPath: "amount")
              userToAdd.setValue(type, forKeyPath: "type")
              userToAdd.setValue(percentage, forKeyPath: "percentage")
              userToAdd.setValue(bookmark, forKeyPath: "bookmark")
              do {
                try managedContext.save()
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
            }
          }
        catch
        {
          print(error)
        }
      }

    func getUsersList() -> [Users] {
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        if let result = try? CoreDataPresenter.container.viewContext.fetch(fetchRequest){
            return result
        }
        return []
    }
    
    
    func getBookmarkUserList() -> [Users] {
        let fetchRequest = NSFetchRequest<Users>(entityName: "Users")
        let predicate = NSPredicate(format: "bookmark = %@", argumentArray: [true]) // Specify your condition here
        fetchRequest.predicate = predicate
        if let result = try? CoreDataPresenter.container.viewContext.fetch(fetchRequest){
            return result
        }
        return []
    }
    
    func deleteUser(user: Users) {
        CoreDataPresenter.container.viewContext.delete(user)
        if let result = try? CoreDataPresenter.container.viewContext.save(){
            print("Deleted",result)
        }else{
            CoreDataPresenter.container.viewContext.rollback()
        }
    }

    
    private func saveContext () {
        DispatchQueue.global(qos: .background).async {
//            if CoreDataPresenter.container.viewContext.hasChanges {
                do {
                    try CoreDataPresenter.container.viewContext.save()
                } catch {
                    let nserror = error
                    fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
                }
//            }
        }
    }
}
