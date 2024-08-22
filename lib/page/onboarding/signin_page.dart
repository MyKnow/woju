import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_id_model.dart';
import 'package:woju/model/user/user_password_model.dart';
import 'package:woju/model/user/user_phone_model.dart';
import 'package:woju/provider/onboarding/sign_in_state_notifier.dart';
import 'package:woju/widget/bottom_floating_button.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(signInStateProvider);
    final signInNotifier = ref.read(signInStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("onboarding.signIn.title").tr(),
        actions: [
          // 로그인 방법 변경
          IconButton(
            icon: Icon(Icons.person,
                semanticLabel: (signIn.loginWithPhoneNumber)
                    ? "onboarding.signIn.signInWithID".tr()
                    : "onboarding.signIn.signInWithPhoneNumber".tr()),
            onPressed: () {
              signInNotifier.changeLoginButton();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (signIn.loginWithPhoneNumber)
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
                    child: SizedBox(
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          prefix: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CountryCodePicker(
                              onChanged: (countryCode) {
                                signInNotifier.countryCodeOnChange(
                                  countryCode.dialCode,
                                  countryCode.code,
                                );
                              },
                              initialSelection: 'KR',
                              favorite: const ['KR', 'US'],
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
                            ),
                          ),
                          labelText: signIn.userPhoneModel.labelText(false),
                        ),
                        validator: (value) {
                          final result =
                              UserPhoneModel.phoneNumberValidation(value)
                                  .toMessage;

                          if (result != null) {
                            return result.tr();
                          }

                          return null;
                        },
                        // focusNode: focus[0],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          signInNotifier.phoneNumberOnChange(value);
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
                        initialValue: signIn.userPhoneModel.phoneNumber,
                      ),
                    ),
                  );
                },
              )
            else
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: signIn.userIDModel.labelText(false).tr(),
                    prefixIcon: const Icon(
                      CupertinoIcons.person_fill,
                      size: 24,
                    ),
                  ),
                  validator: (value) {
                    final result = UserIDModel.validateID(value);

                    if (result != UserIDStatus.userIDValid) {
                      return result.toMessage.tr();
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: signInNotifier.userIDOnChange,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    // 소문자, 대문자, 숫자만 입력 가능
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    // 최대 20자까지 입력 가능
                    LengthLimitingTextInputFormatter(20),
                  ],
                  initialValue: signIn.userIDModel.userID,
                ),
              ),

            // 비밀번호 입력
            Column(
              children: [
                const SizedBox(height: 20),
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
                            labelText:
                                (signIn.userPasswordModel.isPasswordAvailable)
                                    ? "onboarding.signUp.passwordAvailable".tr()
                                    : "onboarding.signUp.password".tr(),
                          ),
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
                          validator: (value) {
                            final result =
                                UserPasswordModel.validatePassword(value);

                            if (result != PasswordStatus.valid) {
                              return result.toMessage?.tr();
                            }

                            return null;
                          },
                          obscureText:
                              !signIn.userPasswordModel.isPasswordVisible,
                          initialValue: signIn.userPasswordModel.userPassword,
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
                                      "accessibility.hidePasswordFieldButton"
                                          .tr())
                              : Icon(CupertinoIcons.eye_slash_fill,
                                  semanticLabel:
                                      "accessibility.showPasswordFieldButton"
                                          .tr()),
                        ),
                      ),
                    ],
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
        signInNotifier.loginButtonOnClick(context),
        "onboarding.signIn.signIn",
      ),
    );
  }
}
