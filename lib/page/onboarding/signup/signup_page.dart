import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';
import 'package:woju/theme/widget/bottom_floating_button.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUp = ref.watch(signUpStateProvider);
    final signUpNotifier = ref.read(signUpStateProvider.notifier);
    final focus = ref.watch(signUpAuthFocusProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("onboarding.signUp.title", isTitle: true),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CustomTextButton(
              "onboarding.signUp.signin",
              onPressed: () {
                context.go('/onboarding/signin');
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            // 전화번호 입력
            CustomTextfieldContainer(
              fieldKey: 'phoneNumberForSignUp',
              prefix: CountryCodePicker(
                onChanged:
                    ref.read(signUpStateProvider.notifier).onCountryCodeChanged,
                initialSelection: 'KR',
                favorite: const ['KR', 'US'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                padding: EdgeInsets.zero,
                searchDecoration: InputDecoration(
                  labelText: "onboarding.signUp.searchCountry".tr(),
                ),
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                builder: (country) {
                  if (country == null) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          country.flagUri ?? '',
                          package: 'country_code_picker',
                          width: 32,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          country.dialCode ?? '',
                          style: (signUp.userAuthModel.authCodeSent)
                              ? theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey,
                                )
                              : theme.primaryTextTheme.bodyMedium,
                          isLocalize: false,
                        ),
                        // const SizedBox(width: 16),
                      ],
                    ),
                  );
                },
                closeIcon: const Icon(CupertinoIcons.clear),
                enabled: !signUp.userAuthModel.authCompleted,
              ),
              labelText: signUp.userPhoneModel.labelTextWithParameter(
                signUp.userAuthModel.authCompleted,
              ),
              validator: signUp.userPhoneModel.validator,
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
              enabled: !signUp.userAuthModel.authCodeSent,
              textStyle: (signUp.userAuthModel.authCodeSent)
                  ? theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    )
                  : theme.primaryTextTheme.bodyMedium,
              actions: [
                SizedBox(
                  width: 80,
                  child: (signUp.userAuthModel.authCodeSent)
                      ? CustomTextButton(
                          "onboarding.signUp.changePhoneNumber",
                          onPressed: () {
                            ref
                                .read(signUpStateProvider.notifier)
                                .changePhoneNumber();
                          },
                          minimumSize: const Size(80, 80),
                        )
                      : CustomTextButton(
                          "onboarding.signUp.sendCode",
                          onPressed: ref
                              .read(signUpStateProvider.notifier)
                              .sendAuthCodeButton(),
                          minimumSize: const Size(80, 80),
                        ),
                ),
              ],
            ),

            // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
            if (signUp.userAuthModel.authCodeSent &&
                !signUp.userAuthModel.authCompleted)
              CustomTextfieldContainer(
                fieldKey: 'authCodeForSignUp',
                labelText: signUp.userAuthModel.labelText,
                actions: [
                  CustomTextButton(
                    "status.authcode.resend",
                    onPressed: signUpNotifier.resendAuthCodeButton(),
                    minimumSize: const Size(80, 80),
                  ),
                  CustomTextButton(
                    (!signUp.userAuthModel.authCompleted)
                        ? "status.authcode.verify"
                        : "status.authcode.verified",
                    onPressed: signUpNotifier.verifyAuthCodeButton(),
                    minimumSize: const Size(80, 80),
                  ),
                ],
                keyboardType: TextInputType.number,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                onChanged: (value) {
                  ref
                      .read(signUpStateProvider.notifier)
                      .updateUserAuthModel(authCode: value);
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                enabled: !signUp.userAuthModel.authCompleted,
                textStyle: (signUp.userAuthModel.authCompleted)
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      )
                    : theme.primaryTextTheme.bodyMedium,
                focusNode: focus[1],
                validator: signUp.userAuthModel.validator,
              )
            else
              Container(),
            // 인증 완료 시 아이디 입력창 표시
            if (signUp.userAuthModel.authCompleted)
              CustomTextfieldContainer(
                fieldKey: 'userIDForSignUp',
                prefixIcon: const Icon(Icons.person),
                labelText: signUp.userIDModel.labelTextWithParameter(true),
                keyboardType: TextInputType.streetAddress,
                autofillHints: const <String>[AutofillHints.newUsername],
                onChanged: (value) {
                  ref.read(signUpStateProvider.notifier).updateUserID(value);
                },
                inputFormatters: [
                  // 소문자, 숫자만 입력 가능
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9]')),
                  // 최대 20자까지 입력 가능
                  LengthLimitingTextInputFormatter(20),
                ],
                validator: signUp.userIDModel.validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: !signUp.userIDModel.isIDAvailable,
                textStyle: (signUp.userIDModel.isIDAvailable)
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      )
                    : theme.primaryTextTheme.bodyMedium,
                focusNode: focus[2],
                actions: [
                  SizedBox(
                    width: 80,
                    child: (signUp.userIDModel.isIDAvailable)
                        ? CustomTextButton(
                            "onboarding.signUp.modifyUserID",
                            onPressed: () {
                              ref
                                  .read(signUpStateProvider.notifier)
                                  .modifyIDButton();
                            },
                            minimumSize: const Size(80, 80),
                          )
                        : CustomTextButton(
                            "onboarding.signUp.userIDCheck",
                            onPressed: ref
                                .read(signUpStateProvider.notifier)
                                .checkAvailableIDButton(),
                            minimumSize: const Size(80, 80),
                          ),
                  ),
                ],
              )
            else
              Container(),

            // 아이디 입력 완료 시 비밀번호 입력창 표시
            if (signUp.userIDModel.isIDAvailable)
              CustomTextfieldContainer(
                fieldKey: 'passwordForSignUp',
                prefixIcon: const Icon(
                  CupertinoIcons.lock_fill,
                  size: 24,
                ),
                labelText: signUp.userPasswordModel.labelText,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const <String>[AutofillHints.newPassword],
                onChanged:
                    ref.read(signUpStateProvider.notifier).passwordOnChange,
                inputFormatters: [
                  // 소문자, 대문자, 숫자, 특수문자만 입력 가능
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9!@#$%^&*()]')),
                  // 최대 30자까지 입력 가능
                  LengthLimitingTextInputFormatter(30),
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focus[3],
                validator: signUp.userPasswordModel.validator,
                obscureText: !signUp.userPasswordModel.isPasswordVisible,
                actions: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(signUpStateProvider.notifier)
                            .changePasswordVisibilityButton();
                      },
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(80, 80),
                      ),
                      icon: (signUp.userPasswordModel.isPasswordVisible)
                          ? Icon(CupertinoIcons.eye_fill,
                              size: 24,
                              semanticLabel:
                                  "accessibility.hidePasswordFieldButton".tr())
                          : Icon(CupertinoIcons.eye_slash_fill,
                              size: 24,
                              semanticLabel:
                                  "accessibility.showPasswordFieldButton".tr()),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: BottomFloatingButton.centerDocked,
      floatingActionButton: BottomFloatingButton.build(context, ref,
          signUpNotifier.nextButton(context), "onboarding.signUp.next"),
    );
  }
}
