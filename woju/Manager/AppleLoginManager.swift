//
//  AppleLoginManager.swift
//  woju
//
//  Created by 정민호 on 2/12/24.
//

import SwiftUI
import AuthenticationServices

class AppleLoginManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    @Published var userIdentifier: String?
    @Published var userName: String?
    @Published var userEmail: String?
    
    var appState: AppStateManager?
    var obViewModel: OnboardingViewModel?
    
    func setup(appState: AppStateManager, obViewModel: OnboardingViewModel) {
        self.appState = appState
        self.obViewModel = obViewModel
    }

    // Sign in with Apple 기능을 사용하여 Apple ID로 로그인을 시도하는 함수
    func showAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            dump(fullName)
            print(fullName)
            
            if let email = appleIDCredential.email {
                self.userEmail = email
            }
            else {
                // credential.identityToken은 jwt로 되어있고, 해당 토큰을 decode 후 email에 접근해야한다.
                if let tokenString = String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8) {
                    let email2 = Utils.decode(jwtToken: tokenString)["email"] as? String ?? ""
                    self.userEmail = email2
                }
            }
            
            if let identityToken = appleIDCredential.identityToken,
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                KeychainManager.create(key: "userIDToken", value: identifyTokenString)
            }
            
            // 사용자 정보를 출력
            print("User ID: \(userIdentifier)")
            KeychainManager.create(key: "userID", value: userIdentifier)
            
            // ViewModel의 속성 업데이트
            if let id = KeychainManager.read(key: "userID") {
                self.userIdentifier = id
            } else {
                self.userIdentifier = nil
            }
            
            if let given = fullName?.givenName {
                if let family = fullName?.familyName {
                    self.userName = "\(family)\(given)"
                    print(self.userName)
                } else {
                    self.userName = nil
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패 시 처리
        print("Authorization failed: \(error.localizedDescription)")
    }
    
    func loginCheck() {
        if let _ = userIdentifier, let email = userEmail {
            appState?.myInfo = UserInfo(nickName: userName ?? "", socialID: [SocialID(socialType: "애플", socialID: email)])
            obViewModel?.page = .requiredInfo
            appState?.isLoggedIn = true
            print("loginView : \(appState?.myInfo)\n\(appState?.isLoggedIn)")
        } else {
            print("loginError")
            obViewModel?.page = .login
            appState?.isLoggedIn = false
        }
    }
}

class Utils {
    // MARK: - JWT decode
    static func decode(jwtToken jwt: String) -> [String: Any] {
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }

        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }

            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
}
