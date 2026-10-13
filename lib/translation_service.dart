import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslationService {
  static Future<String> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    try {
      final url = Uri.parse(
        'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=autodetect|$targetLanguage',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['responseData']['translatedText'] ?? text;
      }
      return text;
    } catch (e) {
      return text;
    }
  }
}
