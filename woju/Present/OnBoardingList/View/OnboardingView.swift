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
    @EnvironmentObject var appState: AppStateManager

  var body: some View {
    ZStack {
      Color.accentColor
        .edgesIgnoringSafeArea(.all)
        
        if appState.isLoggedIn {
            switch obViewModel.page {
            case .login:
                LoginView()
            case .requiredInfo:
                RequiredInfoView()
            case .detailInfo:
                DetailInfoView(obViewModel: obViewModel)
            case .done:
                MainView()
            }
        } else {
            LoginView()
        }
    }
    .environmentObject(obViewModel)
  }
}


#Preview {
    OnboardingView()
        .environmentObject(AppStateManager())
}
