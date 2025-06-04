import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/const.dart';
import '../helpers/apiHelpers.dart';
import '../models/user.dart';
import '../services/dio_service.dart';

class AppointmentProvier with ChangeNotifier {
  final DioService _dioService =
      DioService(baseUrl: ConstData.urlBase, token: '');

  String _token = '';

  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }

  User _user = User(
      id: -1,
      lastName: '',
      firstName: '',
      email: '',
      phonenumber: '',
      typeprofile: '');

  final storage = FlutterSecureStorage();

  User get user => _user;

  // Récupérer plusieurs rendez-vous

  Future<List<dynamic>> getManyAppointments() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/appointments',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return responseData['data'];
        } else {
          throw Exception('Clé "appointments" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de rdv invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des rdv: $error');
      throw Exception('Impossible de récupérer les rdv');
    }
  }

  // Récupérer un seul rendez-vous

  Future<Map<String, dynamic>> getOneServiceRequest (int appointmentId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/appointments/${appointmentId}',
      );
      print('appointment info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Ce rendez-vous n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération du rendez-vous: $error');
      throw Exception('Impossible de récupérer le rendez-vous');
    }
  }

  // Ajouter un rendez-vous

  Future<Map<String, dynamic>> addServiceRequest(
      int clientId,
      int serviceId,
      int professionalId,
      String side_note,
      DateTime schedule_at,
      int price,
      int serviceRequestId
      ) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.post(
        url: '$baseUrl/appointments',
        body: {
          'client_id': clientId,
          'professional_id': professionalId,
          'service_id': serviceId,
          'service_request_id': serviceRequestId,
          'price': price,
          'scheduled_at': schedule_at,
          'side_note': side_note,
        },
      );

      print('Response Data: $responseData');
      if (responseData != null) {
        if (responseData['success'] != null && responseData['success'] == true) {
          return responseData['appointment'];
        } else {
          throw Exception('Erreur lors de la création de ce rendez-vous');
        }
      } else {
        return throw Exception('Réponse vide ou null');
      }
    } catch (error) {
      throw Exception('Réponse vide ou null $error');
    }
  }

  // Modifier un rendez-vous

  Future<Map <String, dynamic>> updateAppointment(
      int appointmentId,
      String status,
      int clientId,
      int serviceId,
      int professionalId,
      String side_note,
      DateTime schedule_at,
      int price,
      int serviceRequestId
      ) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      String? token = await getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      final response = await _dioService.put(
        url: '$baseUrl/appointments/$appointmentId',
        body: {
          'client_id': clientId,
          'professional_id': professionalId,
          'service_id': serviceId,
          'service_request_id': serviceRequestId,
          'price': price,
          'scheduled_at': schedule_at,
          'side_note': side_note,
        },
      );

      if (response != null && response is Map && response['success'] == true) {
        return {'succès': 'Mise à jour réussie'};
      } else {
        print('Erreur réponse: $response');
        return {'error': 'Erreur réponse: $response'};
      }
    } catch (error) {
      print('Erreur modifier rendez-vous: $error');
      return {'error': 'Exception modifier rendez-vous: $error'};
    }
  }

  // Supprimer un rendez-vous
}
