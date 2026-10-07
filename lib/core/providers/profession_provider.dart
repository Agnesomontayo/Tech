import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:tech/core/models/user.dart';
import 'package:tech/core/models/profession.dart';
import 'package:tech/core/models/professionel.dart';
import 'package:tech/core/models/client.dart';
import 'package:tech/core/services/dio_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tech/core/const/const.dart';
import 'package:tech/core/helpers/apiHelpers.dart';

class ProfessionProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  User get user => _user;

  // liste professions

  Future<List<dynamic>> getManyProfessions() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/professions',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return responseData['data'];
        } else {
          throw Exception('Clé "data" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de professions invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des professions: $error');
      throw Exception('Impossible de récupérer les professions');
    }
  }

  // récupérer les professions sans connexion

  Future<List<dynamic>> getManyAvailableProfessions() async {
    try {
      Dio dio = Dio();
      String baseUrl = await ApiHelper.getApiUrl();
      final response = await dio.get('${baseUrl}/professions-available');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return response.data;
        }
        else if (response.data is Map && response.data['data'] is List) {
          return response.data['data'];
        } else {
          throw Exception('Format de données inattendu');
        }
      } else {
        throw Exception('Échec de la requête: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la récupération des professions: $error');
      throw Exception('Impossible de récupérer les professions: ${error.toString()}');
    }
  }
  // récupérer une profession

  Future<Map<String, dynamic>> getOneProfession (int professionId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/professions/${professionId}',
      );
      print('profession info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Cette profession n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération de la profession: $error');
      throw Exception('Impossible de récupérer la profession');
    }
  }

  // ajouter une profession

  // modifier une profession

  // supprimer une profession

}