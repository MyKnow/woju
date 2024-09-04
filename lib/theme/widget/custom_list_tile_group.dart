import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_container_decoration.dart';
import 'package:woju/theme/widget/custom_text.dart';

class CustomListTileGroup extends ConsumerWidget {
  final String? headerText;
  final List<Widget> children;
  const CustomListTileGroup(
      {super.key, this.headerText, required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 32, bottom: 15, top: 16),
          child: CustomText(
            headerText as String,
            isBold: true,
            isColorful: true,
          ),
        ),
        CustomDecorationContainer(
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++)
                Column(
                  children: [
                    children[i],
                    if (i != children.length - 1)
                      Divider(
                        height: 1,
                        color: Theme.of(context).shadowColor,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
