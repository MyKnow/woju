//
//  ChatListView.swift
//  woju
//
//  Created by 정민호 on 2/15/24.
//

import SwiftUI

struct ChatListView: View {
    @State var isSettingActivate: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("가")) {
                    Text("1")
                    Text("2")
                }
                Section(header: Text("나")) {
                    Text("3")
                    Text("4")
                }
                Section(header: Text("다")) {
                    Text("5")
                    Text("6")
                }
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationViewStyle(.automatic)
            .navigationBarItems(
                trailing:
                    Button("설정",
                           systemImage: "gear",
                           action: {
                               isSettingActivate.toggle()
                           }
                    )
            )
        }
        .fullScreenCover(isPresented: $isSettingActivate) {
            SettingView()
        }
    }
}

struct ChatListView_Preview: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
