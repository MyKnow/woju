import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/onboarding/id_state_notifier.dart';
import 'package:woju/provider/onboarding/nickname_state_notifier.dart';
// import 'package:woju/provider/onboarding/phone_number_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/toast_message_service.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';
import 'package:woju/theme/widget/profile_image_widget.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailInfoStateProvider)?.userUUID;
    final nickname = ref.watch(nicknameStateProvider);
    final nicknameNotifier = ref.read(nicknameStateProvider.notifier);
    final userID = ref.watch(userIDStateProvider);
    final userIDNotifier = ref.read(userIDStateProvider.notifier);
    // final phoneNumber = ref.watch(phoneNumberStateProvider(true));
    // final phoneNumberNotifier =
    //     ref.read(phoneNumberStateProvider(true).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const CustomText("home.userProfile.title", isTitle: true),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            // 유저 프로필 이미지 변경
            const ProfileImageWidget(),
            const SizedBox(height: 40),
            // 유저 고유 번호 조회
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
              child: const CustomText(
                "home.userProfile.userUUID",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomDecorationContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomText(user ?? "",
                      isLocalize: false,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).disabledColor,
                          )),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: user ?? ""));
                      ToastMessageService.nativeSnackbar(
                        "home.userProfile.userUUIDCopied",
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // 유저 닉네임 변경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
              child: const CustomText(
                "home.userProfile.userNickName",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomTextfieldContainer(
              fieldKey: "user_profile_user_nick_name",
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

            // 유저 아이디 변경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
              child: const CustomText(
                "home.userProfile.userID",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomTextfieldContainer(
              fieldKey: "user_profile_id",
              prefixIcon: const Icon(Icons.person),
              labelText: userID.labelTextForEditing,
              validator: userID.validator,
              onChanged: userIDNotifier.onChangeUserID,
              enabled: userID.isEditing,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.username],
              onFieldSubmitted: (value) =>
                  userIDNotifier.onClickCompleteChangeUserID(context),
              controller: userIDNotifier.userIDController,
              actions: [
                if (!userID.isEditing)
                  TextButton(
                    onPressed: userIDNotifier.onClickChangeUserID,
                    child: const CustomText(
                      "status.UserIDStatus.userIDUpdate",
                      isColorful: true,
                      isBold: true,
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      semanticLabel:
                          "status.UserIDStatus.userIDUpdateCancelButton",
                    ),
                    onPressed: userIDNotifier.onClickCancelChangeUserID,
                  ),
                if (userID.isEditing)
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      semanticLabel:
                          "status.UserIDStatus.userIDUpdateConfirmButton",
                    ),
                    onPressed:
                        userIDNotifier.onClickCompleteChangeUserID(context),
                  ),
              ],
            ),

            // // 유저 전화번호 변경
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
            //   child: const CustomText(
            //     "home.userProfile.userPhoneNumber",
            //     isBold: true,
            //     isColorful: true,
            //   ),
            // ),
            // CustomTextfieldContainer(
            //   fieldKey: 'user_profile_phone_number',
            //   prefix: CustomCountryPickerWidget(
            //     isEditing: true,
            //     isDisabled: !phoneNumber.isEditing,
            //   ),
            //   labelText: phoneNumber.labelTextForEditing,
            //   validator: phoneNumber.validator,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   onChanged: phoneNumberNotifier.updatePhoneNumber,
            //   keyboardType: TextInputType.number,
            //   textInputAction: TextInputAction.next,
            //   inputFormatters: [
            //     FilteringTextInputFormatter.digitsOnly,
            //     LengthLimitingTextInputFormatter(15),
            //   ],
            //   autofillHints: const <String>[
            //     AutofillHints.telephoneNumberNational,
            //   ],
            //   controller: phoneNumberNotifier.phoneNumberController,
            //   enabled: phoneNumber.isEditing,
            //   actions: [
            //     if (!phoneNumber.isEditing)
            //       TextButton(
            //         onPressed: phoneNumberNotifier.onClickChangePhoneNumber,
            //         child: const CustomText(
            //           "status.PhoneNumberStatus.phoneNumberUpdate",
            //           isColorful: true,
            //           isBold: true,
            //         ),
            //       )
            //     else
            //       IconButton(
            //         icon: const Icon(
            //           Icons.cancel,
            //           semanticLabel:
            //               "status.PhoneNumberStatus.phoneNumberUpdateCancelButton",
            //         ),
            //         onPressed:
            //             phoneNumberNotifier.onClickCancelChangePhoneNumber,
            //       ),
            //     if (phoneNumber.isEditing)
            //       IconButton(
            //         icon: const Icon(
            //           Icons.check,
            //           semanticLabel:
            //               "status.PhoneNumberStatus.phoneNumberUpdateConfirmButton",
            //         ),
            //         onPressed: phoneNumberNotifier
            //             .onClickCompleteChangePhoneNumber(context),
            //       ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
