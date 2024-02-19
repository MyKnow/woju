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
    @Binding var user: UserInfo?
    @Binding var page: Page
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image("woju")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .frame(height: UIScreen.main.bounds.height / 3)
            Spacer()
            SignInWithAppleButtonView()
                .frame(width: 280, height: 60)
                .onTapGesture(perform: alViewModel.showAppleLogin)
                .onChange(of: alViewModel.userIdentifier) { oldState, newState in
                    // 로그인 성공 후의 추가 동작을 수행할 수 있습니다.
                    if let ID = alViewModel.userIdentifier, let email = alViewModel.userEmail {
                        user = UserInfo(realName: alViewModel.userName ?? "", loginID : ID, socialID: [email])
                        page = .requiredInfo
                        isLoggedIn = true
                    } else {
                        print("loginError")
                    }
                }
            Spacer()
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
        LoginView(user: .constant(UserInfo(realName: "test", loginID: "test", socialID: ["myknow00@icloud.com"])), page: .constant(Page.requiredInfo), isLoggedIn: .constant(true))
    }
}
