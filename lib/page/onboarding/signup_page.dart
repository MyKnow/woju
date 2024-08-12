import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:woju/model/app_state_model.dart';

import 'package:woju/provider/onboarding_state_notifier.dart';
import 'package:woju/service/debug_service.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("onboarding.signUp.title").tr(),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  printd(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  printd(value);
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
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(onboardingStateProvider.notifier)
                    .pushRouteSignInPage(context);
              },
              child: const Text("onboarding.signIn").tr(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(onboardingStateProvider.notifier)
                    .update(OnboardingState.initialState.copyWith(
                      isAlreadyOnboarded: true,
                      gotoSignIn: true,
                    ));
              },
              child: const Text("onboarding.signUp.login").tr(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(onboardingStateProvider.notifier).delete();
              },
              child: const Text("onboarding.delete").tr(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO : 유저 정보 입력 페이지로 이동
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text('다음'),
        ),
      ),
    );
  }
}
