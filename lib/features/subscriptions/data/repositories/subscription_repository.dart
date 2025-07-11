import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/logging/logger.dart' as app_logger;
import '../../../../core/providers/http_client_provider.dart';
import '../../../../core/services/local_storage_service.dart';

import '../../domain/models/subscription.dart';
import '../datasources/mock_subscription_data.dart';
import '../mappers/subscription_mapper.dart';

class SubscriptionRepository {
  final String baseUrl;
  final http.Client client;
  final bool useMockData;

  SubscriptionRepository({
    required this.baseUrl,
    required this.client,
    this.useMockData = false,
  });
  
  static final provider = Provider<SubscriptionRepository>((ref) {
    return SubscriptionRepository(
      baseUrl: ApiConstants.baseUrl,
      client: ref.watch(httpClientProvider),
    );
  });
  
  // Provider que siempre usa datos mock
  static final mockProvider = Provider<SubscriptionRepository>((ref) {
    return SubscriptionRepository(
      baseUrl: ApiConstants.baseUrl,
      client: ref.watch(httpClientProvider),
      useMockData: true,
    );
  });

  Future<List<Subscription>> getUserSubscriptions(String userId) async {
    try {
      final storageService = await LocalStorageService.getInstance();
      final List<String> savedIds = storageService.getSubscriptionIds();
      
      // Si useMockData es true, devolver datos mock directamente
      if (useMockData) {
        app_logger.AppLogger.info('Usando datos mock para las suscripciones (modo forzado)');
        final mockSubscriptions = MockSubscriptionData.getUserSubscriptions(userId);
        
        // Actualizar IDs en storage si es necesario
        if (savedIds.isEmpty && mockSubscriptions.isNotEmpty) {
          await storageService.saveSubscriptionIds(
            mockSubscriptions.map((sub) => sub.id).toList().cast<String>()
          );
        }
        
        return mockSubscriptions;
      }

      try {
        final httpClient = HttpClient();
        final uri = Uri.parse('$baseUrl/subscriptions?userId=$userId');
        
        app_logger.AppLogger.info('Solicitando suscripciones para usuario: $userId en $uri');
        
        final request = await httpClient.getUrl(uri);
        request.headers.add('Accept', 'application/json');
        request.headers.add('Content-Type', 'application/json');
        
        final httpResponse = await request.close();
        final responseBody = await httpResponse.transform(utf8.decoder).join();
        
        app_logger.AppLogger.info('Respuesta recibida con código: ${httpResponse.statusCode}');
        
        if (httpResponse.statusCode == 200) {
          final List<dynamic> jsonList = json.decode(responseBody);
          final subscriptions = SubscriptionMapper.fromJsonList(jsonList);
          
          if (savedIds.isEmpty && subscriptions.isNotEmpty) {
            await storageService.saveSubscriptionIds(
              subscriptions.map((sub) => sub.id).toList().cast<String>()
            );
          }
          
          return subscriptions;
        } else {
          throw NetworkError(
            'Failed to load subscriptions',
            statusCode: httpResponse.statusCode,
            cause: responseBody,
          );
        }
      } catch (e) {
        app_logger.AppLogger.error('Error en la conexión HTTP: $e');
        
        app_logger.AppLogger.info('Usando datos mock para las suscripciones (fallback)');
        final mockSubscriptions = MockSubscriptionData.getUserSubscriptions(userId);
        
        if (savedIds.isEmpty && mockSubscriptions.isNotEmpty) {
          await storageService.saveSubscriptionIds(
            mockSubscriptions.map((sub) => sub.id).toList().cast<String>()
          );
        }
        
        return mockSubscriptions;
      }
    } catch (e) {
      app_logger.AppLogger.error('Error general al obtener suscripciones: $e');
      throw UnexpectedError(message: 'Failed to get subscriptions', cause: e);
    }
  }
  
