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
  Map<String, dynamic> _userProfile = {};
  bool _isLoadingProfile = false;
  String _baseImageUrl = '';


  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken');
  }
  final storage = FlutterSecureStorage();

  Map<String, dynamic> get userProfile => _userProfile;
  bool get isLoadingProfile => _isLoadingProfile;
  String get baseImageUrl => _baseImageUrl;

  Future<void> initializeBaseImageUrl() async {
    _baseImageUrl = await ApiHelper.getApiUrl();
    print('yo n y est et bien cherhche ailleurs');
    notifyListeners();
  }

  //users
  Future<Map<String, dynamic>> getProfile () async {
    _isLoadingProfile = true;
    notifyListeners();
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/user/profile',
      );
      print('user info $responseData');

      if (responseData != null) {
        _userProfile = responseData ?? {};
        return responseData;
      } else {
        _userProfile = {};
        throw Exception('Profil vide');
      }
    } catch (error) {
      _userProfile = {};
      print('Erreur lors de la récupération du profil: $error');
      throw Exception('Impossible de récupérer le profil');
    }finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // update user profil

  Future<dynamic> updateUserProfile({
    required FormData formData,
  }) async {
    _isLoadingProfile = true;
    notifyListeners();
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
        //_userProfile = response['data'] ?? {};
        await getProfile();
        notifyListeners();
        return response;
      } else {
        print('Erreur réponse: $response');
        return {'error': 'Erreur réponse: $response'};
      }
    } catch (error) {
      print('Erreur updateUserProfile: $error');
      return {'error': 'Exception updateUserProfile: $error'};
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
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
