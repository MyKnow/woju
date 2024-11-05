import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/item/category_model.dart';
import 'package:woju/provider/home/addItem/add_item_page_state_notifier.dart';
import 'package:woju/theme/widget/adaptive_dialog.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class CategorySelectPage extends ConsumerWidget {
  const CategorySelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final shortSide = screenWidth < screenHeight ? screenWidth : screenHeight;

    const double squareWidth = 100.0;
    final crossAxisCount = screenWidth ~/ (squareWidth + 16);

    final theme = Theme.of(context);

    return CustomScaffold(
      title: 'addItem.itemCategory.categorySelectPage.title',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 길게 눌러서 카테고리 설명 다이얼로그 보기 안내
              CustomText(
                'addItem.itemCategory.categorySelectPage.longPressToSeeDescription',
                style: theme.primaryTextTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
                textAlign: TextAlign.center,
              ),

              // 여백
              const SizedBox(height: 16),

              // 카테고리 선택
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: squareWidth + squareWidth / 2,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Category.values.length - 1,
                itemBuilder: (context, index) {
                  final category = Category.values[index + 1];

                  return InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: ref
                        .read(addItemPageStateProvider.notifier)
                        .onTapCategory(
                          CategoryModel.getCategoryModel(category),
                          context,
                        ),
                    onLongPress: () {
                      // 설명 텍스트 보기
                      AdaptiveDialog.showAndroidDialog(
                        context,
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                category.name,
                                style: theme.primaryTextTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              // 이미지
                              Container(
                                width: shortSide * 0.45,
                                height: shortSide * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: theme.disabledColor,
                                    width: 2,
                                  ),
                                ),
                                child: Image.memory(
                                  category.image,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error_outlined,
                                      color: Colors.red,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomText(
                                category.description,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                          width: squareWidth,
                        ),
                        Container(
                          width: squareWidth,
                          height: squareWidth,
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Image.memory(
                              category.image,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.error_outlined,
                                  color: Colors.red,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: squareWidth,
                          height: squareWidth / 4,
                          alignment: Alignment.center,
                          child: CustomText(
                            category.name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 여백
              // const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
