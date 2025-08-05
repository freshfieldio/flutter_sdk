import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/update.dart';

class FreshfieldService {
  final String baseUrl;
  String? _apiKey;

  FreshfieldService({
    this.baseUrl = 'https://pb.freshfield.io/api/widget',
  });

  void init(String apiKey) {
    _apiKey = apiKey;
  }

  Future<String> getIconSvg(String icon) async {
    final [prefix, name] = icon.split(':');
    try {
      final response = await http.get(
        Uri.parse('https://api.iconify.design/$prefix.json?icons=$name'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['icons'] != null && data['icons'][name] != null) {
          final width = data['width'] ?? 24;
          final height = data['height'] ?? 24;
          final svg =
              '<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 $width $height" fill="currentColor">${data['icons'][name]['body']}</svg>';
          return svg;
        }
      }
      throw Exception('Icon $icon not found');
    } catch (error) {
      return '';
    }
  }

  Future<List<Update>> getUpdates({
    int limit = 10,
    int offset = 0,
  }) async {
    if (_apiKey == null) {
      throw Exception('API key not set. Call init() first.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/updates?limit=$limit&offset=$offset'),
      headers: {
        'X-Widget-Key': _apiKey!,
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final updates = jsonList.map((json) => Update.fromJson(json)).toList();

      // Fetch SVG icons for all features
      for (var update in updates) {
        for (var feature in update.features) {
          if (feature.icon != null) {
            feature.icon = await getIconSvg(feature.icon!);
          }
        }
      }

      return updates;
    } else {
      throw Exception('Failed to load updates: ${response.statusCode} - ${response.body}');
    }
  }
}
