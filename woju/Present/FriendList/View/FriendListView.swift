//
//  FriendListView.swift
//  woju
//
//  Created by 정민호 on 2/15/24.
//

import SwiftUI

struct FriendListView: View {
    @StateObject var flViewModel = FriendInfoViewModel()
    @EnvironmentObject var appState: AppStateManager

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("나")) {
                    if let myInfo = appState.myInfo {
                        Button(action: {
                            flViewModel.isMyInfoActivate.toggle()
                        }) {
                            HStack {
                                Image(uiImage: ImageModifyManager.data2uiimage(from: myInfo.profileImage))
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .background(Color.accentColor)
                                    .cornerRadius(20)
                                    .shadow(color:.shadow, radius: 5)
                                Text(myInfo.nickName) // "나"의 정보를 appState에서 가져옴
                                    .padding()
                                Spacer()
                                Image(systemName: "chevron.right.2")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                Section(header: Text("친구")) {
                    ForEach(flViewModel.friendList.indices, id: \.self) { index in
                        Button(action: {
                            flViewModel.isFriendInfoActivate.toggle()
                        }) {
                            HStack {
                                Image(systemName: "person")
                                    .frame(width: 50, height: 50)
                                    .background(Color.accentColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                Text(flViewModel.friendList[index].userInfo.first!.nickName) // 친구의 이름
                                    .padding()
                                Spacer()
                                VStack {
                                    Image(systemName: "heart")
                                    Text("\(flViewModel.friendList[index].friendship)") // 친구의 '좋아요' 수
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("친구")
            .navigationBarItems(
                leading: Button("친구추가", action: { flViewModel.isFriendAddActivate.toggle() }),
                trailing:
                    Button("설정",
                           systemImage: "gear",
                           action: {
                               flViewModel.isSettingActivate.toggle()
                           }
                    )
            )
            .sheet(isPresented: $flViewModel.isFriendAddActivate) { FriendAddView() }
            .fullScreenCover(isPresented: $flViewModel.isSettingActivate) { SettingView() }
            .fullScreenCover(isPresented: $flViewModel.isMyInfoActivate) { MyInfoView() }
            .fullScreenCover(isPresented: $flViewModel.isFriendInfoActivate) { FriendInfoView() }
        }
        .onAppear() {
            flViewModel.setup(appState: appState)
        }
    }
}

struct FriendListView_Preview: PreviewProvider {
    static var previews: some View {
        FriendListView().environmentObject(AppStateManager())
    }
}
