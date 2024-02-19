//
//  DetailInfoView.swift
//  woju
//
//  Created by 정민호 on 2/17/24.
//

import SwiftUI

enum Social {
    case kakaotalk
    case instagram
    case facebook
    case threads
    case x
    case etc
}

struct SocialID:Identifiable{
    let id = UUID()
    let socialType: Social
    let socialID: String
}

struct DetailInfoView: View {
    enum Field{
        case realName
        case phoneNumber
        case gender
        case socialID
        case readMe
    }
    
    @Binding var user: UserInfo?
    @Binding var page: Page
    @Binding var isLoggedIn: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var focusedField: Field?
    
    @State var realName: String = ""
    @State var phoneNumber: String = ""
    @State var gender: String = "기타"
    @State var socialIDs: [SocialID] = [SocialID(socialType: .kakaotalk, socialID: "myknow"), SocialID(socialType: .kakaotalk, socialID: "myknow")]
    @State var socialID: String = ""
    @State var newSocialApp: String = ""
    @State var newSocialID: String = ""
    @State var readMe: String = ""
    
    let genders = ["남자", "여자", "기타"]
    let socialApps = ["인스타그램", "카카오톡", "페이스북", "Threads", "X", "기타"]
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section("이름") {
                        TextField("실명을 입력해주세요", text: $realName)
                            .focused($focusedField, equals: .realName)
                            .textContentType(.name)
                            .submitLabel(.next)
                            .keyboardType(.namePhonePad)
                    }
                    Section("전화번호") {
                        TextField("전화번호를 입력해주세요", text: $phoneNumber)
                            .focused($focusedField, equals: .phoneNumber)
                            .textContentType(.telephoneNumber)
                            .submitLabel(.next)
                            .keyboardType(.phonePad)
                            
                    }
                    Section("성별") {
                        Picker("성별을 골라주세요", selection: $gender) {
                          ForEach(genders, id: \.self) { item in
                              Text(item)
                          }
                        }
                        .pickerStyle(.segmented)
                        
                    }
                    Section{
                        ForEach(socialIDs) { index in
                            HStack {
                                Picker("", selection: $newSocialApp) {
                                    ForEach(socialApps, id: \.self) { Text($0) }
                                }
                                .pickerStyle(.automatic)
                                .fixedSize(horizontal: true, vertical: false)
                                Divider()
                                TextField("소셜 아이디를 입력해주세요", text: $socialID)
                                    .focused($focusedField, equals: .socialID)
                                    .submitLabel(.next)
                                    .keyboardType(.twitter)
                            }
                        }.onDelete(perform: { indexSet in
                            socialIDs.remove(atOffsets: indexSet)
                        })
                        
                        Button {
                            socialIDs.append(SocialID(socialType: .etc, socialID: ""))
                        } label: {
                            HStack{
                                Text("소셜 아이디 추가")
                                    .padding(.leading)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }

                    } header: {
                        Text("소셜 아이디")
                    } footer : {
                          Text("항목을 왼쪽으로 스와이프하면 삭제할 수 있습니다")
                    }
                    Section("자기소개") {
                        TextEditor(text: $readMe)
                            .focused($focusedField, equals: .readMe)
                            .keyboardType(.default)
                    }
                }
                .onSubmit {
                    switch focusedField {
                    case .realName:
                        focusedField = .phoneNumber
                    case .phoneNumber:
                        focusedField = .socialID
                    case .socialID:
                        focusedField = .readMe
                    default:
                        print("Done")
                    }
                }
                Spacer()
                Button(
                    action: {
                        UserDefaultsManager.shared.isOnboarding = true
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Text("다음")
                            .safeAreaPadding()
                    })
                }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(
                leading:
                    Button("취소",
                           systemImage: "arrowshape.backward.fill",
                           action: {
                               page = .requiredInfo
                           }
                  )
            )}
        }
}

struct DetailInfoView_Preview: PreviewProvider {
    static var previews: some View {
        DetailInfoView(user: .constant(UserInfo(realName: "test", loginID: "test", socialID: ["myknow00@icloud.com"])), page: .constant(Page.requiredInfo), isLoggedIn: .constant(false))
    }
}

