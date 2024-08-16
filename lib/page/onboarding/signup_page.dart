import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUp = ref.watch(signUpStateProvider);
    final focus = ref.watch(signUpAuthFocusProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("onboarding.signUp.title").tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            // 전화번호 입력
            Consumer(
              builder: (context, ref, child) {
                return Container(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 280,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            prefix: CountryCodePicker(
                              onChanged: ref
                                  .read(signUpStateProvider.notifier)
                                  .onCountryCodeChanged,
                              initialSelection: 'KR',
                              favorite: const ['KR', 'US'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              padding: EdgeInsets.zero,
                              flagWidth: 24,
                              searchDecoration: InputDecoration(
                                labelText:
                                    "onboarding.signUp.searchCountry".tr(),
                              ),
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              closeIcon: const Icon(CupertinoIcons.clear),
                              enabled: !signUp.authCompleted,
                            ),
                            labelText: (signUp.authCompleted)
                                ? "onboarding.signUp.phoneNumberAvailable".tr()
                                : "onboarding.signUp.phoneNumber".tr(),
                          ),
                          validator: ref
                              .read(signUpStateProvider.notifier)
                              .phoneNumberValidation,
                          focusNode: focus[0],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            ref
                                .read(signUpStateProvider.notifier)
                                .phoneNumberOnChange(value);
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                          autofillHints: const <String>[
                            AutofillHints.telephoneNumberNational,
                          ],
                          enabled: !signUp.authCodeSent,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: (signUp.authCodeSent)
                            ? TextButton(
                                onPressed: () {
                                  ref
                                      .read(signUpStateProvider.notifier)
                                      .changePhoneNumber();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                        "onboarding.signUp.changePhoneNumber")
                                    .tr(),
                              )
                            : TextButton(
                                onPressed: ref
                                    .read(signUpStateProvider.notifier)
                                    .sendAuthCodeButton(),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("onboarding.signUp.sendCode")
                                    .tr(),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
            if (signUp.authCodeSent &&
                !signUp.authCompleted) // 인증코드 요청 시 true로 변경
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
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    labelText: "onboarding.signUp.authCode".tr(),
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: ref
                              .read(signUpStateProvider.notifier)
                              .resendAuthCodeButton(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("onboarding.signUp.authCodeResend")
                              .tr(),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                            onPressed: ref
                                .read(signUpStateProvider.notifier)
                                .verifyAuthCodeButton(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: (!signUp.authCompleted)
                                ? const Text("onboarding.signUp.authCodeVerify")
                                    .tr()
                                : const Text(
                                        "onboarding.signUp.authCodeVerified")
                                    .tr()),
                      ],
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autofillHints: const <String>[AutofillHints.oneTimeCode],
                  onChanged: (value) {
                    ref
                        .read(signUpStateProvider.notifier)
                        .updateAuthCode(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  enabled: !signUp.authCompleted,
                  focusNode: focus[1],
                ),
              ),

            // 아이디 입력
            if (signUp.authCompleted)
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          labelText: (signUp.isIDAvailable)
                              ? "onboarding.signUp.userIDAvailable".tr()
                              : "onboarding.signUp.userID".tr(),
                        ),
                        keyboardType: TextInputType.streetAddress,
                        autofillHints: const <String>[
                          AutofillHints.newUsername
                        ],
                        onChanged: (value) {
                          ref
                              .read(signUpStateProvider.notifier)
                              .updateUserID(value);
                        },
                        inputFormatters: [
                          // 소문자, 숫자만 입력 가능
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-z0-9]')),
                          // 최대 20자까지 입력 가능
                          LengthLimitingTextInputFormatter(20),
                        ],
                        validator: ref
                            .read(signUpStateProvider.notifier)
                            .userIDValidation,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: !signUp.isIDAvailable,
                        focusNode: focus[2],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 70,
                      child: (signUp.isIDAvailable)
                          ? TextButton(
                              onPressed: () {
                                ref
                                    .read(signUpStateProvider.notifier)
                                    .modifyIDButton();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child:
                                  const Text("onboarding.signUp.modifyUserID")
                                      .tr(),
                            )
                          : TextButton(
                              onPressed: ref
                                  .read(signUpStateProvider.notifier)
                                  .checkAvailableIDButton(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("onboarding.signUp.userIDCheck")
                                  .tr(),
                            ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // 패스워드 입력
            if (signUp.isIDAvailable)
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            CupertinoIcons.lock_fill,
                            size: 24,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          labelText: (signUp.isPasswordAvailable)
                              ? "onboarding.signUp.passwordAvailable".tr()
                              : "onboarding.signUp.password".tr(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        autofillHints: const <String>[
                          AutofillHints.newPassword
                        ],
                        onChanged: ref
                            .read(signUpStateProvider.notifier)
                            .passwordOnChange,
                        inputFormatters: [
                          // 소문자, 대문자, 숫자, 특수문자만 입력 가능
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9!@#$%^&*()]')),
                          // 최대 30자까지 입력 가능
                          LengthLimitingTextInputFormatter(30),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: focus[3],
                        validator: ref
                            .read(signUpStateProvider.notifier)
                            .passwordValidation,
                        obscureText: !signUp.isPasswordVisible,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 50,
                      width: 70,
                      child: IconButton(
                        onPressed: () {
                          ref
                              .read(signUpStateProvider.notifier)
                              .changePasswordVisibilityButton();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: (signUp.isPasswordVisible)
                            ? const Icon(CupertinoIcons.eye_fill)
                            : const Icon(CupertinoIcons.eye_slash_fill),
                      ),
                    ),
                  ],
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
            if (MediaQuery.of(context).viewInsets.vertical > 50)
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
                onPressed:
                    ref.read(signUpStateProvider.notifier).nextButton(context),
                child: const Text("onboarding.signUp.next").tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
