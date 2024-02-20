//
//  LoginViewModel.swift
//  woju
//
//  Created by 정민호 on 2/18/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var user: UserInfo?
    @Published var isLoggedIn: Bool = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LoginViewModel() as! any View
}
