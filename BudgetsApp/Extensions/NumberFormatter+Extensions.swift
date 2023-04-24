//
//  NumberFormatter+Extensions.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
