//
//  RequiredInfoView.swift
//  woju
//
//  Created by 정민호 on 2/17/24.
//

import SwiftUI

struct RequiredInfoView: View {
    @EnvironmentObject var obViewModel: OnboardingViewModel
    @EnvironmentObject var appState: AppStateManager
    
    @StateObject var riViewModel = RequiredInfoViewModel()
    
    @FocusState private var usernameIsFocused: Bool
    
    @State var act:Bool = false
    @State var text:String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section() {
                        Button(action: {
                            riViewModel.isDialog = true
                        }, label: {
                                Image(uiImage: riViewModel.nowImage)
                                    .resizable()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .background(Color.accentColor)
                                    .cornerRadius(50)
                                    .shadow(color:.shadow, radius: 10)
                                    .frame(width: 250, height: 250) // 이미지 크기 지정
                        })
                        .shadow(color: (riViewModel.isDefaultImage ? .clear : .black), radius: (riViewModel.isDefaultImage ? 0 : 5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                    .listRowBackground(Color.clear)
                    Section("닉네임") {
                        TextField("닉네임을 입력해주세요!", text: $riViewModel.nickName)
                            .keyboardType(.namePhonePad)
                            .focused($usernameIsFocused)
                            .submitLabel(.done)
                    }
                    Button(action: {
                        act = true
                        text = (appState.myInfo!.socialID?.first!.socialID)!
                    }, label: {
                        Text("Button")
                    })
                    .alert(isPresented: $act, content: {
                        Alert(title: Text(text))
                    })
                    Button(action: {
                        appState.logout()
                        appState.userDataDelete()
                    }, label: {
                        Text("Button2")
                    })
                }
                HStack {
                    Button(
                        action: { riViewModel.onSkip()
                        },
                        label: {
                            Text("건너뛰기")
                        }
                    )
                    .safeAreaPadding()
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button(
                        action: { riViewModel.onNext() },
                        label: {
                            Text("다음")
                                .safeAreaPadding()
                        }
                    )
                    .safeAreaPadding()
                    .buttonStyle(.borderless)
                }
                .frame(height: 50)
                .alert(isPresented: $riViewModel.isEmpty, content: {
                    Alert(title:
                            Text("닉네임을 입력해주세요!"),
                          dismissButton: .default(Text("확인"), action: { usernameIsFocused = true })
                    )
                })
            }
            .scrollDisabled(true)
            .navigationTitle("회원가입 - 필수항목")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(
                leading:
                    Button("취소",
                           systemImage: "arrowshape.backward.fill",
                           action: { riViewModel.onCancle() }
                  )
            )
        }
        .onAppear() {
            self.riViewModel.setup(obViewModel: obViewModel, appState: appState)
        }
        .sheet(isPresented: $riViewModel.isImagePicker, 
               onDismiss: {
                    riViewModel.change2DefaultImage(false)
                },
               content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $riViewModel.nowImage)
                }
        )
        .confirmationDialog("프로필 이미지", isPresented: $riViewModel.isDialog) {
            Button("기본 이미지") {
                riViewModel.change2DefaultImage(true)
            }
            Button("앨범에서 선택") {
                riViewModel.isImagePicker = true
            }
        }
    }
}

struct RequiredInfoView_Preview: PreviewProvider {
    static var previews: some View {
        RequiredInfoView()
            .environmentObject(AppStateManager())
            .environmentObject(OnboardingViewModel())
    }
}
