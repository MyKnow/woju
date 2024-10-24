import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:woju/service/debug_service.dart';

/// ### 이미지 선택 서비스
///
/// - 이미지 선택 시 메타데이터를 요청하지 않음
/// - 이미지 크기를 최대 500px로 제한
///
/// #### Methods
/// - [Future]<[T]?> [_pickImage]<[T]> : 이미지 선택 메서드
/// - [Future]<[XFile]?> [pickImageForGallery] : 갤러리에서 이미지 선택 메서드
/// - [Future]<[XFile]?> [pickImageForCamera] : 카메라에서 이미지 선택 메서드
/// - [Future]<[Uint8List]?> [pickImageForGalleryWithUint8List] : 갤러리에서 이미지를 Uint8List로 선택 메서드
/// - [Future]<[Uint8List]?> [pickImageForCameraWithUint8List] : 카메라에서 이미지를 Uint8List로 선택 메서드
///
class ImagePickerService {
  /// ### 이미지 선택 메서드
  ///
  /// #### Parameters
  /// - [ImageSource] - [source] : 이미지 소스
  /// - [Future]<[T]> [Function]([XFile] - [pickedFile]) - [processFile] : 이미지 처리 메서드
  ///
  /// #### Returns
  /// - [T]? : 이미지 처리 결과 ([XFile] 또는 [Uint8List]) (선택한 이미지가 없으면 null)
  ///
  Future<T?> _pickImage<T>({
    required ImageSource source,
    required Future<T> Function(XFile pickedFile) processFile,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      requestFullMetadata: false,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile != null) {
      printd(
          "fileName: ${pickedFile.path}, size: ${await pickedFile.length()}");
      return processFile(pickedFile);
    }
    return null;
  }

  /// ### 갤러리에서 이미지 선택 메서드
  ///
  /// #### Returns
  /// - [XFile]? : 선택한 이미지 ([XFile]) (선택한 이미지가 없으면 null)
  ///
  Future<XFile?> pickImageForGallery() async {
    return _pickImage<XFile>(
      source: ImageSource.gallery,
      processFile: (pickedFile) async => XFile(pickedFile.path),
    );
  }

  /// ### 카메라에서 이미지 선택 메서드
  ///
  /// #### Returns
  /// - [XFile]? : 선택한 이미지 ([XFile]) (선택한 이미지가 없으면 null)
  ///
  Future<XFile?> pickImageForCamera() async {
    return _pickImage<XFile>(
      source: ImageSource.camera,
      processFile: (pickedFile) async => XFile(pickedFile.path),
    );
  }

  /// ### 갤러리에서 이미지를 Uint8List로 선택 메서드
  ///
  /// #### Returns
  /// - [Uint8List]? : 선택한 이미지 ([Uint8List]) (선택한 이미지가 없으면 null)
  ///
  Future<Uint8List?> pickImageForGalleryWithUint8List() async {
    return _pickImage<Uint8List>(
      source: ImageSource.gallery,
      processFile: (pickedFile) => pickedFile.readAsBytes(),
    );
  }

  /// ### 카메라에서 이미지를 Uint8List로 선택 메서드
  ///
  /// #### Returns
  /// - [Uint8List]? : 선택한 이미지 ([Uint8List]) (선택한 이미지가 없으면 null)
  ///
  Future<Uint8List?> pickImageForCameraWithUint8List() async {
    return _pickImage<Uint8List>(
      source: ImageSource.camera,
      processFile: (pickedFile) => pickedFile.readAsBytes(),
    );
  }
}
