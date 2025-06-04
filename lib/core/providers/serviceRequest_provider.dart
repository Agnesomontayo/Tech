import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/const.dart';
import '../helpers/apiHelpers.dart';
import '../models/user.dart';
import '../services/dio_service.dart';

class ServiceRequestProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');

  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  final StreamController<int> requestUpdates = StreamController<int>.broadcast();

  User get user => _user;

  // liste des demandes

  Future<List<dynamic>> getManyServiceRequests() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/service_requests',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return responseData['data'];
        } else {
          throw Exception('Clé "service_requests" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de demande invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des demandes: $error');
      throw Exception('Impossible de récupérer les demandes');
    }
  }

  // récupérer une demande

  Future<Map<String, dynamic>> getOneServiceRequest (int serviceRequestId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/service_requests/${serviceRequestId}',
      );
      print('demande info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Cette demande n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération de la demande: $error');
      throw Exception('Impossible de récupérer la demande');
    }
  }

  // Ajouter une demande

  Future<Map<String, dynamic>> addServiceRequest(
      int clientId,
      int professionalId,
      int serviceId,
      DateTime scheduleAt,
      String sideNote,
      ) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.post(
        url: '$baseUrl/service_requests',
        body: {
          'client_id': clientId,
          'professional_id': professionalId,
          'service_id': serviceId,
          'scheduled_at': scheduleAt.toIso8601String(), // important pour éviter des erreurs de format
          'side_note': sideNote,
        },
      );

      print('Response Data: $responseData');

      if (responseData != null && responseData['success'] == true) {
        return responseData['request'];
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

  //Modifier le status d'un service demandé

  Future<Map <String, dynamic>> updateServiceRequestStatus(int serviceRequestId, String status, int? durationMinutes, int? price) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      String? token = await getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      final response = await _dioService.put(
        url: '$baseUrl/service_requests/updateStatus/$serviceRequestId',
        body: {
          'status': status,
          'duration_minutes': durationMinutes,
          'price': price,
        },
      );

      requestUpdates.add(serviceRequestId);
      notifyListeners();

      if (response != null && response is Map && response['success'] == true) {
        return {'succès': 'Mise à jour réussie'};
      } else {
        print('Erreur réponse: $response');
        return {'error': 'Erreur réponse: $response'};
      }
    } catch (error) {
      print('Erreur modifier status: $error');
      return {'error': 'Exception modifier status: $error'};
    }
  }

  // Modifier une demande


}