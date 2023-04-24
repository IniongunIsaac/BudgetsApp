//
//  CoreDataManager.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistenceContainer: NSPersistentContainer
    
    private init() {
        persistenceContainer = NSPersistentContainer(name: "BudgetModel")
        persistenceContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to initialize CoreDataStack \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
}
