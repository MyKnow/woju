import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/model/user/user_gender_model.dart';

import 'package:woju/provider/home/user_profile_state_notifier.dart';

import 'package:woju/theme/widget/custom_app_bar_action_button.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_date_picker.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';
import 'package:woju/theme/widget/custom_toggle_switch.dart';
import 'package:woju/theme/widget/profile_image_widget.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileEditState = ref.watch(userProfileStateNotifierProvider);
    final userProfileStateNotifier =
        ref.watch(userProfileStateNotifierProvider.notifier);

    return CustomScaffold(
      title: "home.userProfile.title",
      appBarActions: [
        if (userProfileEditState.isEditing)
          CustomAppBarTextButton(
            children: [
              CustomTextButton(
                "home.userProfile.cancel",
                minimumSize: const Size(48, 48),
                // padding: const EdgeInsets.only(right: 32),
                onPressed: () {
                  ref
                      .read(userProfileStateNotifierProvider.notifier)
                      .onClickUserProfileEditCancelButton();
                },
              ),
              CustomTextButton(
                "home.userProfile.save",
                // padding: const EdgeInsets.only(right: 24),
                minimumSize: const Size(48, 48),
                onPressed: ref
                    .read(userProfileStateNotifierProvider.notifier)
                    .onClickUserProfileEditCompletButton(context),
              ),
            ],
          )
        else if (userProfileEditState.isLoading)
          CustomAppBarTextButton(
            children: [
              CupertinoActivityIndicator(
                color: Theme.of(context).primaryColor,
                radius: Theme.of(context).textTheme.labelSmall?.fontSize ?? 16,
              ),
            ],
          )
        else
          CustomAppBarTextButton(
            text: "home.userProfile.edit",
            onPressed: () {
              ref
                  .read(userProfileStateNotifierProvider.notifier)
                  .onClickUserProfileEditButton();
            },
          ),
      ],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 유저 프로필 이미지 변경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 16, top: 40),
              child: const CustomText(
                "home.userProfile.userProfileImage",
                isBold: true,
                isColorful: true,
              ),
            ),
            ProfileImageWidget(
              isEditable: userProfileEditState.isEditing,
              image: userProfileEditState.userImage,
              onImageSelectedForDefault: () async {
                await userProfileStateNotifier.onClickUserProfileImage(
                    context, null);
              },
              onImageSelectedForGallery: () async {
                await userProfileStateNotifier.onClickUserProfileImage(
                    context, true);
              },
              onImageSelectedForCamera: () async {
                await userProfileStateNotifier.onClickUserProfileImage(
                    context, false);
              },
            ),

            // 유저 고유 번호 조회
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
            //   child: const CustomText(
            //     "home.userProfile.userUUID",
            //     isBold: true,
            //     isColorful: true,
            //   ),
            // ),
            // CustomDecorationContainer(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       CustomText(user ?? "",
            //           isLocalize: false,
            //           style: Theme.of(context).textTheme.labelMedium?.copyWith(
            //                 color: Theme.of(context).disabledColor,
            //               )),
            //       IconButton(
            //         icon: const Icon(Icons.copy),
            //         onPressed: () {
            //           Clipboard.setData(ClipboardData(text: user ?? ""));
            //           ToastMessageService.nativeSnackbar(
            //             "home.userProfile.userUUIDCopied",
            //             context,
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),

            // 유저 닉네임 변경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 56),
              child: const CustomText(
                "home.userProfile.userNickName",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomTextfieldContainer(
              fieldKey: "user_profile_user_nick_name",
              prefixIcon: const Icon(Icons.person),
              labelText:
                  userProfileEditState.userNicknameModel.labelTextForEditing,
              validator: userProfileEditState.userNicknameModel.validator,
              onChanged: userProfileStateNotifier.onChangeUserNickname,
              enabled: userProfileEditState.isEditing,
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.nickname],
              inputFormatters:
                  userProfileEditState.userNicknameModel.inputFormatters,
              controller: userProfileEditState.userNicknameController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
            ),

            // 유저 성별 변경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
              child: const CustomText(
                "home.userProfile.userGender",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomToggleSwitch(
              initialIndex: userProfileEditState.userGender.index,
              labels: GenderExtension.getGenderList(),
              onToggle: (index) {
                if (userProfileEditState.isEditing) {
                  userProfileStateNotifier.onChangeUserGender(index);
                }
              },
              changeOnTap: userProfileEditState.isEditing,
            ),

            // 유저 생년월일 변경
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 36),
              child: const CustomText(
                "home.userProfile.userBirthDate",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomDatePicker(
              selectedDate: userProfileEditState.userBirthDate,
              isEditing: userProfileEditState.isEditing,
              onDateChanged: userProfileStateNotifier.onChangeUserBirthDate,
            ),

            // 유저 계정 관리 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 36),
              child: const CustomText(
                "home.userProfile.userAccountAction",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomDecorationContainer(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.lock_shield_fill,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    title: const CustomText(
                      "home.userProfile.userPasswordChange.title",
                      isLocalize: true,
                    ),
                    onTap: () {
                      userProfileStateNotifier
                          .navigateToChangePasswordPage(context);
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.phone_fill,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    title: const CustomText(
                      "home.userProfile.userPhoneNumberChange.title",
                      isLocalize: true,
                    ),
                    onTap: () {
                      userProfileStateNotifier
                          .navigateToChangePhoneNumberPage(context);
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.person_crop_circle_fill,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    title: const CustomText(
                      "home.userProfile.userIDChange.title",
                      isLocalize: true,
                    ),
                    onTap: () {
                      userProfileStateNotifier.navigateToChangeIdPage(context);
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    title: const CustomText(
                      "home.userProfile.userSignOut",
                      isLocalize: true,
                    ),
                    onTap: () {
                      userProfileStateNotifier.onClickLogoutButton();
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_remove_rounded,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                      applyTextScaling: true,
                    ),
                    title: const CustomText(
                      "home.userProfile.userWithdrawal.title",
                      isLocalize: true,
                    ),
                    onTap: () {
                      userProfileStateNotifier
                          .navigateToWithdrawalPage(context);
                    },
                  ),
                ],
              ),
            ),

            // 바텀 패딩
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      floatingActionButtonChild: Container(),
    );
  }
}
