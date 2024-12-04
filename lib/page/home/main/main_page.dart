import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'package:woju/page/home/main/chat_page.dart';
import 'package:woju/page/home/main/home_page.dart';
import 'package:woju/page/home/main/matching/matching_page.dart';
import 'package:woju/page/home/main/myItem/my_item_page.dart';

import 'package:woju/provider/home/bottom_bar_state_notifier.dart';
import 'package:woju/provider/home/myItem/my_item_state_notifier.dart';

import 'package:woju/theme/widget/custom_drawer_widget.dart';
import 'package:woju/theme/widget/custom_text.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bottomBarState = ref.watch(bottomBarStateProvider);
    final bottomBarStateNotifier = ref.watch(bottomBarStateProvider.notifier);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: CustomText(
          _buildAppBar(bottomBarState),
          isTitle: true,
        ),
        actions: _buildAppBarAction(bottomBarState, ref, theme),
      ),
      drawer: const CustomDrawerWidget(),
      body: _buildPage(bottomBarState),
      bottomNavigationBar: StylishBottomBar(
        hasNotch: true,
        notchStyle: NotchStyle.circle,
        backgroundColor: theme.cardTheme.color,
        option: DotBarOptions(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary,
            ],
          ),
        ),
        currentIndex: bottomBarState,
        items: [
          // 홈 화면
          BottomBarItem(
            icon: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                CupertinoIcons.home,
                size: 24,
              ),
            ),
            title: CustomText(
              'home.title',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
          // 물건 교환 추천 화면
          BottomBarItem(
            icon: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                CupertinoIcons.gift_alt,
                size: 24,
              ),
            ),
            title: CustomText(
              "matching.title",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
          // 채팅 화면
          BottomBarItem(
            icon: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                CupertinoIcons.chat_bubble_text,
                size: 24,
              ),
            ),
            title: CustomText(
              "chat.title",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
          // 내 물건 화면
          BottomBarItem(
            icon: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                CupertinoIcons.square_list,
                size: 24,
              ),
            ),
            title: CustomText(
              "myItem.title",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
        ],
        fabLocation: StylishBarFabLocation.end,
        onTap: (index) {
          bottomBarStateNotifier.setIndex(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/addItem");
        },
        backgroundColor: theme.cardTheme.color,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.primary,
          semanticLabel: "addItem.title".tr(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // 선택된 탭에 따라 화면 변경
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MatchingPage();
      case 2:
        return const ChatingPage();
      case 3:
        return const MyItemPage();
      default:
        return const SizedBox();
    }
  }

  // 선택된 탭에 따라 appBar Text 변경
  String _buildAppBar(int index) {
    switch (index) {
      case 0:
        return "home.title";
      case 1:
        return "matching.title";
      case 2:
        return "chat.title";
      case 3:
        return "myItem.title";
      default:
        return "home.title";
    }
  }

  // 선택된 탭에 따라 appBar Action 변경
  List<Widget>? _buildAppBarAction(int index, WidgetRef ref, ThemeData theme) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return null;
      case 2:
        return null;
      case 3:
        return [
          // 아이템 필터 버튼
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              ref.read(myItemStateProvider.notifier).onPressedFilterButton();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Center(
                    child: CustomText(
                      ref.watch(myItemStateProvider).filterStatusToString(),
                      isBold: true,
                      isColorful: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ];
      default:
        return null;
    }
  }
}
