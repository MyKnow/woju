import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_text.dart';

class UserWithdrawalPage extends ConsumerWidget {
  const UserWithdrawalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          '회원 탈퇴',
          isTitle: true,
        ),
      ),
    );
  }
}
