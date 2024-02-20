//
//  FriendAddView.swift
//  woju
//
//  Created by 정민호 on 2/15/24.
//

import SwiftUI

struct FriendAddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Spacer()
            Button("취소",
               action: {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .safeAreaPadding()
        }
        Section() {
            Image("woju")
                .resizable(resizingMode: .stretch)
                .frame(width: 100, height: /*@START_MENU_TOKEN@*/100)
            Text("아이폰의 상단부를 서로 맞대어주세요")
        }
//        NavigationView {
//            List {
//                Section(header: Text("새로운 사람에게 요청")) {
//                    Text("3")
//                    Text("4")
//                    Text("5")
//                    Text("6")
//                }
//            }
//            .navigationTitle("친구")
//            .navigationBarTitleDisplayMode(.automatic)
//        }
        DeviceListView()
    }
}

#Preview {
    FriendAddView().environmentObject(AppStateManager())
}
