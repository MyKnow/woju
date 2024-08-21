import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static String baseUrl = dotenv.env['API_URL'] ?? '';

  static Uri getApiUrl(String path) {
    return Uri.parse(baseUrl + path);
  }

  static Future<http.Response> post(
      String url, Map<String, dynamic> body) async {
    final response = await http.post(
      getApiUrl(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    // connection failed 대비

    return response;
  }

  static Future<http.Response> get(String url) async {
    final response = await http.get(
      getApiUrl(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }
}
