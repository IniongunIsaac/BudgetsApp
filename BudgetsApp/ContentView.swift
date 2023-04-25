//
//  ContentView.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import SwiftUI

enum SheetAction: Identifiable {
    
    case add
    case edit(BudgetCategory)
    
    var id: Int {
        switch self {
        case .add:
            return 1
        case .edit(_):
            return 2
        }
    }
    
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //@FetchRequest(sortDescriptors: []) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @FetchRequest(fetchRequest: BudgetCategory.all) private var budgetCategoryResults
    @State private var isPresented: Bool = false
    @State private var sheetAction: SheetAction?
    
    var grandTotal: Double {
        budgetCategoryResults.reduce(0) { partialResult, budgetCategory in
            return partialResult + budgetCategory.total
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Total Budget - ")
                    Text(grandTotal as NSNumber, formatter: NumberFormatter.currency)
                        .fontWeight(.bold)
                    .font(.title)
                }
                
                BudgetListView(budgetCategoryResults: budgetCategoryResults,
                               onDeleteBudgetCategory: deleteBudgetCategory,
                               onEditBudgetCategory: editBudgetCategory)
            }
            .sheet(item: $sheetAction, content: { sheetAction in
                // display the sheet
                switch sheetAction {
                    case .add:
                        AddBudgetCategoryView()
                    case let .edit(budgetCategory):
                    AddBudgetCategoryView(budgetCategory: budgetCategory)
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Category") {
                        sheetAction = .add
                    }
                }
            }
        }
    }
    
    private func editBudgetCategory(_ budgetCategory: BudgetCategory) {
        sheetAction = .edit(budgetCategory)
    }
    
    private func deleteBudgetCategory(_ budgetCategory: BudgetCategory) {
        viewContext.delete(budgetCategory)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
    }
}
