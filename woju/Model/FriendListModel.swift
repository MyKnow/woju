//
//  FriendListModel.swift
//  woju
//
//  Created by 정민호 on 2/16/24.
//

import Foundation
import SwiftUI

struct FriendList: Identifiable, Codable {
    var id: String
    
    var uuid: String?
    var realName : String?
    var nickName : String?
    var gender : Bool?
    var phoneNumber : String?
    var socialID : [String]?
    var readme : String?
    var profile : Data?
}
