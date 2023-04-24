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
    
    var body: some View {
        NavigationStack {
            VStack {
                List(budgetCategoryResults) { budgetCategory in
                    Text(budgetCategory.title ?? "")
                }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