  Future<Subscription> subscribeToFund(String userId, String fundId, double amount) async {
    try {
      if (useMockData) {
        app_logger.AppLogger.info('Usando datos mock para crear suscripción (modo forzado)');
        
        String fundName = 'Fondo $fundId';
        
        final subscription = MockSubscriptionData.subscribeToFund(
          userId: userId,
          fundId: fundId,
          fundName: fundName,
          amount: amount,
        );
        
        final storageService = await LocalStorageService.getInstance();
        final List<String> savedIds = storageService.getSubscriptionIds();
        savedIds.add(subscription.id);
        await storageService.saveSubscriptionIds(savedIds);
        
        return subscription;
      }
      
      try {
        final httpClient = HttpClient();
        final uri = Uri.parse('$baseUrl/subscriptions');
        
        app_logger.AppLogger.info('Creando suscripción para usuario: $userId, fondo: $fundId');
        
        final request = await httpClient.postUrl(uri);
        request.headers.add('Accept', 'application/json');
        request.headers.add('Content-Type', 'application/json');
        
        final Map<String, dynamic> requestBody = {
          'userId': userId,
          'fundId': fundId,
          'amount': amount,
          'date': DateTime.now().toIso8601String(),
          'status': 'active',
        };
        
        final String jsonBody = json.encode(requestBody);
        request.write(jsonBody);
        
        final httpResponse = await request.close();
        final responseBody = await httpResponse.transform(utf8.decoder).join();
        
        app_logger.AppLogger.info('Respuesta recibida con código: ${httpResponse.statusCode}');
        
        if (httpResponse.statusCode == 201) {
          final subscription = SubscriptionMapper.fromJson(json.decode(responseBody));
          
          final storageService = await LocalStorageService.getInstance();
          final List<String> savedIds = storageService.getSubscriptionIds();
          savedIds.add(subscription.id);
          await storageService.saveSubscriptionIds(savedIds);
          
          return subscription;
        } else {
          throw NetworkError(
            'Failed to create subscription',
            statusCode: httpResponse.statusCode,
            cause: responseBody,
          );
        }
      } catch (e) {
        app_logger.AppLogger.error('Error en la conexión HTTP al crear suscripción: $e');
        
        app_logger.AppLogger.info('Usando datos mock para crear suscripción (fallback)');
        
        String fundName = 'Fondo $fundId';
        
        final subscription = MockSubscriptionData.subscribeToFund(
          userId: userId,
          fundId: fundId,
          fundName: fundName,
          amount: amount,
        );
        
        final storageService = await LocalStorageService.getInstance();
        final List<String> savedIds = storageService.getSubscriptionIds();
        savedIds.add(subscription.id);
        await storageService.saveSubscriptionIds(savedIds);
        
        return subscription;
      }
    } catch (e) {
      app_logger.AppLogger.error('Error general al crear suscripción: $e');
      throw UnexpectedError(message: 'Failed to create subscription', cause: e);
    }
  }
  
  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final storageService = await LocalStorageService.getInstance();
      final List<String> savedIds = storageService.getSubscriptionIds();
      savedIds.remove(subscriptionId);
      await storageService.saveSubscriptionIds(savedIds);
      
      if (useMockData) {
        app_logger.AppLogger.info('Usando datos mock para cancelar suscripción (modo forzado)');
        return MockSubscriptionData.cancelSubscription(subscriptionId);
      }
      
      try {
        final response = await client.delete(
          Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
        );

        if (response.statusCode == 200) {
          app_logger.AppLogger.info('Suscripción cancelada exitosamente en el servidor');
          return true;
        } else {
          app_logger.AppLogger.warning('Error al cancelar suscripción en el servidor, pero se eliminó localmente');
          return true;
        }
      } catch (e) {
        app_logger.AppLogger.warning('Error de conexión al cancelar suscripción, pero se eliminó localmente');
        app_logger.AppLogger.info('Usando datos mock para cancelar suscripción (fallback)');
        return MockSubscriptionData.cancelSubscription(subscriptionId);
      }
    } catch (e) {
      app_logger.AppLogger.error('Error en cancelSubscription: $e');
      throw UnexpectedError(message: 'Error inesperado al cancelar la suscripción', cause: e);
    }
  }
  

}
