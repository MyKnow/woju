import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/onboarding/id_state_notifier.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class UserIdChangePage extends ConsumerWidget {
  const UserIdChangePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userID = ref.watch(userIDStateProvider);
    final userIDNotifier = ref.watch(userIDStateProvider.notifier);
    final theme = Theme.of(context);

    return CustomScaffold(
      title: 'home.userProfile.userIDChange.title',
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextfieldContainer(
              fieldKey: 'change_user_id',
              headerText: 'home.userProfile.userIDChange.newUserID',
              prefixIcon: const Icon(Icons.person),
              initialValue: userID.userID,
              labelText: userID.labelTextForEditing,
              keyboardType: TextInputType.text,
              autofillHints: const <String>[AutofillHints.username],
              onChanged: userIDNotifier.onChangeUserID,
              inputFormatters: userID.inputFormatters,
              validator: userID.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !userID.isIDAvailable,
              textStyle: (userID.isIDAvailable)
                  ? theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    )
                  : theme.primaryTextTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButtonText:
          "home.userProfile.userIDChange.changeUserIDButton",
      floatingActionButtonCallback:
          userIDNotifier.onClickCompleteChangeUserID(context),
    );
  }
}
