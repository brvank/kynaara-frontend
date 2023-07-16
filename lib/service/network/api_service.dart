import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kynaara_frontend/data/repositories/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ApiMethod { get, post, delete, put }

class ApiService {
  final String authorization = "Authorization";
  final String contentType = "Content-Type";
  final String applicationJson = "application/json; charset=utf-8";
  SharedPreferences? sharedPreferences;
  SessionManager sessionManager = SessionManager();

  //layer above the main network calls
  Future<http.Response> execute(String url, ApiMethod apiMethod,
      {String? body}) async {
    sharedPreferences ??= await SharedPreferences.getInstance();

    String token = sessionManager.getToken(sharedPreferences!);

    switch (apiMethod) {
      case ApiMethod.get:
        return _get(url, token: token);
      case ApiMethod.post:
        return _post(url, body, token: token);
      case ApiMethod.delete:
        return _delete(url, token: token);
      case ApiMethod.put:
        return _put(url, token: token);
    }
  }

  //get api
  Future<http.Response> _get(String url, {String? token}) async {
    return http.get(
      Uri.parse(url),
      headers: _getHeaders(token),
    );
  }

  //post api
  Future<http.Response> _post(String url, String? body, {String? token}) async {
    return http.post(Uri.parse(url), headers: _getHeaders(token), body: body);
  }

  //delete api
  Future<http.Response> _delete(String url,
      {String? token, String? body}) async {
    return http.delete(Uri.parse(url), headers: _getHeaders(token), body: body);
  }

  //put api
  Future<http.Response> _put(String url, {String? token, String? body}) async {
    return http.put(Uri.parse(url), headers: _getHeaders(token), body: body);
  }

  //common header function
  Map<String, String> _getHeaders(String? token) {
    Map<String, String> header = {};

    header[contentType] = applicationJson;
    if (token != null) {
      header[authorization] = token;
    }

    return header;
  }
}
