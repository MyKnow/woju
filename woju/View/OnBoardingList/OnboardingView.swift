//
//  OnboardingView.swift
//  woju
//
//  Created by 정민호 on 2/11/24.
//

import SwiftUI

// OnboardingView.swift

struct OnboardingView: View {
  @StateObject var obViewModel = OnboardingViewModel()

  var body: some View {
    ZStack {
      Color.accentColor
        .edgesIgnoringSafeArea(.all)
        
        if obViewModel.isLogin {
            switch obViewModel.page {
            case .login:
                LoginView(user: $obViewModel.user, page: $obViewModel.page, isLoggedIn: $obViewModel.isLogin)
            case .requiredInfo:
                RequiredInfoView(user: $obViewModel.user, page: $obViewModel.page, isLoggedIn: $obViewModel.isLogin)
            case .detailInfo:
                DetailInfoView(user: $obViewModel.user, page: $obViewModel.page, isLoggedIn: $obViewModel.isLogin)
            case .done:
                MainView()
            }
        } else {
            LoginView(user: $obViewModel.user, page: $obViewModel.page, isLoggedIn: $obViewModel.isLogin)
        }
    }
  }
}


#Preview {
    OnboardingView()
}
