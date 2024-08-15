import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupUserinfoPage extends ConsumerWidget {
  const SignupUserinfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const CircleAvatar(
              radius: 100,
            ),
            const SizedBox(
              height: 20,
              width: double.infinity,
            ),
            // 아이디 입력
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
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  labelText: "onboarding.signUp.detail.userID".tr(),
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child:
                            const Text("onboarding.signUp.detail.userIDCheck")
                                .tr(),
                      ),
                    ],
                  ),
                ),
                keyboardType: TextInputType.streetAddress,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                onChanged: (value) {},
                inputFormatters: [
                  // 소문자, 숫자만 입력 가능
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]')),
                  // 최대 20자까지 입력 가능
                  LengthLimitingTextInputFormatter(20),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "onboarding.signUp.detail.userIDEmpty".tr();
                  } else if (value.length < 4) {
                    return "onboarding.signUp.detail.userIDShort".tr();
                  } else if (value.length > 20) {
                    return "onboarding.signUp.detail.userIDLong".tr();
                  }
                  // 소문자, 숫자만 입력 가능
                  if (!RegExp(r'^[a-z0-9]*$').hasMatch(value)) {
                    return "onboarding.signUp.detail.userIDInvalid".tr();
                  }

                  // 소문자가 4개 이상 포함되어야 함
                  if (RegExp(r'[a-z]').allMatches(value).length < 4) {
                    return "onboarding.signUp.detail.userIDInvalid".tr();
                  }

                  // 중복된 아이디 체크
                  // TODO: 중복된 아이디 체크

                  // 유효성 검사 통과
                  // TODO : userID valid check
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // enabled: !signUp.authCompleted,
              ),
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
