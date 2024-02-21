//
//  FriendInfo.swift
//  woju
//
//  Created by 정민호 on 2/21/24.
//

import Foundation
import SwiftData

@Model
final class FriendInfo {
    var friendship: Int
    var userInfo : [UserInfo]

    init(friendship: Int, userInfo: [UserInfo]) {
        self.friendship = friendship
        self.userInfo = userInfo
    }
}
