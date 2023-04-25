//
//  AddBudgetCategoryView.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var total: Double = 100
    @State private var messages: [String] = []
    
    private let budgetCategory: BudgetCategory?
    
    init(budgetCategory: BudgetCategory? = nil) {
        self.budgetCategory = budgetCategory
    }
    
    private var isFormValid: Bool {
        messages.removeAll()
        
        if title.isEmpty {
            messages.append("Title is required!")
        }
        
        if total <= 0 {
            messages.append("Total must be greater than 0!")
        }
        
        return messages.isEmpty
    }
    
    private func saveOrUpdate() {
        if let budgetCategory {
            let budget = BudgetCategory.byId(budgetCategory.objectID)
            budget.title = title
            budget.total = total
        } else {
            let budgetCategory = BudgetCategory(context: viewContext)
            budgetCategory.title = title
            budgetCategory.total = total
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                
                Slider(value: $total, in: 0...500, step: 50) {
                    Text("Total")
                } minimumValueLabel: {
                    Text("$50")
                } maximumValueLabel: {
                    Text("$500")
                }
                
                Text(total as NSNumber, formatter: NumberFormatter.currency)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ForEach(messages, id: \.self) { message in
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
            } //:Form
            .onAppear {
                showDetails()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                } //: Cancel
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isFormValid {
                            saveOrUpdate()
                        }
                    }
                } //: Save
            }
        } //:NavigationStack
    }
    
    private func showDetails() {
        guard let budgetCategory else { return }
        title = budgetCategory.title ?? ""
        total = budgetCategory.total
    }
}

struct AddBudgetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetCategoryView().environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
    }
}
