import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_text.dart';

class UserIdChangePage extends ConsumerWidget {
  const UserIdChangePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          '아이디 변경',
          isTitle: true,
        ),
      ),
    );
  }
}
