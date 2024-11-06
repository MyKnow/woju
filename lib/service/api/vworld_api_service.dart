import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:woju/model/item/location_model.dart';
import 'package:woju/service/debug_service.dart';

class VworldApiService {
  static const String apiUrl =
      "https://api.vworld.kr/req/address?service=address&request=getAddress&key=";
  static String apiKey = dotenv.env['VWORLD_API_KEY'] ?? '';

  static Future<Location?> geoCording(
    double latitude,
    double longitude,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$apiUrl$apiKey&version=2.0&point=$longitude,$latitude&type=ROAD&simple=true',
      ),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);
    if (data['response']['status'] != 'OK') {
      printd("Vworld API Error: ${data['response']['status']}");
      return null;
    }

    final result = data['response']['result'][0];
    final zipCode = result['zipcode'];
    final fullAddress = result['text'];

    if (zipCode == null || fullAddress == null) {
      return null;
    }

    // printd("Vworld API ZipCode: $zipCode");
    // printd("Vworld API FullAddress: $fullAddress");

    String? simpleAddress;
    final structure = result['structure'];
    final levels = [
      'detail',
      'level4A',
      'level4L',
      'level3',
      'level2',
      'level1'
    ];

    for (var level in levels) {
      if (structure[level]?.isNotEmpty ?? false) {
        simpleAddress = structure[level];
        break;
      }
    }

    // printd("Vworld API SimpleAddress: $simpleAddress");

    final zipCodeForInt = int.tryParse(zipCode);
    if (simpleAddress == null || zipCodeForInt == null) {
      return null;
    } else {
      return Location(
        simpleName: simpleAddress,
        fullAddress: fullAddress,
        latitude: latitude,
        longitude: longitude,
        zipCode: zipCodeForInt,
      );
    }
  }
}
