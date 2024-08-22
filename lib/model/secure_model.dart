enum SecureModel {
  userPassword,
  other,
}

extension SecureModelExtension on SecureModel {
  String get name {
    switch (this) {
      case SecureModel.userPassword:
        return 'userPassword';
      default:
        return 'other';
    }
  }

  static SecureModel fromString(String value) {
    switch (value) {
      case 'userPassword':
        return SecureModel.userPassword;
      default:
        return SecureModel.other;
    }
  }
}
