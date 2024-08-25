import 'package:easy_localization/easy_localization.dart';
import 'package:woju/model/status/status_mixin.dart';
import 'package:woju/model/text_field_model.dart';

enum AuthStatus with StatusMixin {
  initial,
  failedInvalidPhoneNumber,
  failedAuthCodeNotSent,
  failedAuthCodeTimeout,
  failedAUthCodeEmpty,
  failedAuthCodeInvalid,
}

enum UserExistStatus with StatusMixin {
  exist,
  notExist,
  error,
}

class UserAuthModel with TextFieldModel<String> {
  final String? authCode;
  final String? verificationId;
  final String? userUid;
  final int? resendToken;
  final bool authCodeSent;
  final bool authCompleted;
  final AuthStatus status;
  final UserExistStatus? userExistStatus;

  UserAuthModel({
    this.authCode,
    this.verificationId,
    this.userUid,
    this.resendToken,
    this.authCodeSent = false,
    this.authCompleted = false,
    this.status = AuthStatus.initial,
    this.userExistStatus,
  });

  UserAuthModel copyWith({
    String? authCode,
    String? verificationId,
    String? userUid,
    int? resendToken,
    bool? authCodeSent,
    bool? authCompleted,
    AuthStatus? status,
    UserExistStatus? userExistStatus,
  }) {
    return UserAuthModel(
      authCode: authCode ?? this.authCode,
      verificationId: verificationId ?? this.verificationId,
      userUid: userUid ?? this.userUid,
      resendToken: resendToken ?? this.resendToken,
      authCodeSent: authCodeSent ?? this.authCodeSent,
      authCompleted: authCompleted ?? this.authCompleted,
      status: status ?? this.status,
      userExistStatus: userExistStatus ?? this.userExistStatus,
    );
  }

  static UserAuthModel initial() {
    return UserAuthModel(
      authCode: null,
      verificationId: null,
      userUid: null,
      resendToken: null,
      authCodeSent: false,
      authCompleted: false,
      status: AuthStatus.initial,
      userExistStatus: null,
    );
  }

  // 라벨 반환
  @override
  String get labelText {
    return 'status.authcode.label'.tr();
  }

  @override
  bool get isValid {
    return authCode != null && authCode!.length == 6;
  }

  @override
  String? get value {
    return authCode;
  }

  @override
  String? get errorMessage {
    if (isValid) {
      return null;
    } else {
      return 'status.authcode.error'.tr();
    }
  }
}
