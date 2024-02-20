//
//  ImagePicker.swift
//  woju
//
//  Created by 정민호 on 2/20/24.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true // Enable editing
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No need to update anything here
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                // cropSquare 메서드를 호출하고 결과를 selectedImage에 할당
                print(image.size.width)
                print(image.size.height)
                if let croppedImage = cropSquare(image) {
                    parent.selectedImage = croppedImage
                } else {
                    parent.selectedImage = image
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        private func cropSquare(_ image: UIImage) -> UIImage? {
            let imageSize = image.size
            let shortLength = min(imageSize.width, imageSize.height) // 더 짧은 길이를 선택
            let origin = CGPoint(
                x: (imageSize.width - shortLength) / 2,
                y: (imageSize.height - shortLength) / 2
            )
            let size = CGSize(width: shortLength, height: shortLength)
            let square = CGRect(origin: origin, size: size)

            UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
            image.draw(at: CGPoint(x: -origin.x, y: -origin.y))
            let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return croppedImage
        }
    }
}

