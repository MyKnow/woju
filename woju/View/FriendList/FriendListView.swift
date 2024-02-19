//
//  FriendListView.swift
//  woju
//
//  Created by 정민호 on 2/15/24.
//

import SwiftUI

struct FriendListView: View {
    @State var isFriendAddActivate: Bool = false
    @State var isSettingActivate: Bool = false
    @State var isFriendInfoActivate: Bool = false
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("나")) {
                    Button(
                        action: {
                            isFriendInfoActivate.toggle()
                        },
                        label: {
                            HStack {
                                Image(systemName: "person")
                                    .frame(width: 50, height: 50)
                                    .background(Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Text("정민호")
                                    .padding()
                                Spacer()
                                VStack {
                                    Image(systemName: "heart")
                                    Text("30")
                                        .font(.footnote)
                                }
                            }
                        }
                    )
                }
                Section(header: Text("친구")) {
                    Button(
                        action: {
                            isFriendInfoActivate.toggle()
                        },
                        label: {
                            HStack {
                                Image(systemName: "person")
                                    .frame(width: 50, height: 50)
                                    .background(Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Text("정민호")
                                    .padding()
                                Spacer()
                                VStack {
                                    Image(systemName: "heart")
                                    Text("30")
                                        .font(.footnote)
                                }
                            }
                        }
                    )
                    Button(
                        action: {
                            isFriendInfoActivate.toggle()
                        },
                        label: {
                            HStack {
                                Image(systemName: "person")
                                    .frame(width: 50, height: 50)
                                    .background(Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Text("정민호")
                                    .padding()
                                Spacer()
                                VStack {
                                    Image(systemName: "heart")
                                    Text("30")
                                        .font(.footnote)
                                }
                            }
                        }
                    )
                }
            }
            .navigationTitle("친구")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(
                leading:
                    Button("친구추가",
                           systemImage: "person.fill.badge.plus",
                           action: {
                               isFriendAddActivate.toggle()
                           }
                          ),
                trailing:
                    Button("설정",
                           systemImage: "gear",
                           action: {
                               isSettingActivate.toggle()
                           }
                          )
            )
            .sheet(isPresented: $isFriendAddActivate) {
                FriendAddView()
            }
            .fullScreenCover(isPresented: $isSettingActivate) {
                SettingView()
            }
            .fullScreenCover(isPresented: $isFriendInfoActivate){
                FriendInfoView()
            }
        }
    }
}

struct FriendListView_Preview: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
