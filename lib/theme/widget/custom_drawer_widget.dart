import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';

import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/profile_image_widget.dart';

class CustomDrawerWidget extends ConsumerWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userDetailInfoStateProvider);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isPortrait = screenHeight > screenWidth;

    return Drawer(
      backgroundColor: Theme.of(context).cardTheme.color,
      semanticLabel: "home.drawer.openIconDescription".tr(),
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.xmark,
                  semanticLabel: "home.drawer.closeIconDescription".tr(),
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: const EdgeInsets.all(16),
                tooltip: "home.drawer.closeIconDescription".tr(),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 32),
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(
                  const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                depth: 10,
                intensity: 0.9,
                shadowDarkColor: theme.primaryColorDark,
                shadowLightColor: theme.primaryColor,
                lightSource: LightSource.left,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                // margin: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    ProfileImageWidget(
                      hasShadow: false,
                      image: userDetail?.profileImage,
                      radius: isPortrait ? 100 : 60,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      userDetail?.userNickName ?? "",
                      isWhite: true,
                      isTitle: true,
                      isLocalize: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    color: theme.primaryColor,
                    size: theme.primaryTextTheme.titleMedium?.fontSize,
                    applyTextScaling: true,
                  ),
                  title: const CustomText("home.drawer.profile"),
                  onTap: () {
                    Navigator.pop(context);
                    context.push("/userProfile");
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                ),
                ListTile(
                  leading: Icon(
                    Icons.headset_mic_rounded,
                    color: theme.primaryColor,
                    size: theme.primaryTextTheme.titleMedium?.fontSize,
                    applyTextScaling: true,
                  ),
                  title: const CustomText("home.drawer.customerServiceCenter"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.gear_alt_fill,
                    color: theme.primaryColor,
                    size: theme.primaryTextTheme.titleMedium?.fontSize,
                    applyTextScaling: true,
                  ),
                  title: const CustomText("home.drawer.setting"),
                  onTap: () {
                    Navigator.pop(context);
                    context.push("/setting");
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                ),
              ],
            ),
          ),

          // 항상 하단에 위치하게 되는 TextButton
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 16.0), // 하단 패딩을 추가할 수 있습니다.
          //   child: Column(
          //     children: [
          //       TextButton(
          //         onPressed: () {
          //           ref.read(signInStateProvider.notifier).logout();
          //         },
          //         child: const CustomText(
          //           "home.drawer.signOut",
          //           isColorful: false,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
