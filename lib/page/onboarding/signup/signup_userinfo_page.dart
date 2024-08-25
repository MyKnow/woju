import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';
import 'package:woju/theme/widget/bottom_floating_button.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class SignupUserinfoPage extends ConsumerWidget {
  const SignupUserinfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUp = ref.watch(signUpStateProvider);
    final signUpNotifier = ref.read(signUpStateProvider.notifier);
    final focus = ref.watch(signUpAuthFocusProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:
            const CustomText("onboarding.signUp.detail.title", isTitle: true),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            // 프로필 사진 설정
            // 그림자 효과를 주기 위해 Container로 감싸고 BoxDecoration을 사용
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  showMaterialModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        border: Border.merge(
                          Border(
                            top: BorderSide(
                              color: theme.primaryColor,
                              width: 2,
                            ),
                          ),
                          const Border(
                            bottom: BorderSide.none,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              await signUpNotifier.pickImage(null, context);
                            },
                            child: const ListTile(
                              title: CustomText(
                                "onboarding.signUp.detail.profileImage.default",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                            color: theme.shadowColor,
                          ),
                          InkWell(
                            onTap: () async {
                              await signUpNotifier.pickImage(true, context);
                            },
                            child: const ListTile(
                              title: CustomText(
                                "onboarding.signUp.detail.profileImage.fromGallery",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                            color: theme.shadowColor,
                          ),
                          InkWell(
                            onTap: () async {
                              await signUpNotifier.pickImage(false, context);
                            },
                            child: const ListTile(
                              title: CustomText(
                                "onboarding.signUp.detail.profileImage.fromCamera",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(100),
                excludeFromSemantics: true,
                child: CircleAvatar(
                  foregroundColor: theme.primaryColor,
                  backgroundColor: theme.cardColor,
                  radius: 100,
                  child: (signUp.profileImage == null)
                      ? const Icon(
                          CupertinoIcons.person_crop_circle,
                          size: 100,
                          semanticLabel:
                              "onboarding.signUp.detail.profileImage.default",
                        )
                      : // 이미지가 있을 경우 원형 이미지로 표시
                      CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(
                            File(signUp.profileImage!.path),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
              width: double.infinity,
            ),
            // 닉네임 입력
            CustomTextfieldContainer(
              prefixIcon: const Icon(
                CupertinoIcons.person_fill,
                size: 24,
              ),
              labelText: signUp.userNickNameModel.labelText,
              keyboardType: TextInputType.name,
              autofillHints: const <String>[AutofillHints.nickname],
              onChanged: signUpNotifier.nickNameOnChange,
              inputFormatters: [
                // 최대 20자까지 입력 가능
                LengthLimitingTextInputFormatter(20),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              focusNode: focus[4],
              validator: signUp.userNickNameModel.validator,
              initialValue: signUp.userNickNameModel.nickname,
            ),

            // 성별 선택 (비공개, 남성, 여성, 기타 중 선택)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25, bottom: 8, top: 20),
              child: const CustomText(
                "status.gender.title",
              ),
            ),
            CustomDecorationContainer(
              height: 70,
              child: ToggleSwitch(
                minWidth: 400,
                minHeight: 70,
                fontSize: theme.primaryTextTheme.bodyMedium!.fontSize!,
                initialLabelIndex: signUp.gender.index,
                activeBgColor: [theme.primaryColor],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.transparent,
                inactiveFgColor:
                    theme.primaryTextTheme.bodyMedium!.color?.withAlpha(100),
                totalSwitches: 4,
                labels: Gender.values
                    .map((e) => e.toMessage.tr())
                    .toList(growable: false),
                radiusStyle: true,
                dividerColor: theme.shadowColor,
                onToggle: (index) {
                  if (index == null) return;
                  signUpNotifier.genderSelect(Gender.values[index]);
                },
              ),
            ),

            const SizedBox(
              height: 20,
              width: double.infinity,
            ),

            // 생년월일 선택
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25, bottom: 8, top: 20),
              child: const CustomText(
                "onboarding.signUp.detail.birth",
              ),
            ),

            CustomDecorationContainer(
              height: 150,
              child: ScrollDatePicker(
                // 만 14세 이상만 선택 가능
                maximumDate:
                    DateTime.now().subtract(const Duration(days: 365 * 14)),
                selectedDate: signUp.birthDate,
                locale: context.locale,
                scrollViewOptions: DatePickerScrollViewOptions(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  year: ScrollViewDetailOptions(
                    textStyle: theme.primaryTextTheme.bodyMedium!,
                    selectedTextStyle: theme.primaryTextTheme.bodyLarge!,
                    alignment: Alignment.center,
                  ),
                  month: ScrollViewDetailOptions(
                    textStyle: theme.primaryTextTheme.bodyMedium!,
                    selectedTextStyle: theme.primaryTextTheme.bodyLarge!,
                    alignment: Alignment.center,
                  ),
                  day: ScrollViewDetailOptions(
                    textStyle: theme.primaryTextTheme.bodyMedium!,
                    selectedTextStyle: theme.primaryTextTheme.bodyLarge!,
                    alignment: Alignment.center,
                  ),
                ),
                onDateTimeChanged: signUpNotifier.birthDateSelect,
                options: DatePickerOptions(
                  backgroundColor: theme.cardTheme.color!,
                  diameterRatio: 1.7,
                  itemExtent: 48,
                  isLoop: false,
                ),
                indicator: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.shadowColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
              width: double.infinity,
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: BottomFloatingButton.centerDocked,
      floatingActionButton: BottomFloatingButton.build(
        context,
        ref,
        signUpNotifier.completeButton(context),
        "onboarding.signUp.detail.done",
      ),
    );
  }
}
