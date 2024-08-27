import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/provider/onboarding/auth_state_notififer.dart';
import 'package:woju/provider/onboarding/password_state_notifier.dart';
import 'package:woju/provider/onboarding/phone_number_state_notifier.dart';
import 'package:woju/provider/textfield_focus_state_notifier.dart';
import 'package:woju/provider/theme_state_notififer.dart';
import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/toast_message_service.dart';
import 'package:woju/theme/widget/bottom_floating_button.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class PasswordResetPage extends ConsumerStatefulWidget {
  const PasswordResetPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PasswordResetPageState();
  }
}

class PasswordResetPageState extends ConsumerState<PasswordResetPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeStateNotifierProvider.notifier).theme;
    final auth = ref.watch(authStateProvider);
    final authNotifier = ref.watch(authStateProvider.notifier);
    final phoneNumber = ref.watch(phoneNumberStateProvider);
    final phoneNumberNotifier = ref.watch(phoneNumberStateProvider.notifier);
    final password = ref.watch(passwordStateProvider);
    final passwordNotifier = ref.watch(passwordStateProvider.notifier);
    final focus = ref.watch(textfieldFocusStateProvider(3));
    final focusNotifier = ref.watch(textfieldFocusStateProvider(3).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const CustomText("onboarding.signIn.resetPassword.title",
            isTitle: true),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // 전화번호 입력
            CustomTextfieldContainer(
              fieldKey: "phoneNumberForPasswordReset",
              prefix: CountryCodePicker(
                onChanged: (country) {
                  phoneNumberNotifier.updateCountryCode(
                    country.dialCode ?? "",
                    country.code ?? "",
                  );
                },
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
                        style: (auth.authCodeSent)
                            ? theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                              )
                            : theme.primaryTextTheme.bodyMedium,
                        isLocalize: false,
                      ),
                    ],
                  );
                },
                closeIcon: const Icon(CupertinoIcons.clear),
                enabled: !auth.authCompleted,
              ),
              labelText: phoneNumber.labelTextWithParameter(
                auth.authCompleted,
              ),
              validator: phoneNumber.validator,
              focusNode: focus[0],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: phoneNumberNotifier.updatePhoneNumber,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              autofillHints: const <String>[
                AutofillHints.telephoneNumberNational,
              ],
              enabled: !auth.authCodeSent,
              textStyle: (auth.authCodeSent)
                  ? theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    )
                  : theme.primaryTextTheme.bodyMedium,
              actions: [
                SizedBox(
                  width: 80,
                  child: (auth.authCodeSent)
                      ? CustomTextButton(
                          "onboarding.signUp.changePhoneNumber",
                          onPressed: authNotifier.authStatusResetButton(
                              phoneNumberNotifier.reset,
                              focusNotifier.nextFocusNode),
                          minimumSize: const Size(80, 80),
                        )
                      : CustomTextButton(
                          "onboarding.signUp.sendCode",
                          onPressed: authNotifier.authSendButton(
                              phoneNumber.phoneNumber ?? "",
                              phoneNumber.dialCode,
                              focusNotifier.nextFocusNode),
                          minimumSize: const Size(80, 80),
                        ),
                ),
              ],
              onFieldSubmitted: () => focusNotifier.nextFocusNode(),
            ),

            // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
            if (auth.authCodeSent && !auth.authCompleted)
              CustomTextfieldContainer(
                fieldKey: "authCodeForPasswordReset",
                labelText: auth.labelText,
                actions: [
                  CustomTextButton(
                    "status.authcode.resend",
                    onPressed: authNotifier.authResendButton(
                      phoneNumber.phoneNumber ?? "",
                      phoneNumber.dialCode,
                      focusNotifier.nextFocusNode,
                    ),
                    minimumSize: const Size(80, 80),
                  ),
                  CustomTextButton(
                    (!auth.authCompleted)
                        ? "status.authcode.verify"
                        : "status.authcode.verified",
                    onPressed: authNotifier.authConfirmButton(
                      context,
                      focusNotifier.nextFocusNode,
                    ),
                    minimumSize: const Size(80, 80),
                  ),
                ],
                keyboardType: TextInputType.number,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                onChanged: authNotifier.updateAuthCode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                enabled: !auth.authCompleted,
                textStyle: (auth.authCompleted)
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      )
                    : theme.primaryTextTheme.bodyMedium,
                focusNode: focus[1],
                validator: auth.validator,
                onFieldSubmitted: () => focusNotifier.nextFocusNode(),
              )
            else
              Container(),

            // 아이디 입력 완료 시 비밀번호 입력창 표시
            if (auth.userUid != null && auth.authCompleted)
              CustomTextfieldContainer(
                fieldKey: "passwordForPasswordReset",
                prefixIcon: const Icon(
                  CupertinoIcons.lock_fill,
                  size: 24,
                ),
                labelText: password.labelText,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const <String>[AutofillHints.newPassword],
                onChanged: passwordNotifier.updatePassword,
                inputFormatters: [
                  // 소문자, 대문자, 숫자, 특수문자만 입력 가능
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9!@#$%^&*()]')),
                  // 최대 30자까지 입력 가능
                  LengthLimitingTextInputFormatter(30),
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focus[2],
                validator: password.validator,
                obscureText: !password.isPasswordVisible,
                actions: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: IconButton(
                      onPressed: passwordNotifier.updateVisiblePassword,
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(80, 80),
                      ),
                      icon: (password.isPasswordVisible)
                          ? const Icon(
                              CupertinoIcons.eye_fill,
                              size: 24,
                              semanticLabel:
                                  "accessibility.hidePasswordFieldButton",
                            )
                          : const Icon(
                              CupertinoIcons.eye_slash_fill,
                              size: 24,
                              semanticLabel:
                                  "accessibility.showPasswordFieldButton",
                            ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: BottomFloatingButton.centerDocked,
      floatingActionButton: BottomFloatingButton.build(
        context,
        ref,
        (auth.userUid == null || !password.isPasswordAvailable)
            ? null
            : () async {
                if (auth.userUid == null || !password.isPasswordAvailable) {
                  return;
                }

                final userUID = auth.userUid as String;
                final userPassword = password.userPassword as String;

                final result =
                    await UserService.resetPassword(userUID, userPassword, ref);

                if (context.mounted) {
                  if (result) {
                    ToastMessageService.nativeSnackbar(
                        "onboarding.signIn.resetPassword.success", context);
                    context.go('/onboarding/signin');
                  } else {
                    ToastMessageService.nativeSnackbar(
                        "onboarding.signIn.resetPassword.error", context);
                  }
                }
              },
        "onboarding.signIn.resetPassword.done",
      ),
    );
  }
}