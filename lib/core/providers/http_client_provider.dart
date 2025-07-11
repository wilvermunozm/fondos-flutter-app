import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SafeHttpClient extends http.BaseClient {
  final http.Client _inner;
  
  SafeHttpClient() : _inner = http.Client();
  
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.remove('followRedirects');
    
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    
    return _inner.send(request);
  }
  
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      
      headers?.forEach((key, value) {
        request.headers.add(key, value);
      });
      request.headers.add('Accept', 'application/json');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return http.Response(
        responseBody,
        response.statusCode,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
    } catch (e) {
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }
  
  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(url);
      
      headers?.forEach((key, value) {
        request.headers.add(key, value);
      });
      request.headers.add('Accept', 'application/json');
      request.headers.add('Content-Type', 'application/json; charset=utf-8');
      
      if (body != null) {
        final String bodyStr = body is String ? body : json.encode(body);
        request.write(bodyStr);
      }
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      return http.Response(
        responseBody,
        response.statusCode,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      );
    } catch (e) {
      throw Exception('Error en la solicitud HTTP POST: $e');
    }
  }
  
  @override
  void close() {
    _inner.close();
    super.close();
  }
}

final httpClientProvider = Provider<http.Client>((ref) {
  return SafeHttpClient();
});
