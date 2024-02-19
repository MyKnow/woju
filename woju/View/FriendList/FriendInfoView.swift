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
    
    private var test: [UserInfo] = [UserInfo(realName: "test", loginID: "test", socialID: ["myknow00@icloud.com"])]
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(test.indices, id:\.self) { image in
                            FriendInfoInnerView(pages: test)
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
