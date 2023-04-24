//
//  BudgetListView.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import SwiftUI

struct BudgetListView: View {
    
    let budgetCategoryResults: FetchedResults<BudgetCategory>
    let onDeleteBudgetCategory: (BudgetCategory) -> Void
    
    var body: some View {
        List {
            if !budgetCategoryResults.isEmpty {
                ForEach(budgetCategoryResults) { budgetCategory in
                    HStack {
                        Text(budgetCategory.title ?? "")
                        Spacer()
                        VStack {
                            Text(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)
                        }
                    }
                }.onDelete { indexSet in
                    indexSet.map { budgetCategoryResults[$0] }.forEach(onDeleteBudgetCategory)
                }
            } else {
                Text("No budget categories exist!")
            }
        }
    }
}
