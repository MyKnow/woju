import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/provider/app_state_notifier.dart';
import 'package:woju/theme/widget/custom_text.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp(
      home: OnBoardingSlider(
        pageBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        finishButtonText: 'onboarding.startWithPhoneNumber'.tr(),
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onFinish: () {
          ref.read(appStateProvider.notifier).pushRouteSignUpPage(context);
        },
        skipTextButton: const CustomText(
          'onboarding.skip',
          isColorful: true,
          isBold: true,
        ),
        skipIcon: Icon(CupertinoIcons.arrow_right,
            semanticLabel: "onboarding.skip".tr()),
        trailing: const CustomText(
          'onboarding.signIn.title',
          isColorful: true,
          isBold: true,
        ),
        trailingFunction: () {
          context.push("/onboarding/signin");
        },
        background: [
          // Image.asset('assets/slide_1.png'),
          // Image.asset('assets/slide_2.png'),

          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.red,
          ),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                  child: Icon(
                    // 물물교환 아이콘
                    CupertinoIcons.arrow_2_squarepath,
                    size: 200,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                CustomText('onboarding.description.1'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                  child: Icon(
                    // 새로운 인연 아이콘
                    CupertinoIcons.person_2_square_stack,
                    size: 200,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const CustomText('onboarding.description.2'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                  child: Icon(
                    // 고가의 물건 아이콘
                    CupertinoIcons.money_dollar_circle,
                    size: 200,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const CustomText('onboarding.description.3'),
              ],
            ),
          ),
        ],
        controllerColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
