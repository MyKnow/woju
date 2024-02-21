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
    
    private let friendInfoDataManager: FriendInfoDataManager
    
    @Published var friendList: [FriendInfo] = []
    
    init(friendInfoDataManger: FriendInfoDataManager = FriendInfoDataManager.shared) {
        self.friendInfoDataManager = friendInfoDataManger
        friendList = friendInfoDataManager.fetchItems()
    }
    
    func setup(appState: AppStateManager) {
        self.appState = appState
    }
    
    func appendItem(friendInfo : FriendInfo) {
        friendInfoDataManager.appendItem(item: friendInfo)
    }

    func removeItem(_ index: Int) {
        friendInfoDataManager.removeItem(friendList[index])
    }
}
