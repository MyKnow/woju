import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:woju/service/debug_service.dart';

class HttpService {
  static String baseUrl = dotenv.env['API_URL'] ?? '';

  static Uri getApiUrl(String path) {
    return Uri.parse(baseUrl + path);
  }

  static Future<Map<String, dynamic>> post(
      String url, Map<String, dynamic> body) async {
    final response = await http.post(
      getApiUrl(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      printd("statusCode: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(
      getApiUrl(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      printd("statusCode: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
    return jsonDecode(response.body);
  }
}
