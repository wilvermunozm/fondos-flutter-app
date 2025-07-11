import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/core/errors/app_error.dart';
import 'package:amaris_fondos_flutter/features/funds/data/repositories/fund_repository.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/models/fund.dart';

// Generar mocks con @GenerateNiceMocks para reducir la estrictez en las pruebas
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'fund_repository_test.mocks.dart';

void main() {
  late FundRepository repository;
  late MockClient mockClient;
  
  const baseUrl = 'http://test-api.com/api';
  
  setUp(() {
    mockClient = MockClient();
    repository = FundRepository(
      baseUrl: baseUrl,
      client: mockClient,
    );
  });
  
  group('getFunds', () {
    final fundsJson = [
      {
        'id': 'fund1',
        'name': 'Test Fund 1',
        'description': 'Description 1',
        'category': 'Category 1',
        'risk': 'low',
        'annualReturn': 5.5,
        'minInvestment': 1000.0,
        'imageUrl': 'http://example.com/image1.jpg',
        'manager': 'Manager 1',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'type': 'equity',
        'currency': 'USD',
        'managementFee': 1.2,
        'performance': 6.7,
        'returnRates': {
          'oneYear': 5.5,
          'threeYear': 15.5,
          'fiveYear': 25.5,
          'tenYear': 50.5,
          'ytd': 3.2
        }
      },
      {
        'id': 'fund2',
        'name': 'Test Fund 2',
        'description': 'Description 2',
        'category': 'Category 2',
        'risk': 'medium',
        'annualReturn': 7.2,
        'minInvestment': 2000.0,
        'imageUrl': 'http://example.com/image2.jpg',
        'manager': 'Manager 2',
        'createdAt': '2023-02-01T00:00:00.000Z',
        'type': 'bond',
        'currency': 'EUR',
        'managementFee': 1.5,
        'performance': 7.8,
        'returnRates': {
          'oneYear': 7.2,
          'threeYear': 18.5,
          'fiveYear': 28.5,
          'tenYear': 55.5,
          'ytd': 4.2
        }
      }
    ];
    
    test('should return list of funds when http call is successful', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('$baseUrl/funds'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(json.encode(fundsJson), 200));
      
      // Act
      final result = await repository.getFunds();
      
      // Assert
      expect(result, isA<List<Fund>>());
      expect(result.length, 2);
      expect(result[0].id, 'fund1');
      expect(result[0].name, 'Test Fund 1');
      expect(result[1].id, 'fund2');
      expect(result[1].name, 'Test Fund 2');
    });
    
    test('should throw NetworkError when http call fails', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('$baseUrl/funds'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 500));
      
      // Act & Assert
      await expectLater(
        () => repository.getFunds(),
        throwsA(isA<NetworkError>())
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.get(
        Uri.parse('$baseUrl/funds'),
        headers: anyNamed('headers'),
      ));
    });
    
    test('should throw NetworkError when client throws exception', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('$baseUrl/funds'),
        headers: anyNamed('headers'),
      )).thenThrow(Exception('Network error'));
      
      // Act & Assert
      await expectLater(
        () => repository.getFunds(),
        throwsA(isA<NetworkError>())
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.get(
        Uri.parse('$baseUrl/funds'),
        headers: anyNamed('headers'),
      ));
    });
  });
  
  group('getFundById', () {
    const fundId = 'fund1';
    final fundJson = {
      'id': fundId,
      'name': 'Test Fund 1',
      'description': 'Description 1',
      'category': 'Category 1',
      'risk': 'low',
      'annualReturn': 5.5,
      'minInvestment': 1000.0,
      'imageUrl': 'http://example.com/image1.jpg',
      'manager': 'Manager 1',
      'createdAt': '2023-01-01T00:00:00.000Z',
      'type': 'equity',
      'currency': 'USD',
      'managementFee': 1.2,
      'performance': 6.7,
      'returnRates': {
        'oneYear': 5.5,
        'threeYear': 15.5,
        'fiveYear': 25.5,
        'tenYear': 50.5,
        'ytd': 3.2
      }
    };
    
    test('should return a fund when http call is successful', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('$baseUrl/funds/$fundId'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(json.encode(fundJson), 200));
      
      // Act
      final result = await repository.getFundById(fundId);
      
      // Assert
      expect(result, isA<Fund>());
      expect(result.id, fundId);
      expect(result.name, 'Test Fund 1');
      expect(result.description, 'Description 1');
      expect(result.risk, 'low');
      expect(result.annualReturn, 5.5);
    });
    
    test('should throw NetworkError when http call fails with 404', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('$baseUrl/funds/$fundId'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not found', 404));
      
      // Act & Assert
      await expectLater(
        () => repository.getFundById(fundId),
        throwsA(predicate((e) => e is NetworkError && e.statusCode == 404))
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.get(
        Uri.parse('$baseUrl/funds/$fundId'),
        headers: anyNamed('headers'),
      ));
    });
    
    test('should throw NetworkError when http call fails with other error', () async {
      // Arrange
      when(mockClient.get(
        Uri.parse('$baseUrl/funds/$fundId'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Server error', 500));
      
      // Act & Assert
      await expectLater(
        () => repository.getFundById(fundId),
        throwsA(predicate((e) => e is NetworkError && e.statusCode == 500))
      );
      
      // Verificar que se llamó al método correcto
      verify(mockClient.get(
        Uri.parse('$baseUrl/funds/$fundId'),
        headers: anyNamed('headers'),
      ));
    });
  });
}
