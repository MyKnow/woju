//
//  DeviceListView.swift
//  woju
//
//  Created by 정민호 on 2/12/24.
//

import SwiftUI
import CoreBluetooth

struct DeviceListView: View {
    @ObservedObject private var bluetothViewModel = BluetoothViewModel()
    @StateObject var advertisingViewModel = AdvertisingViewModel()

    var body: some View {
        NavigationView {
            List(bluetothViewModel.devices.indices, id:  \.self){ index in
                NavigationLink {
                    Spacer()
                    Text("id : \(bluetothViewModel.devices[index].id)")
                    Spacer()
                    Text("rssi : \(bluetothViewModel.devices[index].rssi)")
                    Spacer()
                    Text("deviceID : \(bluetothViewModel.devices[index].deviceID)")
                    Spacer()
                    Text("deviceInfo : \(bluetothViewModel.devices[index].deviceInfo)")
                    Spacer()
                    Text("detectCount : \(bluetothViewModel.devices[index].detectCount)")
                    Spacer()
                    Text("lastDetectDate : \(bluetothViewModel.devices[index].lastDetectDate)")
                    Spacer()
                    Text("Info : \(bluetothViewModel.getBroadcastedInfo(for: bluetothViewModel.devices[index]))")
                    Spacer()
                } label: {
                    Text(bluetothViewModel.getInfo(for : index))
                }
            }
            .navigationTitle("주변 사람")
            .toolbar {
                ToolbarItem {
                    Button(action: bluetothViewModel.clearModel) {
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
