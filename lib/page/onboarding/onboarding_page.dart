import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp(
      home: OnBoardingSlider(
        pageBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        headerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        finishButtonText: 'onboarding.start'.tr(),
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onFinish: () {
          // TODO : Go to Auth Page
        },
        skipTextButton: const Text('onboarding.skip').tr(),
        trailing: const Icon(CupertinoIcons.info_circle),
        trailingFunction: () {
          // TODO : Help Page
        },
        background: [
          // Image.asset('assets/slide_1.png'),
          // Image.asset('assets/slide_2.png'),
          const Icon(
            CupertinoIcons.person_2,
            size: 100,
            color: Colors.black,
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
                const SizedBox(
                  height: 480,
                ),
                const Text('onboarding.description.1').tr(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 480,
                ),
                const Text('onboarding.description.2').tr(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 480,
                ),
                const Text('onboarding.description.3').tr(),
              ],
            ),
          ),
        ],
        controllerColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
