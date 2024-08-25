import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/theme/widget/custom_text.dart';

class RouterErrorPage extends ConsumerStatefulWidget {
  const RouterErrorPage({super.key});
  @override
  RouterErrorPageState createState() => RouterErrorPageState();
}

class RouterErrorPageState extends ConsumerState<RouterErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const CustomText('error.router.title', isTitle: true),
      ),
      body: PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            const CustomText('error.router.description'),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const CustomText('error.router.back'),
            ),
          ],
        ),
      ),
    );
  }
}
