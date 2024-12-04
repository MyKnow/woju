import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/bottom_floating_button.dart';
import 'package:woju/theme/widget/custom_text.dart';

class CustomScaffold extends ConsumerWidget {
  final String title;
  final Widget? appBarLeading;
  final Widget? drawer;
  final List<Widget>? appBarActions;
  final Widget? body;
  final VoidCallback? floatingActionButtonCallback;
  final String? floatingActionButtonText;
  final Widget? floatingActionButtonChild;
  final Widget? bottomNavigationBar;
  final bool? disableSafeArea;

  const CustomScaffold({
    super.key,
    required this.title,
    this.drawer,
    this.appBarLeading,
    this.appBarActions,
    this.body,
    this.floatingActionButtonCallback,
    this.floatingActionButtonChild,
    this.floatingActionButtonText,
    this.bottomNavigationBar,
    this.disableSafeArea,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarLeading,
        title: CustomText(
          title,
          isTitle: true,
        ),
        centerTitle: appBarActions?.isEmpty,
        actions: appBarActions,
      ),
      body: disableSafeArea == true
          ? body ?? Container()
          : SafeArea(
              bottom: false,
              child: body ?? Container(),
            ),
      drawer: drawer,
      floatingActionButtonLocation: (floatingActionButtonText != null ||
              floatingActionButtonCallback != null ||
              floatingActionButtonChild != null)
          ? BottomFloatingButton.location
          : null,
      floatingActionButton: BottomFloatingButton.build(
        context,
        ref,
        floatingActionButtonCallback,
        floatingActionButtonText,
        child: floatingActionButtonChild,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
