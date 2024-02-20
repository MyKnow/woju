//
//  DetailInfoViewModel.swift
//  woju
//
//  Created by 정민호 on 2/19/24.
//

import SwiftUI

enum Field{
    case realName
    case phoneNumber
    case gender
    case socialID
    case readMe
}

class DetailInfoViewModel: ObservableObject {
    @Environment(\.presentationMode) var presentationMode
    
    @Published var realName: String = ""
    @Published var phoneNumber: String = ""
    @Published var gender: String = "기타"
    @Published var socialIDs: [SocialID] = []
    @Published var socialID: String = ""
    @Published var newSocialApp: String = ""
    @Published var newSocialID: String = ""
    @Published var readme: String = ""
    
    let genders = ["남자", "여자", "기타"]
    let socialApps = ["인스타그램", "카카오톡", "페이스북", "Threads", "X", "기타"]
    
    var appState: AppStateManager?
    var obViewModel: OnboardingViewModel?
    
    func setup(appState: AppStateManager, obViewModel: OnboardingViewModel){
        self.appState = appState
        self.obViewModel = obViewModel
    }
    
    func removeSocialID(_ index: IndexSet) {
        self.socialIDs.remove(atOffsets: index)
    }
    
    func appendSocialID() {
        print("button")
        // 기본값을 가진 SocialID 객체 생성
        let newSocialID = SocialID(socialType: "인스타그램", socialID: "")
        
        // socialIDs 배열에 추가
        socialIDs.append(newSocialID)
        dump(socialIDs)
        print(socialIDs)
    }
    
    func updateSocialID(at index: Int, newID: String) {
        // 인덱스 범위 검사
        guard index >= 0 && index < socialIDs.count else { return }
        
        // SocialID 인스턴스 업데이트
        socialIDs[index].socialID = newID
      }
    
    func filterEmptySocialIDs() {
      // socialID가 공백이 아닌 요소만 필터링하여 새로운 배열 생성
        let filteredSocialIDs = self.socialIDs.filter { $0.socialID != "" }
      
        for socialID in filteredSocialIDs {
            appState?.myInfo?.socialID?.append(socialID)
        }
    }
    
    
    func onDone() {

      // realName, phoneNumber, readMe 공백 검사 및 nil 대입
      if realName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          appState?.myInfo?.realName = nil
      } else {
          appState?.myInfo?.realName = realName
      }
      if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          appState?.myInfo?.phoneNumber = nil
      } else {
          appState?.myInfo?.phoneNumber = phoneNumber
      }
      if readme.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          appState?.myInfo?.readme = nil
      } else {
          appState?.myInfo?.readme = readme
      }
        filterEmptySocialIDs()
        
        print(appState?.myInfo)
        
        appState?.isOnboarding = true
        obViewModel?.page = .done
    }

    
    func onCancle() {
        obViewModel?.page = .requiredInfo
    }
}
