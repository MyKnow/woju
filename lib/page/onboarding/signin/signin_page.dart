import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';
import 'package:woju/provider/theme_state_notififer.dart';
import 'package:woju/theme/widget/bottom_floating_button.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(signInStateProvider);
    final signInNotifier = ref.watch(signInStateProvider.notifier);
    final theme = ref.watch(themeStateNotifierProvider.notifier).theme;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText("onboarding.signIn.title", isTitle: true),
        actions: [
          // 로그인 방법 변경
          CustomTextButton(
            (signIn.loginWithPhoneNumber)
                ? "onboarding.signIn.signInWithID"
                : "onboarding.signIn.signInWithPhoneNumber",
            onPressed: () {
              FocusScope.of(context).unfocus();
              signInNotifier.changeLoginButton();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (signIn.loginWithPhoneNumber)
              // 전화번호 입력
              CustomTextfieldContainer(
                prefix: CountryCodePicker(
                  backgroundColor: theme.cardColor,
                  onChanged: signInNotifier.countryCodeOnChange,
                  dialogBackgroundColor: theme.cardColor,
                  dialogTextStyle: theme.primaryTextTheme.bodyMedium,
                  dialogSize: const Size(350, 500),
                  initialSelection: 'KR',
                  favorite: const ['KR', 'US'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: EdgeInsets.zero,
                  searchDecoration: InputDecoration(
                    labelText: "onboarding.signUp.searchCountry".tr(),
                    labelStyle: theme.primaryTextTheme.bodyMedium,
                  ),
                  searchStyle: theme.primaryTextTheme.bodyMedium,
                  builder: (country) {
                    if (country == null) {
                      return const SizedBox.shrink();
                    }
                    return Row(
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
                        ),
                      ],
                    );
                  },
                  closeIcon: const Icon(CupertinoIcons.clear),
                ),
                labelText: signIn.userPhoneModel.labelTextWithParameter(false),
                validator: signIn.userPhoneModel.validator,
                // focusNode: focus[0],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: signInNotifier.phoneNumberOnChange,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                autofillHints: const <String>[
                  AutofillHints.telephoneNumberNational,
                ],
                initialValue: signIn.userPhoneModel.phoneNumber,
              )
            else
              Container(),

            if (!signIn.loginWithPhoneNumber)
              // 아이디 입력
              CustomTextfieldContainer(
                labelText: signIn.userIDModel.labelTextWithParameter(false),
                prefixIcon: const Icon(
                  CupertinoIcons.person_fill,
                  size: 24,
                ),
                validator: signIn.userIDModel.validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: signInNotifier.userIDOnChange,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  // 소문자, 대문자, 숫자만 입력 가능
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  // 최대 20자까지 입력 가능
                  LengthLimitingTextInputFormatter(20),
                ],
                initialValue: signIn.userIDModel.userID,
              )
            else
              Container(),
            // 비밀번호 입력
            CustomTextfieldContainer(
              prefixIcon: const Icon(
                CupertinoIcons.lock_fill,
                size: 24,
              ),
              labelText: signIn.userPasswordModel.labelTextWithParameter(false),
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const <String>[
                AutofillHints.password,
              ],
              onChanged: signInNotifier.passwordOnChange,
              inputFormatters: [
                // 소문자, 대문자, 숫자, 특수문자만 입력 가능
                FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9!@#$%^&*()]')),
                // 최대 30자까지 입력 가능
                LengthLimitingTextInputFormatter(30),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // focusNode: focus[3],
              validator: signIn.userPasswordModel.validator,
              obscureText: !signIn.userPasswordModel.isPasswordVisible,
              initialValue: signIn.userPasswordModel.userPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: signInNotifier.loginButtonOnClick(context),
              actions: [
                SizedBox(
                  height: 50,
                  width: 70,
                  child: IconButton(
                    onPressed: () {
                      signInNotifier.togglePasswordVisibilityButton();
                    },
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: (signIn.userPasswordModel.isPasswordVisible)
                        ? Icon(CupertinoIcons.eye_fill,
                            semanticLabel:
                                "accessibility.hidePasswordFieldButton".tr())
                        : Icon(CupertinoIcons.eye_slash_fill,
                            semanticLabel:
                                "accessibility.showPasswordFieldButton".tr()),
                  ),
                ),
              ],
            ),

            // 비밀번호 재설정 텍스트 버튼
            CustomTextButton(
              "onboarding.signIn.forgotPassword",
              onPressed: () =>
                  signInNotifier.resetPasswordButtonOnClick(context),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: BottomFloatingButton.centerDocked,
      floatingActionButton: BottomFloatingButton.build(
        context,
        ref,
        signInNotifier.loginButtonOnClick(context),
        "onboarding.signIn.signIn",
      ),
    );
  }
}
