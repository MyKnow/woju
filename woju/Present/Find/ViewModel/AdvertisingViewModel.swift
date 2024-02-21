//
//  AdvertisingViewModel.swift
//  woju
//
//  Created by 정민호 on 2/13/24.
//

import Foundation
import CoreBluetooth
import SwiftUI

class AdvertisingViewModel: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    private var peripheralManager: CBPeripheralManager?
    private var transferServiceUUID: CBUUID!
    private var transferCharacteristic: CBMutableCharacteristic?
    
    @Published var isAdvertising = false
    @Published var error: Error?
    
    @Published var friendRequest: Bool = false
    @Published var userInfo: UserInfo?
    @Published var transmitDevice: CBPeripheralManager?
    
    override init() {
        super.init()
        
        transferServiceUUID = CBUUID(string: BTUUID.service.rawValue)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startAdvertising() {
        guard let peripheralManager = peripheralManager, peripheralManager.state == .poweredOn else {
            self.error = NSError(domain: "com.myknow.woju", code: 0, userInfo: [NSLocalizedDescriptionKey: "PeripheralManager is not ready"])
            return
        }
        
        let transferService = CBMutableService(type: transferServiceUUID, primary: true)
        
        // 쓰기 가능한 캐릭터리스틱 생성
        transferCharacteristic = CBMutableCharacteristic(type: CBUUID(string: BTUUID.connecting.rawValue), properties: [.write, .notify], value: nil, permissions: [.writeable])
        
        // 서비스에 캐릭터리스틱 추가
        transferService.characteristics = [transferCharacteristic!]
        
        // Peripheral Manager에 서비스 추가
        peripheralManager.add(transferService)
        
        // Advertising 시작
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [transferServiceUUID], CBAdvertisementDataLocalNameKey: "정민호"])
    }
    
    func stopAdvertising() {
        peripheralManager?.stopAdvertising()
    }
    
    // MARK: - CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Bluetooth is powered on and ready for advertising")
            startAdvertising()
        } else {
            print("Bluetooth is not available.")
            stopAdvertising()
            self.error = NSError(domain: "com.myknow.woju", code: 1, userInfo: [NSLocalizedDescriptionKey: "블루투스가 꺼져 있습니다."])
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            self.error = error
            return
        }
        isAdvertising = true
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value, let stringFromData = String(data: value, encoding: .utf8) {
                print("Received data: \(stringFromData)")
                
                // "Request" 문자열을 받으면 friendRequest를 true로 설정
                if stringFromData == "Request" {
                    self.transmitDevice = peripheral
                    self.friendRequest = true
                } else {
                    // UserInfo 객체로의 변환 시도
                    do {
                        let userData = try JSONDecoder().decode(UserInfo.self, from: value)
                        self.userInfo = userData
                        if let user = self.userInfo{
                            FriendInfoDataManager.shared.appendItem(item: FriendInfo(friendship: 0, userInfo: [user]))
                        }
                    } catch {
                        print("Error decoding UserInfo: \(error)")
                    }
                }
                peripheral.respond(to: request, withResult: .success)
            }
        }
    }

}
