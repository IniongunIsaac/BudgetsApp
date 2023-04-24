//
//  ContentView.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @State private var isPresented: Bool = false
    
    var grandTotal: Double {
        budgetCategoryResults.reduce(0) { partialResult, budgetCategory in
            return partialResult + budgetCategory.total
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(grandTotal as NSNumber, formatter: NumberFormatter.currency)
                    .fontWeight(.bold)
                    .font(.title)
                
                BudgetListView(budgetCategoryResults: budgetCategoryResults,
                               onDeleteBudgetCategory: deleteBudgetCategory)
            }
            .sheet(isPresented: $isPresented) {
                AddBudgetCategoryView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Category") {
                        isPresented = true
                    }
                }
            }
        }
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
        ContentView()
    }
}
