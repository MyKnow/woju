import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:woju/provider/onboarding/onboarding_state_notifier.dart';
import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';
import 'package:woju/service/debug_service.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneNumberTextEditingController =
        ref.watch(phoneNumberTextEditingControllerProvider);
    final stateOfAuthCodeSent = ref.watch(signUpStateProvider).authCodeSent;
    return Scaffold(
      appBar: AppBar(
        title: const Text("onboarding.signUp.title").tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final signUp = ref.watch(signUpStateProvider);
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
                  child: InternationalPhoneNumberInput(
                    initialValue: PhoneNumber(
                      phoneNumber: signUp.phoneNumber,
                      isoCode: signUp.isoCode,
                      dialCode: signUp.dialCode,
                    ),
                    inputDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "onboarding.signUp.phoneNumber".tr(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        suffix: (stateOfAuthCodeSent)
                            ? TextButton(
                                onPressed: () {
                                  ref
                                      .read(signUpStateProvider.notifier)
                                      .changePhoneNumber();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                        "onboarding.signUp.changePhoneNumber")
                                    .tr(),
                              )
                            : TextButton(
                                onPressed: ref
                                    .read(signUpStateProvider.notifier)
                                    .sendAuthCodeButton(
                                      phoneNumberTextEditingController.text,
                                    ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text("onboarding.signUp.sendCode")
                                    .tr(),
                              )),
                    textFieldController: phoneNumberTextEditingController,
                    onInputValidated: (bool value) {
                      printd("onInputValidated: $value");
                      ref
                          .read(signUpStateProvider.notifier)
                          .updatePhoneNumberValid(value);
                    },
                    isEnabled: !stateOfAuthCodeSent,
                    validator: (String? value) {
                      printd("validator: $value");
                      if (signUp.isPhoneNumberValid) {
                        return null;
                      } else {
                        return "onboarding.signUp.error.phoneNumberInvalid"
                            .tr();
                      }
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    onInputChanged: (PhoneNumber number) {
                      ref
                          .read(signUpStateProvider.notifier)
                          .updateIsoCode(number.isoCode ?? "");
                      ref
                          .read(signUpStateProvider.notifier)
                          .updateDialCode(number.dialCode ?? "");
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                    keyboardType: TextInputType.number,
                    keyboardAction: TextInputAction.done,
                    hintText: "onboarding.signUp.phoneNumber".tr(),
                    searchBoxDecoration: InputDecoration(
                      hintText: "onboarding.signUp.searchCountry".tr(),
                    ),
                    spaceBetweenSelectorAndTextField: 0,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
            if (stateOfAuthCodeSent) // 인증코드 요청 시 true로 변경
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
                    hintText: "onboarding.signUp.authCode".tr(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    suffix: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: ref
                              .read(signUpStateProvider.notifier)
                              .resendAuthCodeButton(
                                  phoneNumberTextEditingController.text),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text("onboarding.signUp.authCodeResend")
                              .tr(),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: ref
                              .read(signUpStateProvider.notifier)
                              .verifyAuthCodeButton(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text("onboarding.signUp.authCodeVerify")
                              .tr(),
                        ),
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
                ),
              ),
          ],
        ),
      ),
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
                onPressed: () {
                  ref
                      .read(onboardingStateProvider.notifier)
                      .pushRouteSignInPage(context);
                },
                child: const Text("onboarding.signUp.next").tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
