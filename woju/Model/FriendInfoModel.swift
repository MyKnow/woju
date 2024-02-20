//
//  FriendInfo.swift
//  woju
//
//  Created by 정민호 on 2/16/24.
//

import Foundation
import SwiftUI

struct FriendInfo: Identifiable, Codable {
    var id = UUID()
    
    var friendship: Int
    var userInfo : [UserInfo]
}
