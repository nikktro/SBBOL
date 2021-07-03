//
//  CoreData.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 17.05.2021.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    private init() {}
        
    private let managedContext = (UIApplication.shared.delegate
                                    as! AppDelegate).persistentContainer.viewContext
    
    func saveData(with translate: TranslateModel) {
        
        guard let entityDescription = NSEntityDescription.entity(
                forEntityName: "Translate", in: managedContext) else { return }
        
        let saveTranslate = NSManagedObject(entity: entityDescription,
                                        insertInto: managedContext) as? Translate
        
        saveTranslate?.source = translate.source
        saveTranslate?.target = translate.target
        saveTranslate?.sourceLang = translate.sourceLang
        saveTranslate?.targetLang = translate.targetLang
        saveTranslate?.date = translate.date
        
        do {
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription) // TODO: add error handler
        }
    }
    
    func fetchData(completion: @escaping (_ translates: [Translate])->()) {
        let fetchRequest: NSFetchRequest<Translate> = Translate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let translates = try managedContext.fetch(fetchRequest)
            completion(translates)
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


