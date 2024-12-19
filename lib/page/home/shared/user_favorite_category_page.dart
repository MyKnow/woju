import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/item/category_model.dart';
import 'package:woju/provider/home/user_profile_state_notifier.dart';
import 'package:woju/service/debug_service.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class UserFavoriteCategoriesPage extends ConsumerStatefulWidget {
  const UserFavoriteCategoriesPage({super.key});

  @override
  ConsumerState<UserFavoriteCategoriesPage> createState() =>
      _UserFavoriteCategoriesPageState();
}

class _UserFavoriteCategoriesPageState
    extends ConsumerState<UserFavoriteCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final favoriteCategories = ref
        .watch(userProfileStateNotifierProvider)
        .userFavoriteCategories
        .keys
        .toList();

    // "Category.all" 을 제외한 모든 카테고리를 가져옵니다.
    final allCategories = Category.values.where(
      (category) {
        return category != Category.all;
      },
    ).toList();

    final nonFavoriteCategories = allCategories
        .where((category) => !ref
            .watch(userProfileStateNotifierProvider)
            .userFavoriteCategories
            .keys
            .contains(category))
        .toList();

    return CustomScaffold(
      title: "home.userProfile.userFavoriteCategories.title",
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          printd("didPop: $didPop, result: $result");
          if (didPop) {
            return;
          }

          await ref
              .read(userProfileStateNotifierProvider.notifier)
              .onPopInvokedWithResultFavoriteCategoryPage(context);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomText(
                "home.userProfile.userFavoriteCategories.selectPage.description",
                isDisabled: true,
              ),

              // 여백
              const SizedBox(height: 8 * 2),

              CustomDecorationContainer(
                headerText:
                    "home.userProfile.userFavoriteCategories.selectPage.headerOfFavoriteCategories",
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ReorderableListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final category = favoriteCategories[index];
                      return Dismissible(
                        key: ValueKey(category),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return ref
                                .read(userProfileStateNotifierProvider.notifier)
                                .onDismissedRemoveFromFavoriteCategory(
                                    category);
                          } else if (direction == DismissDirection.startToEnd) {
                            return false;
                          }

                          return false;
                        },
                        background: Container(
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        child: ListTile(
                          key: ValueKey(category),
                          title: CustomText(category.localizedName),
                          trailing: Icon(
                            Icons.drag_handle,
                            color: Theme.of(context).cardTheme.surfaceTintColor,
                          ),
                          onTap: () {
                            ref
                                .read(userProfileStateNotifierProvider.notifier)
                                .onTapShowDialogOfCategoryInfo(
                                  context,
                                  category,
                                );
                          },
                        ),
                      );
                    },
                    itemCount: favoriteCategories.length,
                    onReorder: (oldindex, newIndex) {
                      ref
                          .read(userProfileStateNotifierProvider.notifier)
                          .onReorderCategory(oldindex, newIndex);
                    },
                  ),
                ),
              ),

              // 여백
              const SizedBox(height: 8 * 2),

              CustomDecorationContainer(
                headerText:
                    "home.userProfile.userFavoriteCategories.selectPage.headerOfNonFavoriteCategories",
                padding: EdgeInsets.zero,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: nonFavoriteCategories.length,
                  itemBuilder: (context, index) {
                    final category = nonFavoriteCategories[index];
                    return ListTile(
                      title: CustomText(category.localizedName),
                      trailing: Icon(
                        Icons.add,
                        color: Theme.of(context).cardTheme.surfaceTintColor,
                      ),
                      onTap: () {
                        ref
                            .read(userProfileStateNotifierProvider.notifier)
                            .onTapAddToFavoriteCategory(category);
                      },
                    );
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
              // 여백
              const SizedBox(height: 8 * 10),
            ],
          ),
        ),
      ),
    );
  }
}
