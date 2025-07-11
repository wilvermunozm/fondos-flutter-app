import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/core/errors/app_error.dart';
import 'package:amaris_fondos_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:amaris_fondos_flutter/features/auth/data/models/auth_model.dart';

// Generar mocks con @GenerateNiceMocks para reducir la estrictez en las pruebas
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'auth_repository_test.mocks.dart';

void main() {
  late AuthRepository repository;
  late MockClient mockClient;
  
  const baseUrl = 'http://test-api.com/api';
  const username = 'testuser';
  const password = 'password123';
  
  setUp(() {
    mockClient = MockClient();
    repository = AuthRepository(
      baseUrl: baseUrl,
      client: mockClient,
    );
  });
  
  group('login', () {
    final authJson = {
      'userId': 'user123',
      'token': 'test_token',
      'username': 'testuser'
    };
    
    test('should return AuthModel when http call is successful', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(json.encode(authJson), 200));
      
      // Act
      final result = await repository.login(username, password);
      
      // Assert
      expect(result, isA<AuthModel>());
      expect(result.userId, 'user123');
      expect(result.token, 'test_token');
      expect(result.username, 'testuser');
    });
    
    test('should throw ServerError when http call fails with 401', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"message": "Invalid credentials"}', 401));
      
      // Act & Assert
      await expectLater(
        () => repository.login(username, password),
        throwsA(isA<ServerError>())
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ));
    });
    
    test('should throw ServerError when http call fails with other error', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Server error', 500));
      
      // Act & Assert
      await expectLater(
        () => repository.login(username, password),
        throwsA(isA<ServerError>())
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ));
    });
    
    test('should throw NetworkError when http call throws exception', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(Exception('Network error'));
      
      // Act & Assert
      await expectLater(
        () => repository.login(username, password),
        throwsA(isA<NetworkError>())
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ));
    });
  });
  
  // Nota: Si en el futuro se implementa un método logout, se pueden añadir pruebas aquí
}
