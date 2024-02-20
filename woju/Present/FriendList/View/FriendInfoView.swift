//
//  FriendInfoView.swift
//  woju
//
//  Created by 정민호 on 2/16/24.
//

import SwiftUI

struct FriendInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditMode: Bool = false
    
    @State var test: [UserInfo] = [UserInfo(nickName: "test", socialID: [SocialID(socialType: "기타", socialID: "myknow00@icloud.com")])] // 추후 상위 뷰에서 데이터를 가져오는 것으로 변경할 예정
    private var friendship = 30
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(zip(test.indices, test)), id: \.0) { index, item in
                            FriendInfoInnerView(pages: $test[index], friendship: friendship)
                        }.frame(width: g.size.width, height: g.size.height, alignment: .top)
                    }
                    .ignoresSafeArea()
                }
                .navigationBarItems(
                    leading:
                        Button(
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            label: {
                                Image(systemName: "arrowshape.turn.up.backward.fill")
                            }
                        ),
                    trailing:
                        Button(
                            action: {
                                self.isEditMode.toggle()
                            },
                            label: {
                                Text("편집")
                                    .padding()
                            }
                        )
                )
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
            }
        }
    }
}

#Preview {
    FriendInfoView()
}
