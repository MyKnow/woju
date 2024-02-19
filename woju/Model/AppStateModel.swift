//
//  AppStateModel.swift
//  woju
//
//  Created by 정민호 on 2/19/24.
//

import SwiftUI

class AppStateModel: ObservableObject {
  @Published var isLoggedIn: Bool = UserDefaultsManager.shared.isLoggedIn
  @Published var isOnboarding: Bool = UserDefaultsManager.shared.isOnboarding

  func logout() {
    UserDefaultsManager.shared.logout()
    isLoggedIn = false
    isOnboarding = false
  }
}
