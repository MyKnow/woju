//
//  AdvertisingViewModel.swift
//  woju
//
//  Created by 정민호 on 2/13/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

class AdvertisingViewModel: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    
    // CBPeripheralManager 인스턴스
    private var peripheralManager: CBPeripheralManager?
    
    // 현재 Advertising 상태
    @Published var isAdvertising = false
    
    
    // Advertising 시작 시 에러
    @Published var error: Error?
    
    override init() {
        super.init()
        
        // CBPeripheralManager 초기화
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    // Advertising 시작
    func startAdvertising() {
        // CBPeripheralManager 인스턴스를 초기화 못 한 경우엔 시작 금지
        guard let peripheralManager = peripheralManager else {
            print("ERROR :: peripheralManager init error")
            return
        }
        
        // Advertising 정보 생성
        let advertisementData = createAdvertisementData()
        
        // Advertising 시작
        peripheralManager.startAdvertising(advertisementData)
    }

    
    // Advertising 중지
    func stopAdvertising() {
        // CBPeripheralManager 인스턴스를 초기화 못 한 경우엔 중지 금지
        guard let peripheralManager = peripheralManager else {
            return
        }
        
        peripheralManager.stopAdvertising()
    }

    
    // Advertising 정보 생성
    private func createAdvertisementData() -> [String: Any] {
        // 서비스 UUID (임의로 설정)
        let serviceUUID = CBUUID(string: "72306201-7746-49E4-9F68-6119BF859132")
        
        return [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
            CBAdvertisementDataLocalNameKey: "정민호",
        ]
    }
    
    // MARK: - CBPeripheralManagerDelegate
    
    func peripheralManagerDidUpdateState(_ peripheralManager: CBPeripheralManager) {
        if peripheralManager.state == .poweredOn {
            // 블루투스가 켜지면 Advertising 시작
            print("Advertising Start")
            startAdvertising()
        } else {
            // Advertising 중지
            print("Advertising Stop")
            stopAdvertising()
            
            // 에러 설정
            error = NSError(domain: "com.myknow.woju", code: 1, userInfo: [NSLocalizedDescriptionKey: "블루투스가 꺼져 있습니다."])
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheralManager: CBPeripheralManager, error: Error?) {
        if let error = error {
            self.error = error
            return
        }
        
        // Advertising 시작 성공
        isAdvertising = true
    }
}
