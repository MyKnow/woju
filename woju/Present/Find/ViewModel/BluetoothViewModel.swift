//
//  BluetoothViewModel.swift
//  woju
//
//  Created by 정민호 on 2/12/24.
//

import SwiftUI
import Combine
import CoreBluetooth

enum BTUUID : String {
    case service = "72306201-7746-49E4-9F68-6119BF859132"
    case connecting = "1505ADD2-467C-45F4-8114-12AF3ED080A8"
}

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
        // 광고 데이터 중 서비스 UUIDs를 확인합니다.
        if let serviceUUIDs = advertisement[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            // 특정 UUID를 정의합니다.
            let specificUUID = CBUUID(string: BTUUID.service.rawValue)
            
            // 서비스 UUIDs 리스트에 특정 UUID가 포함되어 있는지 확인합니다.
            if serviceUUIDs.contains(specificUUID) {
                let discoveredDevice = DiscoveredDevice(deviceInfo: peripheral, rssi: RSSI.intValue, advertisementData: advertisement)
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
    }

}

//MARK: - 블루투스 기기 연결

extension BluetoothViewModel : CBPeripheralDelegate {
    // 연결이 성공했을 때 호출됩니다.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("기기와 연결됨: \(peripheral.name ?? "")")
        
        // 중요: 연결된 Peripheral의 delegate를 설정합니다.
        peripheral.delegate = self
        
        // 서비스 탐색 시작
        peripheral.discoverServices(nil)
    }

    // 연결 시도가 실패했을 때 호출됩니다.
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("기기와 연결 실패: \(peripheral.name ?? ""), 오류: \(error?.localizedDescription ?? "알 수 없음")")
    }

    // 연결이 해제되었을 때 호출됩니다.
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("기기 연결 해제: \(peripheral.name ?? ""), 오류: \(error?.localizedDescription ?? "없음")")
    }
    
    // 서비스를 발견했을 때 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            // 특정 캐릭터리스틱 UUID를 지정하여 캐릭터리스틱을 찾습니다.
            peripheral.discoverCharacteristics(nil, for: service) // 특정 캐릭터리스틱 UUID를 지정할 수도 있습니다.
        }
    }

    // 캐릭터리스틱을 발견했을 때 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.write) {
                // 친구요청
                let friendRequestData = "Request".data(using: .utf8)!
                peripheral.writeValue(friendRequestData, for: characteristic, type: .withResponse)
            }
        }
    }
    
    // 캐릭터리스틱에 데이터 쓰기 요청에 대한 응답을 처리하는 메서드
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Error writing characteristic value: \(error.localizedDescription)")
        } else {
            print("Successfully wrote value for characteristic \(characteristic.uuid)")
        }
    }
}

//MARK: - DiscoverdDevice 사용 모델

extension BluetoothViewModel {
    func getInfo(for index: Int) -> String {
        let device = devices[index]
        return String("deviceName : \(device.deviceName)\ndeviceID : \(device.deviceID)\nrssi : \(device.rssi)")
    }
    
    func connectToDevice(at index: Int) {
        guard index >= 0 && index < devices.count else {
            print("잘못된 인덱스입니다.")
            return
        }
        print(devices[index].deviceInfo)
        let deviceToConnect = devices[index].deviceInfo
        centralManager?.connect(deviceToConnect, options: nil)
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
