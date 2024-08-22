import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import 'package:woju/model/user/user_gender_model.dart';
import 'package:woju/model/user/user_nickname_model.dart';
import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';
import 'package:woju/widget/bottom_floating_button.dart';

class SignupUserinfoPage extends ConsumerWidget {
  const SignupUserinfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUp = ref.watch(signUpStateProvider);
    final signUpNotifier = ref.read(signUpStateProvider.notifier);
    final focus = ref.watch(signUpAuthFocusProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("onboarding.signUp.detail.title").tr(),
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
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              await signUpNotifier.pickImage(null, context);
                            },
                            child: ListTile(
                              title: const Text(
                                      "onboarding.signUp.detail.profileImage.default")
                                  .tr(),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await signUpNotifier.pickImage(true, context);
                            },
                            child: ListTile(
                              title: const Text(
                                      "onboarding.signUp.detail.profileImage.fromGallery")
                                  .tr(),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await signUpNotifier.pickImage(false, context);
                            },
                            child: ListTile(
                              title: const Text(
                                      "onboarding.signUp.detail.profileImage.fromCamera")
                                  .tr(),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      CupertinoIcons.person,
                      size: 24,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    labelText: signUp.userNickNameModel.labelText().tr(),
                  ),
                  keyboardType: TextInputType.name,
                  autofillHints: const <String>[AutofillHints.nickname],
                  onChanged: signUpNotifier.nickNameOnChange,
                  inputFormatters: [
                    // 최대 20자까지 입력 가능
                    LengthLimitingTextInputFormatter(20),
                  ],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: focus[4],
                  validator: (value) {
                    final result = UserNicknameModel.nickNameValidator(value);

                    if (result == UserNickNameStatus.valid) {
                      return null;
                    } else {
                      return result.toMessage.tr();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),

            // 성별 선택 (비공개, 남성, 여성, 기타 중 선택)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25, bottom: 8),
              child: const Text("status.gender.title").tr(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: Gender.values.map((gender) {
                  return InkWell(
                    onTap: () {
                      signUpNotifier.genderSelect(gender);
                    },
                    excludeFromSemantics: true,
                    child: Row(
                      children: [
                        Radio<Gender>(
                          value: gender,
                          groupValue: signUp.gender,
                          onChanged: signUpNotifier.genderSelect,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          splashRadius: 0,
                        ),
                        SizedBox(
                          width: 50,
                          child: Text(
                            gender.toMessage,
                            maxLines: 1,
                          ).tr(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(
              height: 20,
              width: double.infinity,
            ),

            // 생년월일 선택
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25, bottom: 8),
              child: const Text("onboarding.signUp.detail.birth").tr(),
            ),

            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ScrollDatePicker(
                // 만 14세 이상만 선택 가능
                maximumDate:
                    DateTime.now().subtract(const Duration(days: 365 * 14)),
                selectedDate: signUp.birthDate,
                locale: context.locale,
                scrollViewOptions: const DatePickerScrollViewOptions(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                onDateTimeChanged: signUpNotifier.birthDateSelect,
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
