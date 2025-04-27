import 'package:dio/dio.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech/core/const/const.dart';
import 'package:tech/core/models/profession.dart';

class DioService {
  final String baseUrl;
  final String token;
  final Dio _dio;

  DioService({
    required this.baseUrl,
    required this.token,
  }) : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      connectTimeout: Duration(seconds: 10000),
      receiveTimeout: Duration(seconds: 10000),
    ),
  );

  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken'); // Récupérer le token
  }


  Future<dynamic> _handleError(dynamic error) async {
    if (error is DioError) {
      if (error.response != null) {
        print('Erreur dans la réponse de l\'API. Code de statut : ${error
            .response!.statusCode}');
        print('Réponse : ${error.response!.data}');
        throw Exception(
            'Erreur dans la réponse de l\'API. Code de statut : ${error
                .response!.statusCode}');
      } else {
        print('Erreur de connexion : ${error.message}');
        throw Exception('Erreur de connexion : ${error.message}');
      }
    } else {
      print('Une erreur inattendue s\'est produite : $error');
      throw Exception('Une erreur inattendue s\'est produite : $error');
    }
  }

  Future<dynamic> get({
    required String url
  }) async {
    try {
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(url);
      return response.data;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> getMany({
    required String url
  }) async {
    try {
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(url);
      return response.data.data;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.post(url, data: body);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Erreur lors de la requête POST. Code de statut : ${response
            .statusCode}');
        throw Exception(
            'Erreur lors de la requête POST. Code de statut : ${response
                .statusCode}');
      }
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> put({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.put(url, data: body);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Erreur lors de la requête PUT. Code de statut : ${response
            .statusCode}');
        throw Exception(
            'Erreur lors de la requête PUT. Code de statut : ${response
                .statusCode}');
      }
    } catch(error) {
        return _handleError(error);
    }
  }

  Future<dynamic> delete({required String url}) async {
    try {
      String? token = await _getToken(); // Récupérer le token

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.delete(url);
      return response.data;
    } catch (error) {
      return _handleError(error);
    }
  }

  Future<dynamic> signUp({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    return post(url: url, body: body);
  }

  Future<dynamic> logIn({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    return post(url: url, body: body);
  }

}