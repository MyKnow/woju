import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';

import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/profile_image_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userDetailInfoStateProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(width: double.infinity),
          CustomText(
            "User UUID: ${userDetail?.userUUID}",
            isLocalize: false,
          ),
          CustomText(
            "User ID: ${userDetail?.userID}",
            isLocalize: false,
          ),
          CustomText(
            "User Nickname: ${userDetail?.userNickName}",
            isLocalize: false,
          ),
          CustomText(
            "User Phone: ${userDetail?.dialCode} ${userDetail?.userPhoneNumber} (${userDetail?.isoCode})",
            isLocalize: false,
          ),
          CustomText(
            "User UID: ${userDetail?.userUID}",
            isLocalize: false,
          ),
          CustomText(
            "User Gender: ${userDetail?.userGender}",
            isLocalize: false,
          ),
          ProfileImageWidget(
            isEditable: false,
            image: userDetail?.profileImage,
          ),
          CustomText(
            "User BirthDate: ${userDetail?.userBirthDate}",
            isLocalize: false,
          ),
          CustomText(
            "User TermsAgreeVersion: ${userDetail?.termsVersion}",
            isLocalize: false,
          ),
          CustomText(
            "User PrivacyPolicyAgreeVersion: ${userDetail?.privacyVersion}",
            isLocalize: false,
          ),
          CustomText(
            "User Token: ${userDetail?.userToken}",
            isLocalize: false,
          ),
          CustomText(
            "Favorite Category Map: ${userDetail?.userFavoriteCategoriesMap}",
            isLocalize: false,
          ),
        ],
      ),
    );
  }
}
