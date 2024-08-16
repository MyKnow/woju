import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';

class SignupUserinfoPage extends ConsumerWidget {
  const SignupUserinfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUp = ref.watch(signUpStateProvider);
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
                              await ref
                                  .read(signUpStateProvider.notifier)
                                  .pickImage(null, context);
                            },
                            child: ListTile(
                              title: const Text(
                                      "onboarding.signUp.detail.profileImage.default")
                                  .tr(),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await ref
                                  .read(signUpStateProvider.notifier)
                                  .pickImage(true, context);
                            },
                            child: ListTile(
                              title: const Text(
                                      "onboarding.signUp.detail.profileImage.fromGallery")
                                  .tr(),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await ref
                                  .read(signUpStateProvider.notifier)
                                  .pickImage(false, context);
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
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Row(
          children: <Widget>[
            // 키보드가 활성화 되어 있을 때만 키보드를 내리는 기능 버튼 표시
            if (MediaQuery.of(context).viewInsets.vertical > 0)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(
                    CupertinoIcons.keyboard_chevron_compact_down,
                  ),
                  tooltip: "accessibility.hideKeyboard".tr(),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("onboarding.signUp.next").tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
