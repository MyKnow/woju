//
//  DeviceListView.swift
//  woju
//
//  Created by 정민호 on 2/12/24.
//

import SwiftUI
import CoreBluetooth

struct DeviceListView: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    @StateObject var advertisingViewModel = AdvertisingViewModel()
    
    var body: some View {
        NavigationView {
            List(bluetoothViewModel.devices.indices, id:  \.self){ index in
                Button(action: {
                    bluetoothViewModel.connectToDevice(at : index)
                }, label: {
                    Text(bluetoothViewModel.getInfo(for : index))
                })
                .alert(isPresented: $advertisingViewModel.friendRequest, content: {
                    Alert(title: Text("님의 친구요청"),
                          primaryButton: .default(Text("수락"), action: { print("!") }),
                          secondaryButton: .cancel(Text("거절")))
                })
            }
            .navigationTitle("주변 사람")
            .toolbar {
                ToolbarItem {
                    Button(action: bluetoothViewModel.clearModel) {
                        Label("refresh", systemImage: "goforward")
                    }
                }
            }
        }
    }
}

#Preview {
    DeviceListView()
}
