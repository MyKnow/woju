import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/model/user/user_detail_info_model.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/service/api/chat_service.dart';
import 'package:woju/service/debug_service.dart';

class Message {
  final String id;
  final String userUUID;
  final String content;
  final List<String> seenUserUUIDs;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.userUUID,
    required this.content,
    required this.seenUserUUIDs,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      userUUID: json['userUUID'],
      content: json['content'],
      seenUserUUIDs: json['seenUserUUIDs'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ChatDisplay {
  final String chatroomUUID;
  final Map<String, String> relationItemUUID;
  final List<UserDisplay> users;
  final Message lastMessage;
  final DateTime createdAt;

  ChatDisplay({
    required this.chatroomUUID,
    required this.relationItemUUID,
    required this.users,
    required this.lastMessage,
    required this.createdAt,
  });

  factory ChatDisplay.fromJson(Map<String, dynamic> json) {
    return ChatDisplay(
      chatroomUUID: json['chatroomUUID'],
      relationItemUUID: json['relationItemUUID'],
      users:
          (json['users'] as List).map((e) => UserDisplay.fromJson(e)).toList(),
      lastMessage: Message.fromJson(json['lastMessage']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Chat {
  final String chatroomUUID;
  final Map<String, String> relationItemUUIDs;
  final List<UserDisplay> users;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.chatroomUUID,
    required this.relationItemUUIDs,
    required this.users,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatroomUUID: json['chatroomUUID'],
      relationItemUUIDs: json['relationItemUUIDs'],
      users:
          (json['users'] as List).map((e) => UserDisplay.fromJson(e)).toList(),
      messages:
          (json['messages'] as List).map((e) => Message.fromJson(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ChatPageState {
  final List<ChatDisplay> chatDisplays;
  final bool isLoading;

  ChatPageState({
    required this.chatDisplays,
    required this.isLoading,
  });

  ChatPageState copyWith({
    List<ChatDisplay>? chatDisplays,
    bool? isLoading,
  }) {
    return ChatPageState(
      chatDisplays: chatDisplays ?? this.chatDisplays,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ChatPageState.initial() {
    return ChatPageState(
      chatDisplays: [],
      isLoading: false,
    );
  }
}

final chatPageStateProvider =
    StateNotifierProvider<ChatPageStateNotifier, ChatPageState>(
  (ref) => ChatPageStateNotifier(ref),
);

class ChatPageStateNotifier extends StateNotifier<ChatPageState> {
  late Ref ref;
  ChatPageStateNotifier(this.ref) : super(ChatPageState.initial());

  void updateChatDisplays(List<ChatDisplay> chatDisplays) {
    state = state.copyWith(chatDisplays: chatDisplays);
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  ChatPageState get getState => state;
}

extension ChatDisplayExtension on ChatPageStateNotifier {
  Future<void> getMyChatRoomList() async {
    final userToken = ref.read(userDetailInfoStateProvider)?.userToken ?? '';
    updateIsLoading(true);
    final chatDisplays = await ChatService.getMyChatRoomList(userToken);
    printd("chatDisplays: $chatDisplays");
    updateChatDisplays(chatDisplays);
    updateIsLoading(false);
  }
}
