import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Troque pelo IP da sua máquina se testar no celular físico
  // No emulador Android use: http://10.0.2.2:5000
  // No navegador (Flutter Web) use: http://localhost:5000
  static const String baseUrl = kIsWeb
      ? 'http://localhost:5000/api'
      : 'http://10.0.2.2:5000/api';

  // Token JWT salvo em memória
  static String? _token;

  static void setToken(String token) => _token = token;
  static void clearToken() => _token = null;
  static String? get token => _token;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ── GET ────────────────────────────────────────────────────────────────────
  static Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ── POST ───────────────────────────────────────────────────────────────────
  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ── PUT ────────────────────────────────────────────────────────────────────
  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────
  static Future<dynamic> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ── Handler ────────────────────────────────────────────────────────────────
  static dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['message'] ?? 'Erro desconhecido.';
      throw Exception(message);
    }
  }
}
