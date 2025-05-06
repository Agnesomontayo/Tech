import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech/core/models/professionel.dart';
import 'package:tech/core/services/dio_service.dart';
import 'package:tech/core/const/const.dart';
import 'package:tech/core/providers/auth_provider.dart';

import '../helpers/apiHelpers.dart';
import '../models/user.dart';

class ProfessionalProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  User get user => _user;

  // liste des professionnels

  Future<List<dynamic>> getManyProfessionals() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/users/professionals',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return responseData['data'];
        } else {
          throw Exception('professionnels non trouvés dans la réponse');
        }
      } else {
        throw Exception('Données de services invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des services: $error');
      throw Exception('Impossible de récupérer les services');
    }
  }

  // récupérer un professionnel

  Future<Map<String, dynamic>> getOneProfessional (int professionalId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/users/professionals/${professionalId}',
      );
      print('professional info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Ce professionnel n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération le professionnel: $error');
      throw Exception('Impossible de récupérer le professionnel');
    }
  }

// récupérer les professionnels qui peeuvent réaliser un service

  Future<List<dynamic>> getProfessionalsByService(int serviceId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
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
        throw Exception('Données de professionnels invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des professionnels: $error');
      throw Exception('Impossible de récupérer les professionnels');
    }
  }

  // récupérer les professionnels en fonction des catégories de services

  Future<List<dynamic>> getProfessionalsByCategory(int categoryId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
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
        throw Exception('Données de professionnels invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des professionnels: $error');
      throw Exception('Impossible de récupérer les professionnels');
    }
  }

// modifier un professionnel

// supprimer un compte professionnel

}