//
//  BudgetCategory+CoreDataClass.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    var transactionsTotal: Double {
        transactionsArray.map { $0.total }.reduce(0, +)
    }
    
    var remainingBudgetTotal: Double {
        total - transactionsTotal
    }
    
    var overSpent: Bool {
        remainingBudgetTotal < 0
    }
    
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
    
    static func transactionsByCategoryRequest(_ budgetCategory: BudgetCategory) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        return request
    }
    
    private var transactionsArray: [Transaction] {
        guard let transactions else { return [] }
        let allTransactions = (transactions.allObjects as? [Transaction]) ?? []
        return allTransactions.sorted { t1, t2 in
            t1.dateCreated! > t2.dateCreated!
        }
    }
    
    static func byId(_ id: NSManagedObjectID) -> BudgetCategory {
        let viewContext = CoreDataManager.shared.viewContext
        guard let budgetCategory = viewContext.object(with: id) as? BudgetCategory else {
            fatalError("Id not found")
        }
        return budgetCategory
    }
    
    static var all: NSFetchRequest<BudgetCategory> {
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
}
