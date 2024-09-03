import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/secure_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class UserWithdrawalPage extends ConsumerWidget {
  const UserWithdrawalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      title: "home.userProfile.userWithdrawal.title",
      body: SingleChildScrollView(
        child: Column(
          children: [
            // WithdrawalForm(),
            // WithdrawalHistory(),
            const SizedBox(height: 32, width: double.infinity),
            CircleAvatar(
              radius: 100,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.person_off,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24, width: double.infinity),
            const CustomText(
              "home.userProfile.userWithdrawal.withdrawalDetail",
              isBold: true,
              // isColorful: true,
              // isTitle: true,
            ),
            const SizedBox(height: 64, width: double.infinity),
            const CustomText(
              "home.userProfile.userWithdrawal.withdrawalConfirm",
              isBold: true,
              isTitle: true,
              // isColorful: true,
            ),
            const SizedBox(height: 16, width: double.infinity),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              onPressed: () async {
                final userData = ref.watch(userDetailInfoStateProvider);
                final userPassword = await SecureStorageService.readSecureData(
                    SecureModel.userPassword);
                if (userData == null || userPassword == null) {
                  return;
                }

                final userID = userData.userID;

                final result =
                    await UserService.withdrawal(userID, userPassword, ref);

                if (result != null) {
                  if (context.mounted) {
                    ToastMessageService.nativeSnackbar(result, context);
                  }
                } else {
                  if (context.mounted) {
                    ToastMessageService.nativeSnackbar(
                      "home.userProfile.userWithdrawal.withdrawalSuccess",
                      context,
                    );
                  }
                }
              },
              child: const CustomText(
                "home.userProfile.userWithdrawal.withdrawalConfirmButton",
                isWhite: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
