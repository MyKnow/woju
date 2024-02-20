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
    @Published var page : Page = .requiredInfo
}
