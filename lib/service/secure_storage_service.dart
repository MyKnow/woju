import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:woju/model/secure_model.dart';

/// ### SecureStorageService
///
/// FlutterSecureStorage를 사용하여 안전하게 데이터를 저장하고 불러옵니다.
///
class SecureStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// ### SecureData 저장
  ///
  /// key와 value를 받아 SecureData를 저장합니다.
  ///
  /// #### Parameters
  ///
  /// - [SecureModel key]: SecureData의 key
  ///
  /// - [String value]: SecureData의 value
  ///
  static Future<void> writeSecureData(SecureModel key, String value) async {
    await _secureStorage.write(key: key.name, value: value);
  }

  /// ### SecureData 불러오기
  ///
  /// key를 받아 SecureData를 불러옵니다.
  ///
  /// #### Parameters
  ///
  /// - [SecureModel key]: SecureData의 key
  ///
  /// #### Returns
  ///
  /// - `Future<String?>`: SecureData의 value
  ///
  static Future<String?> readSecureData(SecureModel key) async {
    return await _secureStorage.read(key: key.name);
  }

  /// ### SecureData 삭제
  ///
  /// key를 받아 SecureData를 삭제합니다.
  ///
  /// #### Parameters
  ///
  /// - [SecureModel key]: SecureData의 key
  ///
  static Future<void> deleteSecureData(SecureModel key) async {
    await _secureStorage.delete(key: key.name);
  }

  /// ### 모든 SecureData 삭제
  ///
  /// 모든 SecureData를 삭제합니다.
  ///
  static Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  /// ### 모든 SecureData 불러오기
  ///
  /// 모든 SecureData를 불러옵니다.
  ///
  /// #### Returns
  ///
  /// - `Future<Map<SecureModel, String>>`: 모든 SecureData의 key-value 쌍
  ///
  static Future<Map<SecureModel, String>> readAllSecureData() async {
    final allData = await _secureStorage.readAll();
    final secureData = <SecureModel, String>{};

    allData.forEach((key, value) {
      final secureModel = SecureModelExtension.fromString(key);
      secureData[secureModel] = value;
    });

    return secureData;
  }
}
