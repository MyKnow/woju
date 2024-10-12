import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:woju/model/hive_box_enum.dart';
import 'package:woju/model/user/user_detail_info_model.dart';

/// ### 유저 세부 정보 상태를 관리하는 StateNotifier
///
/// Hive를 사용하여 유저 세부 정보 상태를 저장하고 업데이트합니다.
///
final userDetailInfoStateProvider =
    StateNotifierProvider<UserDetailInfoStateNotifier, UserDetailInfoModel?>(
  (ref) {
    final box = Hive.box<UserDetailInfoModel>(HiveBox.userDetailInfoBox.name);
    return UserDetailInfoStateNotifier(box);
  },
);

/// ### UserDetailInfoStateNotifier
///
/// - [UserDetailInfoModel] 유저 세부 정보 상태를 관리하는 StateNotifier
///
/// #### Fields
///
/// - [UserDetailInfoModel]? state: 유저 세부 정보 상태
/// - [Box]<[UserDetailInfoModel]> _box: 유저 세부 정보 상태를 저장하는 Hive Box
/// - [String] _boxName: 유저 세부 정보 상태를 저장하는 Hive Box 이름
///
/// #### Methods
///
/// - [Future]<void> [update] ([UserDetailInfoModel] newState): 유저 세부 정보 상태를 업데이트하는 메서드
/// - [Future]<void> [delete] (): 유저 세부 정보 상태를 삭제하는 메서드
/// - [Future]<[UserDetailInfoModel]?> [read] (): 유저 세부 정보 상태를 불러오는 메서드
///
class UserDetailInfoStateNotifier extends StateNotifier<UserDetailInfoModel?> {
  final Box<UserDetailInfoModel> _box;
  final String _boxName = HiveBox.userDetailInfoBox.name;

  // 초기 상태를 불러오거나 기본값을 설정
  UserDetailInfoStateNotifier(this._box) : super(null) {
    read();
  }

  /// ### 유저 세부 정보 상태를 업데이트
  ///
  /// box에 userDetailInfoState를 저장하고 상태를 업데이트합니다.
  ///
  /// ```dart
  /// ref.read(userDetailInfoStateProvider.notifier).update(newState);
  /// ```
  Future<void> update(UserDetailInfoModel newState) async {
    await _box.put(_boxName, newState);
    state = newState;
  }

  /// ### 유저 세부 정보 상태를 초기화
  ///
  /// box에서 userDetailInfoState를 삭제하고 상태를 초기화합니다.
  Future<void> delete() async {
    await _box.delete(_boxName);
    state = null;
  }

  /// ### box 값을 불러옵니다.
  ///
  /// box에서 userDetailInfoState를 불러옵니다.
  ///
  Future<UserDetailInfoModel?> read() async {
    state = _box.get(_boxName, defaultValue: null);

    return state;
  }

  /// ### UserDetailInfoState 반환
  ///
  /// 현재 UserDetailInfoState를 반환합니다.
  ///
  /// #### Return
  ///
  /// - [UserDetailInfoState?] : 현재 UserDetailInfoState (nullable)
  ///
  UserDetailInfoModel? get userDetailInfoState => state;

  /// ### 에러 메세지 반환
  ///
  /// #### Notes
  ///
  /// - UserDetailInfo의 상태에 따라 에러 메세지를 반환함
  ///
  /// #### Returns
  ///
  /// - [String?] 에러 메세지(localizing 되지 않음)
  ///
  String? get getErrorMessage {
    if (state == null) {
      return "error.userDetail.nullInfo";
    } else if (state != null && state!.userUUID.isEmpty) {
      return "error.userDetail.emptyUUID";
    } else {
      return null;
    }
  }
}
