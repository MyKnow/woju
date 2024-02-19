//
//  BluetoothViewModel.swift
//  woju
//
//  Created by 정민호 on 2/12/24.
//

import SwiftUI
import Combine
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {

    // 블루투스 스캐닝에 사용되는 중앙 관리자입니다.
    private var centralManager: CBCentralManager?

    // 발견된 주변 기기 목록입니다.
    private var peripherals: [CBPeripheral] = []

    // 발견된 주변 기기의 커스텀 목록입니다.
    @Published var devices: [DiscoveredDevice] = []
    
    var isForegroundScanning = false

    override init() {
        super.init()

        // 중앙 관리자 객체를 생성하고 자신을 델리게이트로 설정합니다.
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}
//MARK: - 블루투스 기기 스캔
extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // 블루투스가 켜지면 주변 기기 스캔을 시작합니다.
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            
            print("블루투스 기기 검색 시작")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData advertisement: [String : Any], rssi RSSI: NSNumber) {
        let discoveredDevice = DiscoveredDevice(deviceInfo: peripheral, rssi: RSSI.intValue, advertisementData: advertisement)
        dump(advertisement)
        // 이미 존재하는 deviceID인지 확인
        if let existingDeviceIndex = devices.firstIndex(where: { $0.deviceID == discoveredDevice.deviceID }) {
            // 이미 존재하는 경우엔 업데이트
            devices[existingDeviceIndex] = discoveredDevice
        } else {
            // 존재하지 않으면 배열에 추가
            devices.append(discoveredDevice)
            print("기기 발견: \(discoveredDevice.deviceName)")
        }
        self.sortDevicesByName()
    }
}

//MARK: - DiscoverdDevice 사용 모델

extension BluetoothViewModel {
    func getInfo(for index: Int) -> String {
        let device = devices[index]
        return String("deviceName : \(device.deviceName)\ndeviceID : \(device.deviceID)\nrssi : \(device.rssi)")
    }
    
    // Model을 초기화하고 스캔을 껐다 켭니다(초기화)
    func clearModel() {
        self.centralManager?.stopScan()
        self.devices = []
        self.centralManager?.scanForPeripherals(withServices: nil)
    }
    
    // devices 배열을 devices.deviceInfo.name 값으로 오름차순 정렬하고 name이 nil이 아닌 요소를 상위에 표시합니다.
    func sortDevicesByName() {
        devices.sort { lhs, rhs in
            // name이 nil인 경우 맨 뒤로 보내기
            guard let lhsName = lhs.deviceInfo.name, let rhsName = rhs.deviceInfo.name else {
                return lhs.deviceInfo.name != nil
            }
          
          // name 값 비교
          return lhsName.localizedCompare(rhsName) == .orderedAscending
        }
    }
    
    // BluetoothViewModel에서 브로드캐스팅 정보를 읽어 String으로 반환하는 함수
    func getBroadcastedInfo(for device: DiscoveredDevice) -> String {
        var info = ""
        
        // 광고 데이터
        for (key, value) in device.advertisementData {
            info += "\(key): \(value)\n"
        }
        
        return info
    }
}
