import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';

import 'package:woju/theme/widget/custom_app_bar_action_button.dart';
import 'package:woju/theme/widget/custom_country_picker_widget.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(signInStateProvider);
    final signInNotifier = ref.watch(signInStateProvider.notifier);
    final theme = Theme.of(context);

    return CustomScaffold(
      title: "onboarding.signIn.title",
      appBarActions: [
        // 로그인 방법 변경
        CustomAppBarTextButton(
          text: (signIn.loginWithPhoneNumber)
              ? "onboarding.signIn.signInWithID"
              : "onboarding.signIn.signInWithPhoneNumber",
          onPressed: () {
            FocusScope.of(context).unfocus();
            signInNotifier.changeLoginButton();
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (signIn.loginWithPhoneNumber)
              // 전화번호 입력
              CustomTextfieldContainer(
                fieldKey: 'phoneNumberForSignIn',
                prefix: CustomCountryPickerWidget(
                  onChanged: signInNotifier.countryCodeOnChange,
                  dialogSize: const Size(350, 500),
                  searchDecoration: InputDecoration(
                    labelText: "onboarding.signUp.searchCountry".tr(),
                    labelStyle: theme.primaryTextTheme.bodyMedium,
                  ),
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
                ),
                labelText: signIn.userPhoneModel.labelTextWithParameter(false),
                validator: signIn.userPhoneModel.validator,
                // focusNode: focus[0],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: signInNotifier.phoneNumberOnChange,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: signIn.userPhoneModel.inputFormatters,
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
                fieldKey: 'userIDForSignIn',
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
                inputFormatters: signIn.userIDModel.inputFormatters,
                initialValue: signIn.userIDModel.userID,
              )
            else
              Container(),

            const SizedBox(height: 16),
            // 비밀번호 입력
            CustomTextfieldContainer(
              fieldKey: 'passwordForSignIn',
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
              inputFormatters: signIn.userPasswordModel.inputFormatters,
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
      floatingActionButtonCallback: signInNotifier.loginButtonOnClick(context),
      floatingActionButtonText: "onboarding.signIn.signIn",
    );
  }
}
