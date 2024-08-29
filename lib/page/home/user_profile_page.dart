import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/onboarding/nickname_state_notifier.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';
import 'package:woju/theme/widget/profile_image_widget.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname = ref.watch(nicknameStateProvider);
    final nicknameNotifier = ref.read(nicknameStateProvider.notifier);
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const ProfileImageWidget(),
            const SizedBox(height: 40),
            CustomTextfieldContainer(
              fieldKey: "user_nickname",
              prefixIcon: const Icon(Icons.person),
              labelText: nickname.labelTextForEditing,
              validator: nickname.validator,
              onChanged: nicknameNotifier.onChangeNickname,
              enabled: nickname.isEditing,
              // initialValue: nickname.nickname,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.nickname],
              onFieldSubmitted: (value) =>
                  nicknameNotifier.onClickCompleteChangeNickname(context),
              controller: nicknameNotifier.nicknameController,
              actions: [
                if (!nickname.isEditing)
                  TextButton(
                    onPressed: nicknameNotifier.onClickChangeNickname,
                    child: const CustomText(
                      "status.UserNickNameStatus.nicknameUpdate",
                      isColorful: true,
                      isBold: true,
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      semanticLabel:
                          "status.UserNickNameStatus.nicknameUpdateCancelButton",
                    ),
                    onPressed: nicknameNotifier.onClickCancelChangeNickname,
                  ),
                if (nickname.isEditing)
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      semanticLabel:
                          "status.UserNickNameStatus.nicknameUpdateConfirmButton",
                    ),
                    onPressed:
                        nicknameNotifier.onClickCompleteChangeNickname(context),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
