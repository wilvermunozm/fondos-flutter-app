import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/core/errors/app_error.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/models/subscription.dart';
import 'package:amaris_fondos_flutter/core/services/local_storage_service.dart';

@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<HttpClient>(),
  MockSpec<LocalStorageService>(),
  MockSpec<HttpClientRequest>(),
  MockSpec<HttpClientResponse>(),
  MockSpec<HttpHeaders>()
])
import 'subscription_repository_test.mocks.dart';

void main() {
  late SubscriptionRepository repository;
  late MockClient mockClient;
  late MockHttpClient mockHttpClient;
  late MockLocalStorageService mockStorageService;
  
  const baseUrl = 'http://test-api.com/api';
  const userId = 'user123';
  const fundId = 'fund123';
  const subscriptionId = 'subscription123';
  
  setUp(() {
    mockClient = MockClient();
    mockHttpClient = MockHttpClient();
    mockStorageService = MockLocalStorageService();
    
    when(mockStorageService.getSubscriptionIds()).thenReturn([]);
    
    repository = SubscriptionRepository(
      baseUrl: baseUrl,
      client: mockClient,
      useMockData: false,
    );
  });
  
  group('getUserSubscriptions', () {
    const subscriptionId = 'subscription123';
    final subscriptionsJson = [
      {
        'id': subscriptionId,
        'userId': userId,
        'fundId': fundId,
        'amount': 1000.0,
        'date': '2023-01-01T00:00:00.000Z',
        'status': 'active',
        'fundName': 'Test Fund'
      }
    ];
    
    late MockHttpClientRequest mockRequest;
    late MockHttpClientResponse mockResponse;
    late MockHttpHeaders mockHeaders;
    
    setUp(() {
      mockRequest = MockHttpClientRequest();
      mockResponse = MockHttpClientResponse();
      mockHeaders = MockHttpHeaders();
      
      when(mockHttpClient.getUrl(any)).thenAnswer((_) async => mockRequest);
      when(mockRequest.headers).thenReturn(mockHeaders);
      when(mockRequest.close()).thenAnswer((_) async => mockResponse);
      
      when(mockHeaders.add(any, any)).thenReturn(null);
    });
    
    test('should return list of subscriptions when http call is successful', () async {
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.transform(any)).thenAnswer((_) => Stream.value(utf8.encode(json.encode(subscriptionsJson))));
      
      final result = await repository.getUserSubscriptions(userId);
      
      expect(result, isA<List<Subscription>>());
      expect(result.length, 1);
      expect(result[0].id, subscriptionId);
      expect(result[0].fundId, fundId);
      expect(result[0].amount, 1000.0);
      
      verify(mockHttpClient.getUrl(any));
      verify(mockRequest.close());
    });
    
    test('should throw NetworkError when http call fails', () async {
      when(mockResponse.statusCode).thenReturn(404);
      when(mockResponse.transform(any)).thenAnswer((_) => Stream.value(utf8.encode('Error')));
      
      expect(
        () => repository.getUserSubscriptions(userId),
        throwsA(isA<NetworkError>()),
      );
    });
    
    test('should return mock data when useMockData is true', () async {
      final mockRepository = SubscriptionRepository(
        baseUrl: baseUrl,
        client: mockClient,
        useMockData: true,
      );
      
      final result = await mockRepository.getUserSubscriptions(userId);
      
      expect(result, isA<List<Subscription>>());
      expect(result.isNotEmpty, true);
      verifyNever(mockHttpClient.getUrl(any));
    });
  });
  
  group('subscribeToFund', () {
    final subscriptionJson = {
      'id': 'subscription123',
      'userId': 'user123',
      'fundId': 'fund123',
      'amount': 1000.0,
      'date': '2023-01-01',
      'status': 'active',
      'fundName': 'Test Fund'
    };
    
    late MockHttpClientRequest mockRequest;
    late MockHttpClientResponse mockResponse;
    late MockHttpHeaders mockHeaders;
    
    setUp(() {
      mockRequest = MockHttpClientRequest();
      mockResponse = MockHttpClientResponse();
      mockHeaders = MockHttpHeaders();
      
      when(mockHttpClient.postUrl(any)).thenAnswer((_) async => mockRequest);
      when(mockRequest.headers).thenReturn(mockHeaders);
      when(mockRequest.close()).thenAnswer((_) async => mockResponse);
      
      when(mockHeaders.add(any, any)).thenReturn(null);
    });
    
    test('should return subscription when http call is successful', () async {
      when(mockResponse.statusCode).thenReturn(201);
      when(mockResponse.transform(any)).thenAnswer((_) => Stream.value(utf8.encode(json.encode(subscriptionJson))));
      
      final result = await repository.subscribeToFund(userId, fundId, 1000.0);
      
      expect(result, isA<Subscription>());
      expect(result.id, subscriptionId);
      expect(result.fundId, fundId);
      expect(result.amount, 1000.0);
    });
    
    test('should throw NetworkError when http call fails', () async {
      when(mockResponse.statusCode).thenReturn(400);
      when(mockResponse.transform(any)).thenAnswer((_) => Stream.value(utf8.encode('Error')));
      
      try {
        await repository.subscribeToFund(userId, fundId, 1000.0);
        fail('Expected NetworkError was not thrown');
      } catch (e) {
        expect(e, isA<NetworkError>());
      }
    });
  });
  
  group('cancelSubscription', () {
    test('should return true when cancellation is successful', () async {
      when(mockClient.delete(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
      )).thenAnswer((_) async => http.Response('', 200));
      
      final result = await repository.cancelSubscription(subscriptionId);
      
      expect(result, isTrue);
    });
    
    test('should return true even when http call fails but local deletion succeeds', () async {
      when(mockClient.delete(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
      )).thenAnswer((_) async => http.Response('Error', 404));
      
      final result = await repository.cancelSubscription(subscriptionId);
      
      expect(result, isTrue);
    });
    
    test('should throw UnexpectedError when an unexpected error occurs', () async {
      when(mockClient.delete(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
      )).thenThrow(Exception('Unexpected error'));
      
      try {
        await repository.cancelSubscription(subscriptionId);
        fail('Expected UnexpectedError was not thrown');
      } catch (e) {
        expect(e, isA<UnexpectedError>());
      }
    });
  });
}


