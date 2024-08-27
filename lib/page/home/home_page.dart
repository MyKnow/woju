import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/profile_image_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userDetailInfoStateProvider);
    final signInNotifier = ref.watch(signInStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Home Page", isTitle: true),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).cardTheme.color,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
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
                  icon: Icon(CupertinoIcons.xmark,
                      semanticLabel: "home.drawer.closeIconDescription".tr()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.all(16),
                  tooltip: "home.drawer.closeIconDescription".tr(),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 32, 0),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  const ProfileImageWidget(
                    hasShadow: false,
                  ),
                  CustomText(
                    userDetail?.userNickName ?? "",
                    isWhite: true,
                    isTitle: true,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const CustomText("Home"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const CustomText("Profile"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/profile");
                    },
                  ),
                  ListTile(
                    title: const CustomText("Setting"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/setting");
                    },
                  ),
                ],
              ),
            ),

            // 항상 하단에 위치하게 되는 TextButton
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 16.0), // 하단 패딩을 추가할 수 있습니다.
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      ref.read(signInStateProvider.notifier).logout();
                    },
                    child: const CustomText(
                      "Sign Out",
                      isWhite: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText("User ID: ${userDetail?.userID}"),
            CustomText("User Nickname: ${userDetail?.userNickName}"),
            CustomText(
                "User Phone: ${userDetail?.dialCode} ${userDetail?.userPhoneNumber} (${userDetail?.isoCode})"),
            CustomText("User UID: ${userDetail?.userUID}"),
            CustomText("User Gender: ${userDetail?.userGender}"),
            const ProfileImageWidget(
              isEditable: false,
            ),
            CustomText("User BirthDate: ${userDetail?.userBirthDate}"),
            ElevatedButton(
              onPressed: signInNotifier.withdrawalButtonOnClick(context),
              child: const CustomText(
                "Withdrawal",
                isWhite: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(signInStateProvider.notifier).logout();
              },
              child: const CustomText(
                "Sign Out",
                isWhite: true,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final userPassword = await SecureStorageService.readSecureData(
                        SecureModel.userPassword) ??
                    "";
                await UserService.changePassword(
                    userDetail!.userID, userPassword, "@test1111", ref);
              },
              child: const CustomText(
                "Change Password",
                isWhite: true,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const CustomText("This is a SnackBar"),
                      action: SnackBarAction(
                        label: "Close",
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                },
                child: const CustomText(
                  "Show SnackBar",
                  isWhite: true,
                )),
          ],
        ),
      ),
    );
  }
}
