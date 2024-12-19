import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:woju/service/debug_service.dart';

class HttpService {
  static String userAPIUrl = dotenv.env['USER_API_URL'] ?? '';
  static String itemAPIUrl = dotenv.env['ITEM_API_URL'] ?? '';
  static String chatAPIUrl = dotenv.env['CHAT_API_URL'] ?? '';

  static Uri getUserAPIUrl(String path) {
    return Uri.parse(userAPIUrl + path);
  }

  static Uri getItemAPIUrl(String path) {
    return Uri.parse(itemAPIUrl + path);
  }

  static Uri getChatAPIUrl(String path) {
    return Uri.parse(chatAPIUrl + path);
  }

  /// # [userPost]
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  /// - [Map]<[String], [dynamic]> - [body] : API Header
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [header] : API Header
  ///
  /// ### Returns
  /// - [Future]<[http.Response]> : API Response
  ///
  static Future<http.Response> userPost(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    final userUri = getUserAPIUrl(url);

    return await _post(userUri, body, header);
  }

  /// # [userGet]
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [header] : API Header
  /// - [Map]<[String], [dynamic]>? - [body] : API Body
  ///
  /// ### Returns
  /// - [Future]<[http.Response]> : API Response
  ///
  static Future<http.Response> userGet(
    String url, {
    Map<String, String>? header,
    Map<String, dynamic>? body,
  }) async {
    final userUri = getUserAPIUrl(url);

    return await _get(
      userUri,
      header,
      body,
    );
  }

  /// # [itemPost]
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  /// - [Map]<[String], [dynamic]> - [body] : API Body
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [header] : API Header
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]> : API Response
  ///
  static Future<http.Response> itemPost(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    final itemUri = getItemAPIUrl(url);

    return await _post(itemUri, body, header);
  }

  /// # [itemGet]
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [header] : API Header
  /// - [Map]<[String], [dynamic]>? - [query] : API Query
  ///
  /// ### Returns
  /// - [Future]<[http.Response]> : API Response
  ///
  static Future<http.Response> itemGet(String url,
      {Map<String, String>? header, Map<String, dynamic>? query}) async {
    final itemUri = getItemAPIUrl(url);
    printd("itemGet query: $query");

    return await _get(itemUri, header, query);
  }

  /// # [itemDelete]
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  ///
  /// ### Parameters
  /// - [Map]<[String], [String]> - [header] : API Header
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [dynamic]>? - [body] : API Body
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]> : API Response
  ///
  static Future<http.Response> itemDelete(
      String url, Map<String, String> header,
      {Map<String, dynamic>? body}) async {
    final itemUri = getItemAPIUrl(url);

    return await _delete(itemUri, header, body: body);
  }

  /// # [chatPost]
  /// - 채팅 API POST 요청
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  /// - [Map]<[String], [dynamic]> - [body] : API Body
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [header] : API Header
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]> : API Response
  ///
  static Future<http.Response> chatPost(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) async {
    final chatUri = getChatAPIUrl(url);

    return await _post(chatUri, body, header);
  }

  /// # [chatGet]
  /// - 채팅 API GET 요청
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [header] : API Header
  /// - [Map]<[String], [dynamic]>? - [query] : API Query
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]> : API Response
  ///
  static Future<http.Response> chatGet(String url,
      {Map<String, String>? header, Map<String, dynamic>? query}) async {
    final chatUri = getChatAPIUrl(url);

    return await _get(chatUri, header, query);
  }

  /// # [chatDelete]
  /// - 채팅 API DELETE 요청
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  /// - [Map]<[String], [String]> - [header] : API Header
  ///
  /// ### Parameters
  /// - [Map]<[String], [dynamic]>? - [body] : API Body
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]> : API Response
  ///
  static Future<http.Response> chatDelete(
      String url, Map<String, String> header,
      {Map<String, dynamic>? body}) async {
    final chatUri = getChatAPIUrl(url);

    return await _delete(chatUri, header, body: body);
  }

  /// # [_get]
  ///
  /// ### Parameters
  /// - [Uri] - [uri] : API URI
  /// - [Map]<[String], [dynamic]>] - [header] : API Header
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [String]>? - [query] : API Body
  ///
  /// ### Returns
  /// - [Future]<[http.Response]>] : API Response
  ///
  static Future<http.Response> _get(
      Uri url, Map<String, String>? header, Map<String, dynamic>? query) async {
    final response = await http.get(
      url.replace(queryParameters: query),
      headers: header ??
          <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
    );

    return response;
  }

  /// # [_post]
  ///
  /// ### Parameters
  /// - [String] - [uri] : API URI
  /// - [Map]<[String], [dynamic]> - [body] : API Body
  /// - [Map]<[String], [String]>? - [header] : API Header
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]> : API Response
  ///
  static Future<http.Response> _post(
      Uri uri, Map<String, dynamic> body, Map<String, String>? header) async {
    try {
      final response = await http.post(
        uri,
        headers: header ??
            <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      printd("HttpService.post error: $e");
      return http.Response('{"error": "$e"}', 500);
    }
  }

  /// # [_delete]
  ///
  /// ### Parameters
  /// - [Uri] - [uri] : API URI
  /// - [Map]<[String], [String]>? - [header] : API Header
  ///
  /// ### Parameters (Optional)
  /// - [Map]<[String], [dynamic]>? - [body] : API Body
  ///
  /// ### Returns
  /// - [Future]<[http.Response]> : API Response
  ///
  static Future<http.Response> _delete(Uri uri, Map<String, String>? header,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await http.delete(
        uri,
        headers: header ??
            <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      printd("HttpService.delete error: $e");
      return http.Response('{"error": "$e"}', 500);
    }
  }

  static String failureReason(String code) {
    return "error.failureReason.$code";
  }
}
