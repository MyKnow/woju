import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class SignupPolicyPage extends ConsumerWidget {
  final String type;

  const SignupPolicyPage({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNotifier = ref.watch(signUpStateProvider.notifier);
    return CustomScaffold(
      title: "onboarding.signUp.${type}Agreement.page.appBarTitle",
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 24,
            ),
            FutureBuilder(
              future: signUpNotifier.getPolicyContentMethod(context, type),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.data == null) {
                    return const CustomText('불러오기 실패');
                  }

                  final data = snapshot.data as Map<String, String>;

                  final version = data['version'] as String;
                  final content = data['content'] as String;

                  return Column(
                    children: [
                      CustomText(
                          "onboarding.signUp.${type}Agreement.page.title",
                          isBold: true,
                          namedArgs: {'version': version},
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium
                                    ?.color,
                              )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: MarkdownBody(
                          data: content,
                          // selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                signUpNotifier.onClickAgreePolicyButton(
                    context, type, "version");
              },
              child: CustomText(
                "onboarding.signUp.${type}Agreement.page.agreeButton",
                isWhite: true,
              ),
            ),
            const SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
