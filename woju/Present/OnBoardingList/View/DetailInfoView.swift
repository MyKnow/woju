//
//  DetailInfoView.swift
//  woju
//
//  Created by 정민호 on 2/17/24.
//

import SwiftUI



struct DetailInfoView: View {
    @StateObject var diViewModel = DetailInfoViewModel()
    @ObservedObject var obViewModel: OnboardingViewModel
    
    @EnvironmentObject var appState : AppStateManager
    
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    Section("이름") {
                        TextField("실명을 입력해주세요", text: $diViewModel.realName)
                            .focused($focusedField, equals: .realName)
                            .textContentType(.name)
                            .submitLabel(.next)
                            .keyboardType(.namePhonePad)
                    }
                    Section("전화번호") {
                        TextField("전화번호를 입력해주세요", text: $diViewModel.phoneNumber)
                            .focused($focusedField, equals: .phoneNumber)
                            .textContentType(.telephoneNumber)
                            .submitLabel(.next)
                            .keyboardType(.phonePad)
                            
                    }
                    Section("성별") {
                        Picker("성별을 골라주세요", selection: $diViewModel.gender) {
                            ForEach(diViewModel.genders, id: \.self) { item in
                              Text(item)
                          }
                        }
                        .pickerStyle(.segmented)
                        
                    }
                    Section{
                        ForEach(Array(zip(diViewModel.socialIDs.indices, diViewModel.socialIDs)), id: \.0) { index, item in
                          HStack {
                            Picker("", selection: $diViewModel.socialIDs[index].socialType){
                                ForEach(diViewModel.socialApps, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.automatic)
                            .fixedSize(horizontal: true, vertical: false)
                            Divider()
                            TextField("소셜 아이디를 입력해주세요", text: Binding(
                              get: { diViewModel.socialIDs[index].socialID },
                              set: { diViewModel.updateSocialID(at: index, newID: $0) }
                            ))
                            .focused($focusedField, equals: .socialID)
                            .submitLabel(.next)
                            .keyboardType(.emailAddress)
                          }
                        }.onDelete(perform: { indexSet in
                            diViewModel.removeSocialID(indexSet)
                        })
                        
                        Button {
                            diViewModel.appendSocialID()
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
                        TextEditor(text: $diViewModel.readme)
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
                HStack {
                    Button(
                        action: {
                            diViewModel.onDone()
                        },
                        label: {
                            Text("완료")
                                .padding(8)
                        }).buttonStyle(.borderedProminent)
                        .safeAreaPadding(3)
                    }
                }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(
                leading:
                    Button("취소",
                           systemImage: "arrowshape.backward.fill",
                           action: {
                               diViewModel.onCancle()
                           }
                  )
            )}.onAppear() {
                self.diViewModel.setup(appState: appState, obViewModel: obViewModel)
            }
    }
}

struct DetailInfoView_Preview: PreviewProvider {
    static var previews: some View {
        DetailInfoView(obViewModel: OnboardingViewModel())
            .environmentObject(AppStateManager())
    }
}

