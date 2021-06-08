//
//  CoreData.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 17.05.2021.
//

import UIKit
import CoreData

final class CoreData {
    
    var translates: [Translate] = []
    private let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    /// Save to core date
    func saveData(_ source: String, _ target: String) {
        
        // Entity name
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Translate", in: managedContext) else { return }
        
        // Model instance
        let translate = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Translate
        
        translate.source = source
        translate.target = target
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Fetch from core data
    func fetchData() {
        // fetch request from the database of all values by key Translate
        let fetchRequest: NSFetchRequest<Translate> = Translate.fetchRequest()
        
        do {
            try translates = managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Remove from core data
    private func remove(at index: Int) {
        //let fetchRequest: NSFetchRequest<Translate> = Translate.fetchRequest()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Translate")
        
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        managedContext.delete(resultData[index])
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    /// Edit core data property
    private func editData(_ translate: String, for index: Int) {
        managedContext.setValue(translate, forKey: "name")
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Translate")
        //fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                managedContext.delete(objectData)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}


