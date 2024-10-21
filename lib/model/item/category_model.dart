import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

/// # 물품 카테고리
///
/// ### Notes
///
/// - 카테고리 목록은 추후 추가될 수 있습니다.
///
/// ### 카테고리 목록
///
/// - all : 전체
/// - electronics : 전자기기
/// - furniture : 가구
/// - lifestyle : 생활용품
/// - fashion : 패션의류
/// - book : 도서
/// - layette : 유아용품(의류)
/// - cosmetic : 뷰티용품
/// - sportsEquipment : 스포츠용품
/// - hobbyGoods : 취미용품
/// - album : 음반
/// - carGoods : 자동차용품
/// - ticket : 티켓
/// - petGoods : 반려동물용품
/// - plant : 식물
/// - etc : 기타
///
enum Category {
  /// 전체
  all,

  /// 전자기기
  electronics,

  /// 가구
  furniture,

  /// 생활용품
  lifestyle,

  /// 패션의류
  fashion,

  /// 도서
  book,

  /// 유아용품(의류)
  layette,

  /// 뷰티용품
  cosmetic,

  /// 스포츠용품
  sportsEquipment,

  /// 취미용품
  hobbyGoods,

  /// 음반
  album,

  /// 자동차용품
  carGoods,

  /// 티켓
  ticket,

  /// 반려동물용품
  petGoods,

  /// 식물
  plant,

  /// 기타
  etc,
}

/// # 물품 카테고리 확장
///
/// ### Methods
///
/// - [String] get [description] : 카테고리 설명을 반환(로컬라이징)
/// - [Uint8List] get [icon] : 카테고리 아이콘(이미지)을 반환
///
extension CategoryExtension on Category {
  /// # 카테고리 설명 반환 메서드
  ///
  /// ### Returns
  ///
  /// - [String] : 카테고리 설명(로컬라이징)
  ///
  String get description => 'category.description.$name'.tr();

  /// # 카테고리 아이콘(이미지) 반환 메서드
  ///
  /// ### Returns
  ///
  /// - [Uint8List] : 카테고리 아이콘(이미지), 존재하지 않을 경우 빈 바이트 반환
  ///
  Uint8List get icon {
    final file = File('assets/images/category/$name.png');
    return file.existsSync() ? file.readAsBytesSync() : Uint8List(0);
  }
}

/// # Category Class
///
/// ### Notes
///
/// - 카테고리 목록은 추후 추가될 수 있습니다.
///
/// ### Fields
///
/// - [Category] category : 카테고리
/// - [String] description : 카테고리 설명
/// - [Uint8List] icon : 카테고리 아이콘
///
class CategoryModel {
  final Category category;
  final String description;
  final Uint8List icon;

  const CategoryModel({
    required this.category,
    required this.description,
    required this.icon,
  });

  /// # 카테고리 목록 반환 메서드
  ///
  /// ### Returns
  ///
  /// - [List<CategoryModel>] : 카테고리 목록
  ///
  static List<CategoryModel> categories = Category.values
      .map((e) => CategoryModel(
            category: e,
            description: e.description,
            icon: e.icon,
          ))
      .toList();
}
