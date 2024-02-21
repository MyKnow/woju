//
//  UserInfo.swift
//  woju
//
//  Created by 정민호 on 2/11/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

struct SocialID:Identifiable, Codable{
    var id = UUID()
    var socialType: String
    var socialID: String
}

struct UserInfo: Identifiable, Codable {
    var id: String = UIDevice.current.identifierForVendor!.uuidString // CoreBluetooth uuid로 구현하려했는데 유감스럽게도 차후에 구현하기로 했음
    var profileImage : Data?
    var nickName : String
    
    var realName : String?
    var phoneNumber : String?
    var gender : String?
    var socialID : [SocialID]?
    
    var readme : String?
}
