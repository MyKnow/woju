import 'dart:convert';

import 'package:woju/provider/home/chat/chat_page_state_notifier.dart';
import 'package:woju/service/api/http_service.dart';
import 'package:woju/service/debug_service.dart';

class ChatService {
  /// ### [getMyChatRoomList]
  /// - 나의 채팅방 목록을 가져옵니다.
  ///
  /// #### Parameters
  /// - [String] - [userToken] : 사용자 토큰
  ///
  /// #### Returns
  /// - [Future]<[ChatDisplay]> - 성공 여부
  ///
  static Future<List<ChatDisplay>> getMyChatRoomList(String userToken) async {
    final response = await HttpService.chatGet(
      '/chat/get-my-chat-rooms',
      header: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonDecodeResponse = jsonDecode(response.body);
      printd("getMyChatRoomList: $jsonDecodeResponse");
      final chatListJson = jsonDecodeResponse['chatrooms'];

      if (chatListJson == null) {
        return [];
      }

      printd("getMyChatRoomList: $chatListJson");
      final chatList = (chatListJson as List).map((e) {
        var result = ChatDisplay.fromJson(e);
        return result;
      }).toList();
      return chatList;
    } else {
      printd('getMyChatRoomList error: ${response.statusCode}');
      return [];
    }
  }
}
