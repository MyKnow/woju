//
//  UserDefaultsManager.swift
//  woju
//
//  Created by 정민호 on 2/18/24.
//

import Foundation
import SwiftUI

class UserDefaultsManager: ObservableObject{
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    // 로그인 여부 확인
    var isLoggedIn: Bool {
      get {
          return userDefaults.bool(forKey: "isLoggedIn")
      }
      set {
          userDefaults.set(newValue, forKey: "isLoggedIn")
      }
    }
    
    // 온보딩 여부 확인
    var isOnboarding: Bool {
        get {
            return userDefaults.bool(forKey: "isOnboarding")
        }
        set {
            userDefaults.set(newValue, forKey: "isOnboarding")
        }
    }

    // 내 정보 저장
    class func saveUserInfo(user: UserInfo) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "myInfo")
        }
    }

    // 내 정보 불러오기
    class func getUserInfo() -> (UserInfo?) {
        if let savedData = UserDefaults.standard.object(forKey: "myInfo") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(UserInfo.self, from: savedData) {
                print(savedObject) // Person(name: "jake", age: 20)
                return savedObject
            }
        }
        return nil
    }

    // 로그아웃
    func logout() {
        isLoggedIn = false
        isOnboarding = false
        userDefaults.removeObject(forKey: "userInfo")
        print("Logout")
    }
}

struct testView: View {
    var body: some View {
        Button(action: {
            UserDefaultsManager.saveUserInfo(user: UserInfo(realName: "test", loginID: "test", socialID: ["myknow00@icloud.com"]))
        }, label: {
            Text("Button")
        })
        Button(action: {
            UserDefaultsManager.getUserInfo()
        }, label: {
            Text("Button")
        })
    }
}

#Preview {
    testView()
}
