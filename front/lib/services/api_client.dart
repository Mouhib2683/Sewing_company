import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';

/// Thrown whenever the backend responds with `success: false` (or the
/// request fails outright). Carries the human-readable message the backend
/// sent back, so UI code can show it directly.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Small wrapper around `package:http` for talking to the Express backend.
/// Every backend response is shaped like `{ success, message?, data? }` —
/// this class unwraps that consistently and throws [ApiException] on
/// `success: false` so callers only ever deal with the `data` payload.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<dynamic> post(String path, Map<String, dynamic> body, {String? token}) async {
    final response = await _client.post(
      _uri(path),
      headers: _headers(token),
      body: jsonEncode(body),
    );
    return _parse(response);
  }

  Future<dynamic> get(String path, {String? token}) async {
    final response = await _client.get(
      _uri(path),
      headers: _headers(token),
    );
    return _parse(response);
  }

  dynamic _parse(http.Response response) {
    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Unexpected server response (${response.statusCode})');
    }

    if (json['success'] != true) {
      throw ApiException(json['message']?.toString() ?? 'Something went wrong');
    }

    return json['data'];
  }
}
