//
//  Transaction+CoreDataClass.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
}
