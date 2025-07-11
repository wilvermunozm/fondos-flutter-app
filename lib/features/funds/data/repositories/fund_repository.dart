import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/providers/http_client_provider.dart';

import '../../domain/models/fund.dart';
import '../mappers/fund_mapper.dart';

class FundRepository {
  final String baseUrl;
  final http.Client client;

  FundRepository({
    required this.baseUrl,
    required this.client,
  });
  

  static final provider = Provider<FundRepository>((ref) {
    return FundRepository(
      baseUrl: ApiConstants.baseUrl,
      client: ref.watch(httpClientProvider),
    );
  });

  Future<List<Fund>> getFunds() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/funds'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return FundMapper.fromJsonList(jsonList);
      } else {
        throw NetworkError(
          'Failed to load funds',
          statusCode: response.statusCode,
          cause: response.body,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching funds', e, stackTrace);
      
      // Capturar específicamente el error de tipo String/bool
      if (e.toString().contains("'String' is not a subtype of type 'bool'")) {
        throw NetworkError(
          'Error de configuración HTTP',
          cause: 'Problema con la configuración de CORS o parámetros HTTP',
        );
      }
      
      // Lanzar el error apropiado cuando falla la conexión al servidor
      if (e is NetworkError) {
        throw e;
      }
      throw NetworkError(
        'Failed to connect to server',
        cause: e,
      );
      /*
      if (e is NetworkError) {
        rethrow;
      }
      throw NetworkError(
        'Failed to connect to the server',
        cause: e,
        stackTrace: stackTrace,
      );
      */
    }
  }

  Future<Fund> getFundById(String id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/funds/$id'));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return FundMapper.fromJson(json);
      } else if (response.statusCode == 404) {
        throw NetworkError(
          'Fund not found with id: $id',
          statusCode: response.statusCode,
          cause: response.body,
        );
      } else {
        throw NetworkError(
          'Failed to load fund details',
          statusCode: response.statusCode,
          cause: response.body,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error fetching fund by id: $id', e, stackTrace);
      if (e is NetworkError) {
        rethrow;
      }
      throw NetworkError(
        'Failed to connect to the server',
        cause: e,
        stackTrace: stackTrace,
      );
    }
  }
}
