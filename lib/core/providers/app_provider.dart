import 'dart:io';
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

class AppProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken'); // Récupérer le token
  }
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  User get user => _user;

  //users
  Future<Map<String, dynamic>> getProfile () async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/user/profile',
      );
      print('user info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Profil vide');
      }
    } catch (error) {
      print('Erreur lors de la récupération du profil: $error');
      throw Exception('Impossible de récupérer le profil');
    }
  }

  // update user profil

  Future<dynamic> updateUserProfile({
    required FormData formData,
  }) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return {'error': 'Token non trouvé'};
      }

      final response = await _connectedUserServices.postFormData(
        url: '$baseUrl/user/update-profile',
        formData: formData,
      );

      if (response != null && response is Map && response['success'] == true) {
        return response;
      } else {
        print('Erreur réponse: $response');
        return {'error': 'Erreur réponse: $response'};
      }
    } catch (error) {
      print('Erreur updateUserProfile: $error');
      return {'error': 'Exception updateUserProfile: $error'};
    }
  }

  // déconnexion

  Future<bool> logout() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      String? token = await _getToken();

      final response = await _connectedUserServices.logout('$baseUrl/logout');

      if (response == true) {
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
