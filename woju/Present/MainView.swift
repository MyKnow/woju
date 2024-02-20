//
//  MainView.swift
//  woju
//
//  Created by 정민호 on 2/15/24.
//

import SwiftUI
import CoreBluetooth
import Foundation

struct MainView: View {
    @StateObject var appState = AppStateManager()
    
    @State private var selection = 2
    
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selection) {
                    FriendListView()
                        .tabItem {
                            Image(systemName: "person.2")
                            Text("친구")
                        }
                    ChatListView()
                        .tabItem {
                            Image(systemName: "bubble.fill")
                            Text("대화 목록")
                        }
                    AllFuncListView()
                        .tabItem {
                            Image(systemName: "plus.app")
                            Text("전체")
                        }
                }
            }
            .fullScreenCover(isPresented: $appState.isOnboarding.not, content: {
                    OnboardingView()
            })
        }
        .environmentObject(appState)
        .onAppear() {
            print("onBoarding : \(appState.isOnboarding), isLoggendIn : \(appState.isLoggedIn)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
