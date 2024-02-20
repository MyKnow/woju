//
//  AppStateManager.swift
//  woju
//
//  Created by 정민호 on 2/19/24.
//

import SwiftUI

class AppStateManager: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaultsManager.shared.isLoggedIn = isLoggedIn
        }
    }
    @Published var isOnboarding: Bool {
        didSet {
            UserDefaultsManager.shared.isOnboarding = isOnboarding
        }
    }
    @Published var myInfo: UserInfo? {
        didSet {
            if let myInfo = myInfo {
                UserDefaultsManager.saveUserInfo(user: myInfo)
            }
        }
    }

    init() {
        self.isLoggedIn = UserDefaultsManager.shared.isLoggedIn
        self.isOnboarding = UserDefaultsManager.shared.isOnboarding
        self.myInfo = UserDefaultsManager.getUserInfo()
    }

    func logout() {
        isLoggedIn = false
        isOnboarding = false
    }
    
    func userDataDelete() {
        myInfo = nil
        UserDefaultsManager.deleteUserData()
    }
}
