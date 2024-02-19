//
//  FriendInfoInnerView.swift
//  woju
//
//  Created by 정민호 on 2/16/24.
//

import SwiftUI

struct FriendInfoInnerView: View {
    var pages: [UserInfo]
    var body: some View {
        List {
            VStack {
                Spacer()
                Image("woju")
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal, count: pages.count, span: pages.count, spacing: 0)
            }
            Section("이름") {
                Text("!")
                Text("!")
            }
            Section("성별") {
                Text("!")
                Text("!")
            }
            Section("주소") {
                Text("!")
                Text("!")
            }
            Section("소셜 아이디") {
                Text("!")
                Text("!")
            }
        }
        .background(Color.gray)
    }
}

#Preview {
    FriendInfoInnerView(pages: [UserInfo(realName: "test", loginID: "test", socialID: ["myknow00@icloud.com"])])
}
