import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:woju/provider/onboarding/profile_image_state_notifier.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ProfileImageWidget extends ConsumerWidget {
  final bool hasShadow;
  final bool isEditable;
  final double radius;
  final Uint8List? image;
  final void Function()? onImageSelectedForDefault;
  final void Function()? onImageSelectedForGallery;
  final void Function()? onImageSelectedForCamera;

  const ProfileImageWidget({
    super.key,
    required this.image,
    this.radius = 100,
    this.hasShadow = true,
    this.isEditable = true,
    this.onImageSelectedForDefault,
    this.onImageSelectedForGallery,
    this.onImageSelectedForCamera,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Neumorphic(
          style: NeumorphicStyle(
            boxShape: const NeumorphicBoxShape.circle(),
            depth: 10,
            intensity: 0.7,
            shadowDarkColor: Colors.grey[700]?.withOpacity(0.9),
            shadowLightColor: Colors.grey[300]?.withOpacity(0.7),
          ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(100),
          //   boxShadow: [
          //     if (hasShadow)
          //       BoxShadow(
          //         color: theme.shadowColor,
          //         blurRadius: 15,
          //         offset: const Offset(0, 3),
          //       ),
          //   ],
          // ),
          child: InkWell(
            onTap: (isEditable)
                ? () {
                    showMaterialModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => imageBottomModalSheet(
                        context: context,
                        ref: ref,
                        onImageSelectedForDefault: onImageSelectedForDefault,
                        onImageSelectedForGallery: onImageSelectedForGallery,
                        onImageSelectedForCamera: onImageSelectedForCamera,
                      ),
                    );
                  }
                : null,
            borderRadius: BorderRadius.circular(100),
            excludeFromSemantics: true,
            child: CircleAvatar(
              foregroundColor: theme.primaryColor,
              backgroundColor: theme.cardColor,
              radius: radius,
              child: (image == null)
                  ? Icon(
                      CupertinoIcons.person_crop_circle,
                      size: radius,
                      semanticLabel:
                          "onboarding.signUp.detail.profileImage.default",
                    )
                  : // 이미지가 있을 경우 원형 이미지로 표시
                  CircleAvatar(
                      radius: radius,
                      backgroundImage: MemoryImage(image as Uint8List),
                    ),
            ),
          ),
        ),
        if (isEditable)
          InkWell(
            onTap: (isEditable)
                ? () {
                    showMaterialModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => imageBottomModalSheet(
                        context: context,
                        ref: ref,
                        onImageSelectedForDefault: onImageSelectedForDefault,
                        onImageSelectedForGallery: onImageSelectedForGallery,
                        onImageSelectedForCamera: onImageSelectedForCamera,
                      ),
                    );
                  }
                : null,
            borderRadius: BorderRadius.circular(radius),
            excludeFromSemantics: true,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: theme.cardTheme.surfaceTintColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.primaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                CupertinoIcons.camera,
                color: theme.primaryColor,
                size: radius / 3,
              ),
            ),
          ),
      ],
    );
  }

  Widget imageBottomModalSheet({
    required BuildContext context,
    required WidgetRef ref,
    Color? backgroundColor,
    void Function()? onImageSelectedForDefault,
    void Function()? onImageSelectedForGallery,
    void Function()? onImageSelectedForCamera,
  }) {
    final theme = Theme.of(context);
    final imageNotifier = ref.read(profileImageStateProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        border: Border.merge(
          Border(
            top: BorderSide(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
          const Border(
            bottom: BorderSide.none,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: onImageSelectedForDefault ??
                () async {
                  await imageNotifier.pickImage(null, context);
                },
            child: const ListTile(
              title: CustomText(
                "onboarding.signUp.detail.profileImage.default",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: theme.shadowColor,
          ),
          InkWell(
            onTap: onImageSelectedForGallery ??
                () async {
                  await imageNotifier.pickImage(true, context);
                },
            child: const ListTile(
              title: CustomText(
                "onboarding.signUp.detail.profileImage.fromGallery",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: theme.shadowColor,
          ),
          InkWell(
            onTap: onImageSelectedForCamera ??
                () async {
                  await imageNotifier.pickImage(false, context);
                },
            child: const ListTile(
              title: CustomText(
                "onboarding.signUp.detail.profileImage.fromCamera",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
