import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:woju/service/debug_service.dart';

class HttpService {
  static String userAPIUrl = dotenv.env['USER_API_URL'] ?? '';
  static String itemAPIUrl = dotenv.env['ITEM_API_URL'] ?? '';

  static Uri getUserAPIUrl(String path) {
    return Uri.parse(userAPIUrl + path);
  }

  static Uri getItemAPIUrl(String path) {
    return Uri.parse(itemAPIUrl + path);
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
  ///
  /// ### Returns
  /// - [Future]<[http.Response]> : API Response
  ///
  static Future<http.Response> userGet(String url,
      {Map<String, String>? header}) async {
    final userUri = getUserAPIUrl(url);

    return await _get(userUri, header);
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
  ///
  /// ### Returns
  /// - [Future]<[http.Response]> : API Response
  ///
  static Future<http.Response> itemGet(String url,
      {Map<String, String>? header}) async {
    final itemUri = getItemAPIUrl(url);

    return await _get(itemUri, header);
  }

  /// # [itemDelete]
  ///
  /// ### Parameters
  /// - [String] - [url] : API URI
  ///
  /// ### Parameters
  /// - [Map]<[String], [String]> - [header] : API Header
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

  /// # [_get]
  ///
  /// ### Parameters
  /// - [Uri] - [uri] : API URI
  /// - [Map]<[String], [dynamic]>] - [body] : API Header
  ///
  /// ### Returns
  /// - [Future]<[http].[Response]>] : API Response
  ///
  static Future<http.Response> _get(
      Uri url, Map<String, String>? header) async {
    final response = await http.get(
      url,
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
