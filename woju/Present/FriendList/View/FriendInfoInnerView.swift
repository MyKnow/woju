//
//  FriendInfoInnerView.swift
//  woju
//
//  Created by 정민호 on 2/16/24.
//

import SwiftUI

struct FriendInfoInnerView: View {
    @Binding var pages: UserInfo
    var friendship : Int
    
    @State var isDialog: Bool = false
    @State var isImagePicker: Bool = false
    @State var nowImage: UIImage = UIImage()
    
    var body: some View {
        List {
            ZStack(alignment: .top, content: {
                VStack {
                    Button(action: {
                        isDialog = true
                        
                    }, label: {
                        Image(uiImage: nowImage)
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .background(Color.accentColor)
                            .cornerRadius(50)
                            .shadow(color:.shadow, radius: 10)
                    })
                }.listRowBackground(Color.clear)
                    .padding(.top,60)
                    .padding(.bottom)
                Section() {
                    HStack {
                        Text(pages.nickName)
                            .font(.largeTitle)
                            .fontWeight(.black)
                        Spacer()
                        VStack {
                            Image(systemName: "heart")
                            Text("\(friendship)")
                        }
                    }.background(.clear)
                }.listRowBackground(Color.clear)
            }).listRowBackground(Color.clear)
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
        .sheet(isPresented: $isImagePicker,
               onDismiss: {
            pages.profileImage = ImageModifyManager.uiimage2data(from: nowImage)
        },
           content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $nowImage)
            }
        )
        .confirmationDialog("프로필 이미지", isPresented: $isDialog) {
            Button("기본 이미지") {
                nowImage = UIImage(named: "person.fill")!
                pages.profileImage = ImageModifyManager.uiimage2data(from: nowImage)
            }
            Button("앨범에서 선택") {
                isImagePicker = true
            }
        }
        .onAppear() {
            nowImage = ImageModifyManager.data2uiimage(from: pages.profileImage)
        }
    }
}

#Preview {
    FriendInfoInnerView(pages: .constant(UserInfo(nickName: "test", socialID: [SocialID(socialType: "기타", socialID: "myknow00@icloud.com")])), friendship: 10)
}
