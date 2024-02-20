//
//  FriendInfoViewModel.swift
//  woju
//
//  Created by 정민호 on 2/20/24.
//

import SwiftUI
import Foundation

class FriendInfoViewModel: ObservableObject {
    var appState: AppStateManager?
    
    @Published var isFriendAddActivate: Bool = false
    @Published var isSettingActivate: Bool = false
    @Published var isFriendInfoActivate: Bool = false
    @Published var isMyInfoActivate: Bool = false
    
    @Published var friendList: [FriendInfo] = UserDefaultsManager.getFriendList()
    
    func setup(appState: AppStateManager) {
        self.appState = appState
    }
    
    
}
