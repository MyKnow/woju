//
//  MyInfoView.swift
//  woju
//
//  Created by 정민호 on 2/20/24.
//

import SwiftUI

struct MyInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditMode: Bool = false
    @EnvironmentObject var appState : AppStateManager
    
    private var friendship = 30
    
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        if let myInfo = Binding($appState.myInfo) {
                            FriendInfoInnerView(pages: myInfo, friendship: -1)
                                .frame(width: g.size.width, height: g.size.height, alignment: .top)
                        }
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
    MyInfoView().environmentObject(AppStateManager())
}
