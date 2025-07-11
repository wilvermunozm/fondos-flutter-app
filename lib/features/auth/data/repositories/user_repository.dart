import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/logging/logger.dart' as app_logger;
import '../../../../core/providers/http_client_provider.dart';
import '../models/user_model.dart';

class UserRepository {
  final String baseUrl;
  final http.Client client;

  UserRepository({
    required this.baseUrl,
    required this.client,
  });
  

  static final provider = Provider<UserRepository>((ref) {
    return UserRepository(
      baseUrl: ApiConstants.baseUrl,
      client: ref.watch(httpClientProvider),
    );
  });

  Future<UserModel> getUserById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundError('Usuario no encontrado en el servidor');
      } else {
        throw ServerError('Error al obtener datos del usuario');
      }
    } catch (e) {
      app_logger.AppLogger.error('Error en getUserById: $e');
      
      // Capturar específicamente el error de tipo String/bool
      if (e.toString().contains("'String' is not a subtype of type 'bool'")) {
        throw NetworkError(
          'Error de configuración HTTP',
          cause: 'Problema con la configuración de CORS o parámetros HTTP',
        );
      }
      
      if (e is AppError) {
        throw e;
      }

      throw NetworkError(
        'Failed to connect to server when getting user data',
        cause: e,
      );
    }
  }

  Future<Map<String, dynamic>> subscribeToFund(String userId, String fundId, double amount) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/subscriptions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'fundId': fundId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 201) {
        final subscription = json.decode(response.body);

        final userResponse = await client.get(Uri.parse('$baseUrl/users/$userId'));
        if (userResponse.statusCode == 200) {
          final user = json.decode(userResponse.body);
          return {
            'user': UserModel.fromJson(user),
            'subscription': subscription,
          };
        } else {
          return {
            'subscription': subscription,
          };
        }
      } else {
        final errorData = json.decode(response.body);
        throw ServerError(errorData['error'] ?? 'Error al suscribirse al fondo');
      }
    } catch (e) {
      app_logger.AppLogger.error('Error en subscribeToFund: $e');
      if (e is AppError) {
        rethrow;
      }
      throw NetworkError('Error de conexión al servidor');
    }
  }

  Future<Map<String, dynamic>> unsubscribeFromFund(String userId, String subscriptionId) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final subscription = json.decode(response.body);

        final userResponse = await client.get(Uri.parse('$baseUrl/users/$userId'));
        if (userResponse.statusCode == 200) {
          final user = json.decode(userResponse.body);
          return {
            'user': UserModel.fromJson(user),
            'subscription': subscription,
          };
        } else {
          return {
            'subscription': subscription,
          };
        }
      } else {
        final errorData = json.decode(response.body);
        throw ServerError(errorData['error'] ?? 'Error al cancelar la suscripción');
      }
    } catch (e) {
      app_logger.AppLogger.error('Error en unsubscribeFromFund: $e');
      if (e is AppError) {
        rethrow;
      }
      throw NetworkError('Error de conexión al servidor');
    }
  }
}
