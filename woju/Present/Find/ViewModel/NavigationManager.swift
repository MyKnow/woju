//
//  NavigationManager.swift
//  woju
//
//  Created by 정민호 on 2/18/24.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var firstIsActive = false
    @Published var secondIsActive = false
    @Published var thirdIsActive = false

    func returnToView() {
        firstIsActive = false
    }
}
