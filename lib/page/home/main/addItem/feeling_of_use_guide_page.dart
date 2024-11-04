import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/item/item_model.dart';
import 'package:woju/provider/home/add_item_page_state_notifier.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';

class FeelingOfUseGuidePage extends ConsumerWidget {
  const FeelingOfUseGuidePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateNotifier = ref.watch(addItemPageStateProvider.notifier);

    return CustomScaffold(
        title: 'addItem.feelingOfUse.guidePage.title',
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // 설명
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: CustomText(
                  'addItem.feelingOfUse.guidePage.description',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
              ),

              // Feeling Of Use Listview
              ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: stateNotifier.onTapFeelingOfUse(
                          index.toDouble(), context),
                      onLongPress: stateNotifier.onLongPressFeelingOfUse(
                          index.toDouble(), context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.disabledColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.memory(
                                stateNotifier.getState.itemModel
                                    .feelingOfUseExampleImage(index.toDouble()),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Text
                          const SizedBox(
                            width: 16,
                          ),

                          // Text Column
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      ItemModel.initial()
                                          .feelingOfUseIcon(index.toDouble()),
                                      color: theme.cardTheme.surfaceTintColor,
                                      size: theme
                                          .textTheme.headlineLarge?.fontSize,
                                      applyTextScaling: true,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        stateNotifier.getState.itemModel
                                            .printItemFeelingOfUseToString(
                                          index.toDouble(),
                                        ),
                                        style: theme.textTheme.headlineLarge
                                            ?.copyWith(
                                          color:
                                              theme.cardTheme.surfaceTintColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomText(
                                  stateNotifier.getState.itemModel
                                      .printItemFeelingOfUseDescriptionToString(
                                    index.toDouble(),
                                  ),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.disabledColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
