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

class ProfessioncategoryProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  User get user => _user;

  // liste des catégories de profession

  Future<List<dynamic>> getManyCategories() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/profession_categories',
      );

      if (responseData != null && responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data')) {
          return responseData['data'];
        } else {
          throw Exception('Clé "categories" non trouvée dans la réponse');
        }
      } else {
        throw Exception('Données de catégorie invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des catégories: $error');
      throw Exception('Impossible de récupérer les catégories');
    }
  }

  // récupérer une catégorie

  Future<Map<String, dynamic>> getOneCategory (int categoryId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/services/${categoryId}',
      );
      print('catégory info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Cette catégorie n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération de la catégorie: $error');
      throw Exception('Impossible de récupérer la catégorie');
    }
  }

}