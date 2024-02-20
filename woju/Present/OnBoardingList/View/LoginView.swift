//
//  LoginView.swift
//  woju
//
//  Created by 정민호 on 2/17/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var alViewModel = AppleLoginManager()
    @EnvironmentObject var obViewModel: OnboardingViewModel
    @EnvironmentObject var appState : AppStateManager
    
    var body: some View {
        VStack {
            Spacer()
            Image("woju")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .frame(height: UIScreen.main.bounds.height / 3)
                .shadow(color: .black, radius: 10)
            Spacer()
            SignInWithAppleButtonView()
                .frame(width: 280, height: 60)
                .onTapGesture(perform: alViewModel.showAppleLogin)
                .onChange(of: alViewModel.userIdentifier) { oldState, newState in
                    alViewModel.loginCheck()
                }
            Spacer()
        }
        .onAppear() {
            self.alViewModel.setup(appState: appState, obViewModel: obViewModel)
        }
    }
}

struct SignInWithAppleButtonView: UIViewRepresentable {
    typealias UIViewType = UIView

    func makeUIView(context: Context) -> UIView {
        return ASAuthorizationAppleIDButton()
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppStateManager())
            .environmentObject(OnboardingViewModel())
    }
}
