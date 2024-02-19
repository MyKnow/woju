//
//  Bool.swift
//  woju
//
//  Created by 정민호 on 2/19/24.
//

import SwiftUI

extension Binding where Value == Bool {
    var not: Binding<Value> {
        Binding<Value>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}
