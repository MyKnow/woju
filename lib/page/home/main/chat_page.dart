import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/provider/home/chat/chat_page_state_notifier.dart';

import 'package:woju/service/debug_service.dart';
import 'package:woju/theme/widget/custom_text.dart';

class ChatingPage extends ConsumerStatefulWidget {
  const ChatingPage({super.key});

  @override
  ConsumerState<ChatingPage> createState() => ChatingPageState();
}

class ChatingPageState extends ConsumerState<ChatingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        printd('ChatingPage initState');
        ref.read(chatPageStateProvider.notifier).getMyChatRoomList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatPageState = ref.watch(chatPageStateProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chatPageState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : (chatPageState.chatDisplays.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatPageState.chatDisplays.length,
                      itemBuilder: (context, index) {
                        final chat = chatPageState.chatDisplays[index];
                        return ListTile(
                          title: Text(chat.lastMessage.content),
                          subtitle: Text(
                              chat.users.map((e) => e.userNickName).join(', ')),
                        );
                      },
                    )
                  : const Center(
                      child: CustomText(
                      'chatPage.emptyChatroom',
                    )),
        ],
      ),
    );
  }
}
