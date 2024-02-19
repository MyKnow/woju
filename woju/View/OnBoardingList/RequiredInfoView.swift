//
//  RequiredInfoView.swift
//  woju
//
//  Created by 정민호 on 2/17/24.
//

import SwiftUI

struct RequiredInfoView: View {
    @Binding var user: UserInfo?
    @Binding var page: Page
    @Binding var isLoggedIn: Bool
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var usernameIsFocused: Bool
    
    @State var nickName: String = ""
    @State var isEmpty: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section("닉네임") {
                        TextField("닉네임을 입력해주세요!", text: $nickName)
                            .keyboardType(.namePhonePad)
                            .focused($usernameIsFocused)
                            .submitLabel(.done)
                    }
                }
                HStack {
                    Button(
                        action: {
                            if user != nil {
                                if nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    print("nickName : isEmpty")
                                    isEmpty = true
                                } else {
                                    user!.nickName = nickName
                                    UserDefaultsManager.shared.isOnboarding = true
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        },
                        label: {
                            Text("건너뛰기")
                        }
                    )
                    .safeAreaPadding()
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button(
                        action: {
                            if user != nil {
                                if nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    print("nickName : isEmpty")
                                    isEmpty = true
                                } else {
                                    page = .detailInfo
                                    user!.nickName = nickName
                                }
                            }
                        },
                        label: {
                            Text("다음")
                                .safeAreaPadding()
                        }
                    )
                    .safeAreaPadding()
                    .buttonStyle(.borderless)
                }
                .frame(height: 50)
                .alert(isPresented: $isEmpty, content: {
                    Alert(title:
                            Text("닉네임을 입력해주세요!"),
                          dismissButton: .default(Text("확인"), action: {usernameIsFocused = true})
                    )
                })
            }
            .scrollDisabled(true)
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(
                leading:
                    Button("취소",
                           systemImage: "arrowshape.backward.fill",
                           action: {
                               isLoggedIn = false
                               page = .login
                           }
                  )
            )
        }
    }
}

struct RequiredInfoView_Preview: PreviewProvider {
    static var previews: some View {
        RequiredInfoView(user: .constant(UserInfo(realName: "test", loginID: "test", socialID: ["myknow00@icloud.com"])), page: .constant(Page.requiredInfo), isLoggedIn: .constant(false))
    }
}
