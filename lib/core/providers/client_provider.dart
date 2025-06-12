import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech/core/models/client.dart';
import 'package:tech/core/services/dio_service.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:tech/core/const/const.dart';

import '../helpers/apiHelpers.dart';

class ClientProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
 // User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  // liste des clients

  Future<List<dynamic>> getManyClients() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/users/clients',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return responseData['data'];
        } else {
          throw Exception('clients non trouvés dans la réponse');
        }
      } else {
        throw Exception('Données de services invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des services: $error');
      throw Exception('Impossible de récupérer les services');
    }
  }

  // récupérer un client

  Future<Map<String, dynamic>> getOneClient (int clientId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/users/clients/${clientId}',
      );
      print('client info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Ce client n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération le client: $error');
      throw Exception('Impossible de récupérer le client');
    }
  }

  // liste des clients qui ont demadé un service à un professionnel

  Future<List<dynamic>> getClientRequestedProfessionalsList(int professionalId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/conversations/clients-list/${professionalId}',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        print('conversation clients ${responseData}');
        if (responseData.containsKey('clients')) {
          return responseData['clients'];
        } else {
          throw Exception('Clé "clients" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de clients invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des clients: $error');
      throw Exception('Impossible de récupérer les clients');
    }
  }


  // liste des services et professionnels les plus demandés par le client

  Future<Map<String, dynamic>> getMostRequestedProfessionalsAndServices(int clientId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/clients/reports/most-requested-services/most-requested-professionals/${clientId}',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        print('conversation clients ${responseData}');
        if (responseData.containsKey('most_requested_services') && responseData.containsKey('most_requested_professionals')) {
          return responseData;
        } else {
          throw Exception('Clé "clients" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de clients invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des clients: $error');
      throw Exception('Impossible de récupérer les clients');
    }
  }
// modifier un client



// supprimer un compte client

// récupérer les clients qui peeuvent réaliser un service

/*
  Future<List<dynamic>> getClientsByService(int serviceId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/professionals/by-service/${serviceId}',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        print('service professional ${responseData}');
        if (responseData.containsKey('professionals')) {
          return responseData['professionals'];
        } else {
          throw Exception('Clé "professionals" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de clients invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des clients: $error');
      throw Exception('Impossible de récupérer les clients');
    }
  }

  // récupérer les clients en fonction des catégories de services

  Future<List<dynamic>> getClientsByCategory(int categoryId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/professionals/by-category/${categoryId}',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        print('service professionals ${responseData}');
        if (responseData.containsKey('professionals')) {
          return responseData['professionals'];
        } else {
          throw Exception('Clé "professionals" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de clients invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des clients: $error');
      throw Exception('Impossible de récupérer les clients');
    }
  }
*/


}