//
//  ImageModifyManager.swift
//  woju
//
//  Created by 정민호 on 2/20/24.
//

import Foundation
import SwiftUI

class ImageModifyManager {
    // Data? 타입의 이미지 데이터를 받아서 SwiftUI의 Image로 변환하는 함수
    class func data2uiimage(from profileImageData: Data?) -> UIImage {
        // Data가 있는 경우, 해당 데이터로부터 UIImage 생성
        if let imageData = profileImageData, let image = UIImage(data: imageData) {
            return image
        } else {
            // Data가 nil이거나 이미지 생성에 실패한 경우, 기본 이미지 반환
            return UIImage(named: "person.fill")!
        }
    }// Data? 타입의 이미지 데이터를 받아서 SwiftUI의 Image로 변환하는 함수
    class func uiimage2data(from profileImag: UIImage) -> Data? {
        return profileImag.pngData()
    }
}
