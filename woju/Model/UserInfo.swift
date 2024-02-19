//
//  UserInfo.swift
//  woju
//
//  Created by 정민호 on 2/11/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

struct UserInfo: Identifiable, Codable {
    var id: String = UIDevice.current.identifierForVendor!.uuidString // CoreBluetooth uuid로 구현하려했는데 유감스럽게도 차후에 구현하기로 했음
    var realName : String?
    var loginID: String?
    
    var socialID : [String]?
    var nickName : String?
    var phoneNumber : String?
    var gender : Bool?
    
    var readme : String?
    var profile : Data?
    
    init(realName: String, loginID: String, socialID: [String]? = nil, nickName: String? = nil, phoneNumber: String? = nil,  gender: Bool? = nil, readme: String? = nil, profile: Data? = nil) {
        self.loginID = loginID
        self.realName = realName
        self.nickName = nickName
        self.gender = gender
        self.phoneNumber = phoneNumber
        self.socialID = socialID
        self.readme = readme
        self.profile = profile
    }
}

extension UserInfo {
    
}
