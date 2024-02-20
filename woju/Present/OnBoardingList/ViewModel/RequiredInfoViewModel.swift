//
//  RequiredInfoViewModel.swift
//  woju
//
//  Created by 정민호 on 2/19/24.
//

import SwiftUI

enum ProfileImageOption {
    case defaultImage, chooseFromGallery
}

class RequiredInfoViewModel: ObservableObject {
    @Published var nickName: String = ""
    @Published var isEmpty: Bool = false
    
    @Published var isDialog: Bool = false
    @Published var isImagePicker: Bool = false
    @Published var isDefaultImage: Bool = true
    
    @Published var nowImage: UIImage = UIImage(named: "person.fill")!
    
    private var defaultImage: UIImage = UIImage(named: "person.fill")!
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var obViewModel: OnboardingViewModel?
    var appState: AppStateManager?
    
    func setup(obViewModel: OnboardingViewModel, appState: AppStateManager) {
        self.obViewModel = obViewModel
        self.appState = appState
    }
    
    func onSkip() {
        if nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("nickName : isEmpty")
            isEmpty = true
        } else {
            saveInfo()
            appState?.isOnboarding = true
        }
    }
    
    func change2DefaultImage(_ select: Bool) {
        if nowImage != defaultImage {
            self.isDefaultImage = select
            if select {
                self.nowImage = defaultImage
            }
        }
    }
    
    // UIImage를 Data로 변환
    private func saveProfileImageData(_ image: UIImage) -> Data? {
        if let imageData = image.jpegData(compressionQuality: 1.0){
            if isDefaultImage {
                return nil
            } else {
                return imageData
            }
        }
        return nil
    }
    
    func onNext() {
        if nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("nickName : isEmpty")
            isEmpty = true
        } else {
            obViewModel?.page = .detailInfo
            saveInfo()
        }
    }
    
    func saveInfo() {
        appState?.myInfo?.nickName = nickName
        appState?.myInfo?.profileImage = self.saveProfileImageData(self.nowImage)
        print("Required : \(appState?.myInfo)")
    }
    
    func onCancle() {
        appState?.isLoggedIn = false
        obViewModel?.page = .login
    }
}
