class UserAuthModel {
  final String? authCode;
  final String? verificationId;
  final String? userUid;
  final int? resendToken;
  final bool authCodeSent;
  final bool authCompleted;

  UserAuthModel({
    this.authCode,
    this.verificationId,
    this.userUid,
    this.resendToken,
    this.authCodeSent = false,
    this.authCompleted = false,
  });

  UserAuthModel copyWith({
    String? authCode,
    String? verificationId,
    String? userUid,
    int? resendToken,
    bool? authCodeSent,
    bool? authCompleted,
  }) {
    return UserAuthModel(
      authCode: authCode ?? this.authCode,
      verificationId: verificationId ?? this.verificationId,
      userUid: userUid ?? this.userUid,
      resendToken: resendToken ?? this.resendToken,
      authCodeSent: authCodeSent ?? this.authCodeSent,
      authCompleted: authCompleted ?? this.authCompleted,
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
    );
  }
}
