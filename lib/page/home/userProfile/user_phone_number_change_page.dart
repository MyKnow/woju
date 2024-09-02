import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';

class UserPhoneNumberChangePage extends ConsumerWidget {
  const UserPhoneNumberChangePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CustomScaffold(
      title: '전화번호 변경',
    );
  }
}
