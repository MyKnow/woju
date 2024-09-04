import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/theme_state_notififer.dart';
import 'package:woju/theme/widget/custom_country_picker_widget.dart';

import 'package:woju/theme/widget/custom_list_tile_group.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeStateNotifierProvider);
    final themeNotifier = ref.watch(themeStateNotifierProvider.notifier);

    return CustomScaffold(
      title: "home.setting.title",
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
              width: double.infinity,
            ),
            CustomListTileGroup(
              headerText: "home.setting.theme.title",
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  leading: Icon(
                    CupertinoIcons.paintbrush_fill,
                    color: theme.primaryColor,
                  ),
                  title: const CustomText(
                    "home.setting.theme.appearance.title",
                  ),
                  trailing: AnimatedToggleSwitch.rolling(
                    values: const [0, 1, 2],
                    current: themeState.index,
                    iconBuilder: (value, selected) {
                      if (selected) {
                        return Icon(
                          value == 0
                              ? Icons.brightness_auto_rounded
                              : value == 1
                                  ? CupertinoIcons.brightness_solid
                                  : CupertinoIcons.moon_fill,
                          color: Colors.white,
                          semanticLabel:
                              "home.setting.theme.appearance.button_$value"
                                  .tr(),
                        );
                      }
                      return Icon(
                        value == 0
                            ? Icons.brightness_auto_rounded
                            : value == 1
                                ? CupertinoIcons.brightness_solid
                                : CupertinoIcons.moon_fill,
                        color: theme.disabledColor,
                      );
                    },
                    onTap: (index) async {
                      if (index.tapped?.index == null) {
                        return;
                      }
                      final indexInt = index.tapped?.index as int;
                      themeNotifier.updateTheme(indexInt);
                    },
                    height: 48,
                    spacing: 8,
                    borderWidth: 0,
                    style: const ToggleStyle(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  leading: Icon(
                    Icons.translate_rounded,
                    color: theme.primaryColor,
                  ),
                  title: const CustomText(
                    "home.setting.theme.language.title",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomCountryPickerWidget(
                        onChanged: (countryCode) async {
                          if (countryCode.code == context.locale.countryCode) {
                            return;
                          }

                          if (countryCode.code == 'KR') {
                            await context.setLocale(const Locale('ko', 'KR'));
                          } else {
                            await context.setLocale(const Locale('en', 'US'));
                          }
                        },
                        countryFilter: const [
                          'KR',
                          'US',
                        ],
                        builder: (country) {
                          return SizedBox(
                            height: 48,
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomText(
                                  country?.name as String,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.disabledColor,
                                  ),
                                  isLocalize: false,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: theme.textTheme.labelLarge?.fontSize,
                                    color: theme.disabledColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        hideSearch: true,
                        dialogSize: const Size(300, 75 * 2),
                        showOnlyCountry: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
