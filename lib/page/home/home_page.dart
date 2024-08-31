import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/theme/widget/custom_drawer_widget.dart';
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
      drawer: const CustomDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            CustomText(
              "User UUID: ${userDetail?.userUUID}",
              isLocalize: false,
            ),
            CustomText(
              "User ID: ${userDetail?.userID}",
              isLocalize: false,
            ),
            CustomText(
              "User Nickname: ${userDetail?.userNickName}",
              isLocalize: false,
            ),
            CustomText(
              "User Phone: ${userDetail?.dialCode} ${userDetail?.userPhoneNumber} (${userDetail?.isoCode})",
              isLocalize: false,
            ),
            CustomText(
              "User UID: ${userDetail?.userUID}",
              isLocalize: false,
            ),
            CustomText(
              "User Gender: ${userDetail?.userGender}",
              isLocalize: false,
            ),
            ProfileImageWidget(
              isEditable: false,
              image: userDetail?.profileImage,
            ),
            CustomText(
              "User BirthDate: ${userDetail?.userBirthDate}",
              isLocalize: false,
            ),
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
                isLocalize: false,
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
                isLocalize: false,
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
                isLocalize: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
