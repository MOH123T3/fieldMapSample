// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:http/http.dart';

class ApiPath {
  static String address = 'India';
  static String realTimeUrl =
      'https://weatherapi-com.p.rapidapi.com/current.json?q=53.1%2C-0.13';

  static String forecastUrl =
      'https://weatherapi-com.p.rapidapi.com/forecast.json?q=$address&days=3';

  static String timeSZoneUrl =
      'https://weatherapi-com.p.rapidapi.com/timezone.json?q=%3CREQUIRED%3E';

  static String historyWetherUrl =
      'https://weatherapi-com.p.rapidapi.com/history.json?q=London&dt=%3CREQUIRED%3E&lang=en';
}

class ResponseClass {
  static Future<Response> getApi(String uri) async {
    var url = Uri.parse(uri);

    var response = await get(url, headers: {
      'X-RapidAPI-Key': '10f5ff5d9fmshb883bb833d99b66p1cc0ddjsn85d8623c2345',
      'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com'
    });

    return response;
  }
}
