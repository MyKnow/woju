//
//  SettingView.swift
//  woju
//
//  Created by 정민호 on 2/16/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppStateModel
    
    var body: some View {
        NavigationView {
            VStack{
                Button("Logout") {
                    self.presentationMode.wrappedValue.dismiss()
                    appState.logout()
                }
                Spacer()
                Button("onboarding") {
                    self.presentationMode.wrappedValue.dismiss()
                    appState.isOnboarding = false
                }
            }
        }
    }
}

struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
