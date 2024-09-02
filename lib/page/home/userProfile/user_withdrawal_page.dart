import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';

class UserWithdrawalPage extends ConsumerWidget {
  const UserWithdrawalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomScaffold(
      title: '회원 탈퇴',
    );
  }
}
