//
//  OnboardingViewModel.swift
//  woju
//
//  Created by 정민호 on 2/11/24.
//

import SwiftUI
import Foundation

enum Page {
    case login
    case requiredInfo
    case detailInfo
    case done
}

class OnboardingViewModel: ObservableObject {
    @Published var user : UserInfo?
    @Published var isLogin : Bool = UserDefaultsManager.shared.isLoggedIn
    @Published var isOnboarding : Bool = UserDefaultsManager.shared.isOnboarding
    @Published var page : Page = .requiredInfo
}
