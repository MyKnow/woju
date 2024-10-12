/// # Version
///
/// ## Description
/// - 각종 버전 정보를 담는 모델
/// - 현재 버전, 최신 버전, 필수 버전을 담는다.
///
/// ## Properties
/// - [String?] nowVersion: 현재 버전
/// - [String?] latestVersion: 최신 버전
/// - [String?] requiredVersion: 필수 버전
///
/// ## Methods
/// - [Version.isRightFormat]: 버전이 올바른 형식인지 확인, 'x.y.z-type' 형식
/// - [Version.fromJson]: json을 통해 Version 객체 생성, [nowVersion], [latestVersion], [requiredVersion]를 받는다.
/// - [Version.toJson]: Version 객체를 json으로 변환, [nowVersion], [latestVersion], [requiredVersion]를 반환한다.
/// - [Version.isNeedUpdate]: 업데이트가 필요한지 확인, 필수 버전이 현재 버전보다 높으면 true 반환
/// - [Version.updateVersion]: 버전 문자열을 받아 Version 객체를 업데이트, [nowVersion], [latestVersion], [requiredVersion]를 선택적으로 받는다.
///
class Version {
  final String? nowVersion;
  final String? latestVersion;
  final String? requiredVersion;

  Version({this.nowVersion, this.latestVersion, this.requiredVersion});

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      nowVersion:
          isRightFormat(json['now_version']) ? json['now_version'] : null,
      latestVersion:
          isRightFormat(json['latest_version']) ? json['latest_version'] : null,
      requiredVersion: isRightFormat(json['required_version'])
          ? json['required_version']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'now_version': nowVersion,
      'latest_version': latestVersion,
      'required_version': requiredVersion,
    };
  }

  @override
  String toString() {
    return 'Version{nowVersion: $nowVersion, latestVersion: $latestVersion, requiredVersion: $requiredVersion}';
  }

  bool isNeedUpdate() {
    if (requiredVersion == null) {
      return false;
    }

    final nowVersionList = nowVersion!.split('.').map(int.parse).toList();
    final requiredVersionList =
        requiredVersion!.split('.').map(int.parse).toList();

    for (int i = 0; i < nowVersionList.length; i++) {
      if (nowVersionList[i] < requiredVersionList[i]) {
        return true;
      }
    }

    return false;
  }

  /// ### isRightFormat
  ///
  /// - 버전이 올바른 형식인지 확인
  ///
  /// #### Parameters
  ///
  /// - [String] version: 버전 문자열
  ///
  /// #### Returns
  ///
  /// - [bool]: 올바른 형식이면 true, 아니면 false
  ///
  /// #### Examples
  ///
  /// ```
  /// final version = Version();
  /// final result = version.isRightFormat('1.0.0');
  /// print(result); // true
  ///
  /// final result = version.isRightFormat('1.0.0-KR');
  /// print(result); // true
  ///
  /// final result = version.isRightFormat('1.0');
  /// print(result); // false
  ///
  /// final result = version.isRightFormat('1.0.0_0');
  /// print(result); // false
  ///
  /// ```
  ///
  static bool isRightFormat(String version) {
    if (version == "latest") {
      return true;
    }

    final versionList = version.split('.');
    if (versionList.length < 3) {
      return false;
    }

    final typeList = versionList[2].split('-');
    if (typeList.length > 2) {
      return false;
    }

    return true;
  }

  /// ### updateVersion
  ///
  /// - 버전 문자열을 받아 Version 객체를 업데이트
  ///
  /// #### Parameters
  ///
  /// - [String?] nowVersion: 현재 버전
  /// - [String?] latestVersion: 최신 버전
  /// - [String?] requiredVersion: 필수 버전
  ///
  /// #### Returns
  ///
  /// - [Version] 업데이트된 Version 객체
  ///
  Version updateVersion({
    String? nowVersion,
    String? latestVersion,
    String? requiredVersion,
  }) {
    return Version(
      nowVersion: (nowVersion != null && isRightFormat(nowVersion))
          ? nowVersion
          : this.nowVersion,
      latestVersion: (latestVersion != null && isRightFormat(latestVersion))
          ? latestVersion
          : this.latestVersion,
      requiredVersion:
          (requiredVersion != null && isRightFormat(requiredVersion))
              ? requiredVersion
              : this.requiredVersion,
    );
  }
}
