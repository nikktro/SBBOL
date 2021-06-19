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
    private let managedContext = (UIApplication.shared.delegate
                                    as! AppDelegate).persistentContainer.viewContext
    
    
    func saveData(_ source: String, _ target: String, _ sourceLanguage: String, _ targetLanguage: String) {
        
        guard let entityDescription = NSEntityDescription.entity(
                forEntityName: "Translate", in: managedContext) else { return }
        
        let translate = NSManagedObject(entity: entityDescription,
                                        insertInto: managedContext) as? Translate
        
        translate?.source = source
        translate?.target = target
        translate?.sourceLang = sourceLanguage
        translate?.targetLang = targetLanguage
        translate?.date = Date()
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Translate> = Translate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            try translates = managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
    }
    
    private func remove(at index: Int) {
        let fetchRequest: NSFetchRequest<Translate> = Translate.fetchRequest()
        
        let result = try? managedContext.fetch(fetchRequest)
        if let resultData = result {
            managedContext.delete(resultData[index])
        }
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
        
    }
    
    private func editData(_ translate: String, for index: Int) {
        managedContext.setValue(translate, forKey: "name")
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<Translate> = Translate.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                managedContext.delete(object)
            }
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
    }
    
}


