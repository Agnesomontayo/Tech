import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech/core/models/review.dart';

import '../const/const.dart';
import '../helpers/apiHelpers.dart';
import '../services/dio_service.dart';

class ReviewProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }

  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> addNewReview(Review reviewData) async {
    try {
      Map<String, dynamic> data = reviewData.toJson();
      print('yelle ${data}');
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.post(
        url: '${baseUrl}/reviews',
        body: {
          'client_id': data['client_id'],
          'professional_id': data['professional_id'],
          'rate': data['rate'],
          'opinion': data['opinion'],
          'comment': data['comment']
        },
      );

      print('Response Data: $responseData');

      if (responseData != null && responseData['success'] == true) {
        return responseData['data'];
      } else if (responseData != null && responseData.containsKey('message')) {
        throw Exception(responseData['message']);
      } else {
        throw Exception('Erreur lors de la création de cette demande.');
      }

    } on DioException catch (dioError) {
      String message = "Une erreur inconnue est survenue.";

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        message = "Le serveur met trop de temps à répondre. Veuillez réessayer.";
      } else if (dioError.type == DioExceptionType.connectionError) {
        message = "Impossible de se connecter au serveur. Vérifiez votre connexion internet.";
      } else if (dioError.response != null) {
        if (dioError.response?.statusCode == 422) {
          final errors = dioError.response?.data['errors'];
          final firstError = errors?.values.first[0];
          message = firstError ?? 'Erreur de validation';
        } else {
          message = dioError.response?.data['message'] ?? "Erreur serveur : ${dioError.response?.statusCode}";
        }
      } else if (dioError.message != null) {
        message = dioError.message!;
      }

      throw Exception(message);
    } catch (error) {
      throw Exception('Erreur inattendue : ${error.toString()}');
    }
  }

}