import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:woju/service/debug_service.dart';

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
/// - [String] get [localizedName] : 카테고리 이름을 반환(로컬라이징)
/// - [String] get [description] : 카테고리 설명을 반환(로컬라이징)
/// - [Uint8List] get [image] : 카테고리 아이콘(이미지)을 반환
/// - [Category] - [fromString] : 문자열로부터 카테고리 반환
///
extension CategoryExtension on Category {
  /// # 카테고리 이름 반환 메서드
  ///
  /// ### Returns
  /// - [String] : 카테고리 이름(로컬라이징)
  ///
  String get localizedName => '$this.name';

  /// # 카테고리 설명 반환 메서드
  ///
  /// ### Returns
  /// - [String] : 카테고리 설명(로컬라이징)
  ///
  String get description => '$this.description';

  /// # 카테고리 이미지 반환 메서드
  ///
  /// ### Returns
  ///
  /// - [Image] : 카테고리 이미지, 존재하지 않을 경우 빈 바이트 반환
  ///
  Image get image {
    // 이름만 추출
    final simpleName = toString().split('.').last;
    // 이미지 경로
    final path = 'assets/images/category/$simpleName.png';
    // 이미지 파일
    final image = Image.asset(
      path,
      errorBuilder: (context, error, stackTrace) {
        printd('error: $error');
        return const Icon(
          Icons.error_outlined,
          color: Colors.red,
        );
      },
    );

    return image;
  }

  /// # [Category] - [getCategoryMapFromString]
  /// - 문자열로부터 카테고리 맵 반환
  ///
  /// ### Parameters
  /// - [String]? - [categoryMap] : 카테고리 맵 문자열
  ///  - ex) {"electronics": 1, "fashion": 2, "book": 3}
  ///
  /// ### Returns
  /// - [Map]<[Category], [int]>? : 카테고리 맵
  ///
  static Map<Category, int>? getCategoryMapFromString(String? categoryMap) {
    if (categoryMap == null || categoryMap.isEmpty) {
      return null;
    }

    final map = <Category>[];

    try {
      // 쉼표로 분리
      final categoryList = categoryMap.split(',').map((e) => e.trim()).toList();

      // 맵에 추가
      for (final category in categoryList) {
        final split = category.split(':');
        final categoryName = split[0].replaceAll(RegExp(r'[{"}]'), '');
        final categoryValue =
            int.parse(split[1].replaceAll(RegExp(r'[{"}]'), ''));
        map.add(CategoryExtension.fromString(categoryName));

        printd('categoryName: $categoryName, categoryValue: $categoryValue');
      }

      return {for (var e in map) e: 1};
    } catch (e) {
      printd('getCategoryMapFromString error: $e');
      return null;
    }
  }

  /// # [Category] - [toStringFromCategoryList]
  /// - 카테고리 리스트를 문자열로 변환
  ///
  /// ### Parameters
  /// - [List]<[Category]>? - [categoryList] : 카테고리 리스트
  ///
  /// ### Returns
  /// - [String] : 카테고리 리스트 문자열 (Localized)
  ///
  static String toStringFromCategoryList(List<Category>? categoryList) {
    if (categoryList == null || categoryList.isEmpty) {
      return 'Category.emptyList';
    }

    return categoryList.map((e) => e.localizedName).toList().join(', ');
  }

  /// # [Category] - [fromString]
  /// - 문자열로부터 카테고리 반환
  ///
  /// ### Parameters
  /// - [String] - [categoryName] : 카테고리 이름
  ///
  /// ### Returns
  /// - [Category] : 카테고리
  ///
  static Category fromString(String categoryName) {
    try {
      return Category.values.firstWhere(
        (element) => element.toString() == 'Category.$categoryName',
      );
    } catch (e) {
      printd('fromString error: $e');
      return Category.etc;
    }
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
/// ### Methods
///
/// - [List]<[CategoryModel]> get [categories] : 카테고리 목록 반환
/// - [CategoryModel] - [getCategoryModel] : 카테고리 모델 반환
/// - [Map]<[String], [dynamic]> toJson() : JSON 변환 메서드
/// - [CategoryModel] - [fromString] : 문자열로부터 카테고리 모델 반환
///
///
class CategoryModel {
  final Category category;
  final String description;
  final Image icon;

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
      .map(
        (e) => CategoryModel(
          category: e,
          description: e.description,
          icon: e.image,
        ),
      )
      .toList();

  /// # 카테고리 모델 반환 메서드
  ///
  /// ### Parameters
  /// - [Category] category : 카테고리
  ///
  /// ### Returns
  /// - [CategoryModel] : 카테고리 모델
  ///
  static CategoryModel getCategoryModel(Category category) {
    return categories.firstWhere((element) => element.category == category);
  }

  /// # [String] - [getItemNameLast]
  ///
  /// ### Returns
  /// - [String] : 카테고리 이름(마지막 부분)
  ///
  String getItemNameLast() {
    return category.toString().split('.').last;
  }

  /// # [CategoryModel] - [fromString]
  /// - 문자열로부터 카테고리 모델 반환
  ///
  /// ### Parameters
  /// - [String] [categoryName] : 카테고리 이름
  ///
  /// ### Returns
  /// - [CategoryModel] : 카테고리 모델
  static CategoryModel fromString(String categoryName) {
    try {
      final category = Category.values.firstWhere(
        (element) => element.toString() == 'Category.$categoryName',
      );
      return getCategoryModel(category);
    } catch (e) {
      printd("fromString error: $e");
      return getCategoryModel(Category.etc);
    }
  }
}
