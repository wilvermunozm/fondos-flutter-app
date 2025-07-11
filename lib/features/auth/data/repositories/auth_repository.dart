import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/logging/logger.dart' as app_logger;
import '../../../../core/providers/http_client_provider.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final String baseUrl;
  final http.Client client;

  AuthRepository({
    required this.baseUrl,
    required this.client,
  });
  
  static final provider = Provider<AuthRepository>((ref) {
    return AuthRepository(
      baseUrl: ApiConstants.baseUrl,
      client: ref.watch(httpClientProvider),
    );
  });

  Future<AuthModel> login(String username, String password) async {
    try {
      app_logger.AppLogger.info('Iniciando login para usuario: $username');
      
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      
      app_logger.AppLogger.info('Respuesta de login recibida: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          app_logger.AppLogger.info('Login exitoso para usuario: $username');
          return AuthModel.fromJson(jsonData);
        } catch (e) {
          app_logger.AppLogger.error('Error al decodificar respuesta JSON: $e');
          app_logger.AppLogger.error('Cuerpo de la respuesta: ${response.body}');
          throw FormatException('Error al procesar la respuesta del servidor');
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw ServerError(errorData['error'] ?? 'Error de autenticación');
        } catch (e) {
          app_logger.AppLogger.error('Error al decodificar respuesta de error: $e');
          app_logger.AppLogger.error('Cuerpo de la respuesta de error: ${response.body}');
          throw ServerError('Error de autenticación: ${response.statusCode}');
        }
      }
    } catch (e) {
      app_logger.AppLogger.error('Error en login: $e');
      if (e is AppError) {
        rethrow;
      }
      throw NetworkError('Error de conexión al servidor: ${e.toString()}');
    }
  }
}
