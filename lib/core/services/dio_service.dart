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


  Future<dynamic> handleError(dynamic error) async {
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
      return handleError(error);
    }
  }

  Future<dynamic> getAvailable({
    required String url
  }) async {
    try {
    /*  String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }*/

      //_dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(url);
      return response.data;
    } catch (error) {
      return handleError(error);
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
      _dio.options.headers['Accept'] = 'application/json';

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
      return handleError(error);
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
        return handleError(error);
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
      return handleError(error);
    }
  }

  Future<dynamic> postFormData({
    required String url,
    required FormData formData,
  }) async {
    try {
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      _dio.options.headers['Accept'] = 'application/json';

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('response ${formData}');

      if (response.statusCode == 200 && response.data is Map && response.data['success'] == true) {
        return response.data;
      } else {
        print('Erreur HTTP: ${response.statusCode}');
        return {'error': 'Erreur HTTP ${response.statusCode}', 'body': response.data};
      }
    } catch (error) {
      print('Erreur réseau : $error');
      return {'error': 'Exception réseau : $error'};
    }
  }



  Future<dynamic> signUp({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(url, data: body);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        print('Erreur lors de l\'inscription. Code de statut : ${response
            .statusCode}');
        throw Exception(
            'Erreur lors de l\'inscription. Code de statut : ${response
                .statusCode}');
      }
    } catch (error) {
      return handleError(error);
    }
  }

  Future<dynamic> logIn({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post(url, data: body);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Erreur lors de la connexion. Code de statut : ${response
            .statusCode}');
        throw Exception(
            'Erreur lors de la connexion. Code de statut : ${response
                .statusCode}');
      }
    } catch (error) {
      return handleError(error);
    }
  }

  Future<bool> logout(String url) async {
    try {
      String? token = await _getToken();
      final storage = FlutterSecureStorage();
      print('token ${token}');

      if (token == null || token.isEmpty) {
        print('Token non trouvé');
        return false;
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';
      //_dio.options.headers['Accept'] = 'application/json';

      final response = await _dio.post(
        url,
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'authToken');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erreur logout : $e');
      return false;
    }
  }
}