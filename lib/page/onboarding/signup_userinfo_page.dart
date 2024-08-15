import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
            // 닉네임 입력
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  labelText: "onboarding.signUp.detail.nickname".tr(),
                  suffix: TextButton(
                    onPressed: () {
                      // TODO : 서버에서 닉네임 중복 체크
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      fixedSize: const Size(100, 50),
                    ),
                    child: const Text("onboarding.signUp.detail.nickname.check")
                        .tr(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
