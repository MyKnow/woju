import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/theme/widget/custom_text.dart';

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
            if (userDetail != null && userDetail.profileImage != null)
              CircleAvatar(
                radius: 100,
                backgroundImage: Image.memory(userDetail.profileImage!).image,
              ),
            CustomText("User BirthDate: ${userDetail?.userBirthDate}"),
            ElevatedButton(
              onPressed: signInNotifier.withdrawalButtonOnClick(context),
              child: const CustomText(
                "Withdrawal",
                reverseTextColor: true,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(signInStateProvider.notifier).logout();
              },
              child: const CustomText(
                "Sign Out",
                reverseTextColor: true,
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
                reverseTextColor: true,
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
                  reverseTextColor: true,
                )),
          ],
        ),
      ),
    );
  }
}
