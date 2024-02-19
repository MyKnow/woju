//
//  DiscoveredDevice.swift
//  woju
//
//  Created by 정민호 on 2/12/24.
//

import CoreBluetooth
import SwiftUI

struct DiscoveredDevice: Identifiable {
    
    var id = UUID()
    
    var deviceName: String
    var deviceID : String
    var deviceInfo: CBPeripheral
    
    var rssi: Int
    
    var lastDetectDate = Date()
    var detectCount = 0
    
    var advertisementData: [String:Any]
    
    init(deviceInfo: CBPeripheral, rssi: Int, advertisementData: [String:Any]) {
        self.deviceInfo = deviceInfo
        self.rssi = rssi
        self.deviceID = deviceInfo.identifier.uuidString
        self.deviceName = deviceInfo.name ?? String(localized: "알 수 없음")
        self.advertisementData = advertisementData
    }
}

// MARK: - 만난 횟수 업데이트
extension DiscoveredDevice {
    mutating func updateDetectionInfo() {
        let currentDate = Date()
        
        let calendar = Calendar.current
        
        // 같은 날에 감지된 경우
        if calendar.isDate(currentDate, inSameDayAs: self.lastDetectDate) {
            print("이미 감지된 기기입니다.")
        }
        // 다른 날에 감지된 경우
        else {
            updateDetectDateNow()
            print("감지 횟수 증가: \(detectCount), 마지막 감지일: \(lastDetectDate)")
        }
    }
    
    mutating private func updateDetectDateNow() {
        detectCount += 1
        lastDetectDate = Date()
    }
}


