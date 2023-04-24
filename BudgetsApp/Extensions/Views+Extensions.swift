//
//  Views+Extensions.swift
//  BudgetsApp
//
//  Created by Isaac Iniongun on 24/04/2023.
//

import Foundation
import SwiftUI

extension View {
    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            
            self
            
            Spacer()
        }
    }
}
