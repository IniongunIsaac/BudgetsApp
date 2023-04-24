//
//  BudgetDetailView.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import SwiftUI
import CoreData

struct BudgetDetailView: View {
    
    let budgetCategory: BudgetCategory
    
    @State private var title: String = ""
    @State private var total: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isFormValid: Bool {
        guard let totalAsDouble = Double(total) else { return false }
        return !title.isEmpty && !total.isEmpty && totalAsDouble > 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(budgetCategory.title ?? "")
                        .font(.largeTitle)
                    HStack {
                        Text("Budget:")
                        Text(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)
                    }.fontWeight(.bold)
                }.padding(.horizontal, 20)
            }
            
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Total", text: $total)
                } header: {
                    Text("Add Transaction")
                }

                Button("Save Transaction") {
                    saveTransaction()
                }
                .disabled(!isFormValid)
                .centerHorizontally()
            }
            
            BudgetSummaryView(budgetCategory: budgetCategory)
            
            TransactionListView(request: BudgetCategory.transactionsByCategoryRequest(budgetCategory),
                                onDeleteTransaction: deleteTransaction)
        }
    }
    
    private func saveTransaction() {
        do {
            let transaction = Transaction(context: viewContext)
            transaction.title = title
            transaction.total = Double(total) ?? 0
            
            budgetCategory.addToTransactions(transaction)
            
            try viewContext.save()
            
        } catch {
            print(error)
        }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
}
