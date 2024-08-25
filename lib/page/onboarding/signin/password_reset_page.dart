// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:woju/provider/onboarding/auth_state_notififer.dart';
// import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';
// import 'package:woju/provider/theme_state_notififer.dart';
// import 'package:woju/service/api/user_service.dart';
// import 'package:woju/theme/widget/bottom_floating_button.dart';
// import 'package:woju/theme/widget/custom_textfield_container.dart';

// class PasswordResetPage extends ConsumerStatefulWidget {
//   const PasswordResetPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     return PasswordResetPageState();
//   }
// }

// class PasswordResetPageState extends ConsumerState<PasswordResetPage> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = ref.watch(themeStateNotifierProvider.notifier).theme;
//     final auth = ref.watch(authStateProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const CustomText("onboarding.signIn.resetPassword.title").tr(),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             // 전화번호 입력
//             CustomTextfieldContainer(
//               prefix: CountryCodePicker(
//                 onChanged:
//                     ref.read(signUpStateProvider.notifier).onCountryCodeChanged,
//                 initialSelection: 'KR',
//                 favorite: const ['KR', 'US'],
//                 showCountryOnly: false,
//                 showOnlyCountryWhenClosed: false,
//                 alignLeft: false,
//                 padding: EdgeInsets.zero,
//                 searchDecoration: InputDecoration(
//                   labelText: "onboarding.signUp.searchCountry".tr(),
//                 ),
//                 boxDecoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 builder: (country) {
//                   if (country == null) {
//                     return const SizedBox.shrink();
//                   }
//                   return Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         country.flagUri ?? '',
//                         package: 'country_code_picker',
//                         width: 32,
//                       ),
//                       const SizedBox(width: 8),
//                       CustomText(
//                         country.dialCode ?? '',
//                         style: (auth.authCodeSent)
//                             ? theme.textTheme.bodyMedium!.copyWith(
//                                 color: Colors.grey,
//                               )
//                             : theme.primaryTextTheme.bodyMedium,
//                       ),
//                       // const SizedBox(width: 16),
//                     ],
//                   );
//                 },
//                 closeIcon: const Icon(CupertinoIcons.clear),
//                 enabled: !auth.authCompleted,
//               ),
//               labelText: signUp.userPhoneModel.labelTextWithParameter(
//                 auth.authCompleted,
//               ),
//               validator: signUp.userPhoneModel.validator,
//               focusNode: focus[0],
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               onChanged: (value) {
//                 ref
//                     .read(signUpStateProvider.notifier)
//                     .phoneNumberOnChange(value);
//               },
//               keyboardType: TextInputType.number,
//               textInputAction: TextInputAction.done,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 LengthLimitingTextInputFormatter(15),
//               ],
//               autofillHints: const <String>[
//                 AutofillHints.telephoneNumberNational,
//               ],
//               enabled: !auth.authCodeSent,
//               textStyle: (auth.authCodeSent)
//                   ? theme.textTheme.bodyMedium!.copyWith(
//                       color: Colors.grey,
//                     )
//                   : theme.primaryTextTheme.bodyMedium,
//               actions: [
//                 SizedBox(
//                   width: 80,
//                   child: (auth.authCodeSent)
//                       ? TextButton(
//                           onPressed: () {
//                             ref
//                                 .read(signUpStateProvider.notifier)
//                                 .changePhoneNumber();
//                           },
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             disabledForegroundColor: theme.disabledColor,
//                             minimumSize: const Size(80, 80),
//                           ),
//                           child: const CustomText(
//                             "onboarding.signUp.changePhoneNumber",
//                             textAlign: TextAlign.center,
//                           ).tr(),
//                         )
//                       : TextButton(
//                           onPressed: ref
//                               .read(signUpStateProvider.notifier)
//                               .sendAuthCodeButton(),
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             disabledForegroundColor: theme.disabledColor,
//                             minimumSize: const Size(80, 80),
//                           ),
//                           child: const CustomText(
//                             "onboarding.signUp.sendCode",
//                             textAlign: TextAlign.center,
//                           ).tr(),
//                         ),
//                 ),
//               ],
//             ),

//             // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
//             if (auth.authCodeSent &&
//                 !auth.authCompleted)
//               CustomTextfieldContainer(
//                 labelText: auth.labelText,
//                 actions: [
//                   TextButton(
//                     onPressed: signUpNotifier.resendAuthCodeButton(),
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       disabledForegroundColor: theme.disabledColor,
//                       minimumSize: const Size(80, 80),
//                     ),
//                     child: const CustomText("status.authcode.resend").tr(),
//                   ),
//                   TextButton(
//                     onPressed: signUpNotifier.verifyAuthCodeButton(),
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       disabledForegroundColor: theme.disabledColor,
//                       minimumSize: const Size(80, 80),
//                     ),
//                     child: (!auth.authCompleted)
//                         ? const CustomText("status.authcode.verify").tr()
//                         : const CustomText("status.authcode.verified").tr(),
//                   ),
//                 ],
//                 keyboardType: TextInputType.number,
//                 autofillHints: const <String>[AutofillHints.oneTimeCode],
//                 onChanged: (value) {
//                   ref
//                       .read(signUpStateProvider.notifier)
//                       .updateUserAuthModel(authCode: value);
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                   LengthLimitingTextInputFormatter(6),
//                 ],
//                 enabled: !auth.authCompleted,
//                 textStyle: (auth.authCompleted)
//                     ? theme.textTheme.bodyMedium!.copyWith(
//                         color: Colors.grey,
//                       )
//                     : theme.primaryTextTheme.bodyMedium,
//                 focusNode: focus[1],
//                 validator: auth.validator,
//               )
//             else
//               Container(),

//             // 아이디 입력 완료 시 비밀번호 입력창 표시
//             if (auth.userUid != null &&
//                 auth.authCompleted)
//               CustomTextfieldContainer(
//                 prefixIcon: const Icon(
//                   CupertinoIcons.lock_fill,
//                   size: 24,
//                 ),
//                 labelText: signUp.userPasswordModel.labelText,
//                 keyboardType: TextInputType.visiblePassword,
//                 autofillHints: const <String>[AutofillHints.newPassword],
//                 onChanged:
//                     ref.read(signUpStateProvider.notifier).passwordOnChange,
//                 inputFormatters: [
//                   // 소문자, 대문자, 숫자, 특수문자만 입력 가능
//                   FilteringTextInputFormatter.allow(
//                       RegExp(r'[a-zA-Z0-9!@#$%^&*()]')),
//                   // 최대 30자까지 입력 가능
//                   LengthLimitingTextInputFormatter(30),
//                 ],
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 focusNode: focus[2],
//                 validator: signUp.userPasswordModel.validator,
//                 obscureText: !signUp.userPasswordModel.isPasswordVisible,
//                 actions: [
//                   SizedBox(
//                     height: 80,
//                     width: 80,
//                     child: IconButton(
//                       onPressed: () {
//                         ref
//                             .read(signUpStateProvider.notifier)
//                             .changePasswordVisibilityButton();
//                       },
//                       style: IconButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         fixedSize: const Size(80, 80),
//                       ),
//                       icon: (signUp.userPasswordModel.isPasswordVisible)
//                           ? const Icon(
//                               CupertinoIcons.eye_fill,
//                               size: 24,
//                               semanticLabel:
//                                   "accessibility.hidePasswordFieldButton",
//                             )
//                           : const Icon(
//                               CupertinoIcons.eye_slash_fill,
//                               size: 24,
//                               semanticLabel:
//                                   "accessibility.showPasswordFieldButton",
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: BottomFloatingButton.centerDocked,
//       floatingActionButton: BottomFloatingButton.build(
//         context,
//         ref,
//         (auth.userUid == null ||
//                 signUp.userPasswordModel.userPassword == null)
//             ? null
//             : () async {
//                 if (auth.userUid == null ||
//                     signUp.userPasswordModel.userPassword == null) {
//                   return;
//                 }

//                 final userUID = auth.userUid as String;
//                 final userPassword =
//                     signUp.userPasswordModel.userPassword as String;

//                 final result =
//                     await UserService.resetPassword(userUID, userPassword, ref);

//                 if (context.mounted) {
//                   if (result) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: CustomText(
//                           "onboarding.signIn.resetPassword.success".tr(),
//                         ),
//                       ),
//                     );
//                     context.go('/onboarding/signin');
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: CustomText(
//                           "onboarding.signIn.resetPassword.error".tr(),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//               },
//         "onboarding.signIn.resetPassword.done",
//       ),
//     );
//   }
// }
