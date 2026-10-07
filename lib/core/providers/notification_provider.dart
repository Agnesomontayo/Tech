import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../const/const.dart';
import '../helpers/apiHelpers.dart';
import '../services/dio_service.dart';

class NotificationProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');

  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken'); // Récupérer le token
  }


  Future<List<dynamic>> getPendingNotifications() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();

      final response = await _dioService.get(
        url: '$baseUrl/notifications-pending',
      );
        if (response['success'] == true) {
          return (response['data'] as List);
        } else {
          throw Exception(response['message'] ?? 'Erreur inconnue');
        }
    } on DioError catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    }
  }

  Future<bool> markAsRead(int notificationId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final dio = Dio();
      String? token = await _getToken();

      if (token == null || token.isEmpty) {
        return false;
      }

      final response = await dio.post(
       '$baseUrl/notifications/$notificationId/mark-read',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.data['success'] == true;
    } on DioError catch (e) {
      debugPrint('Erreur markAsRead: ${e.message}');
      return false;
    }
  }


  Future<bool> updateAvailability({
    required String status,
  }) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final response = await _dioService.put(
        url: '${baseUrl}/availability',
        body: {
          'availability': status,
        },
      );
      notifyListeners();
      if (response['success']) {
        return true;
      } else {
        throw Exception('Erreur update availability API: ${response.statusCode}');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateFrequency({
    required String frequency,
  }) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();

      final response = await _dioService.put(
        url: '$baseUrl/availability-notifications-frequency',
        body: {
          'frequency': frequency,
        },
      );

      notifyListeners();
      if (response['success']) {
        return true;
      } else {
        throw Exception('Erreur update frequency API: ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur modifier rendez-vous: $error');
      return false;
    }
  }

  Future<List<dynamic>> getAvailabilityNotifications(int professionId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/professionals/availability-notifications/${professionId}',
      );
      notifyListeners();
      if (responseData != null) {
        print('classement ${responseData}');
        return responseData;
      } else {
        throw Exception('Données de professionnel invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des professionnels: $error');
      throw Exception('Impossible de récupérer les professionnels');
    }
  }

  Future<String> getProfessionalFrequency() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _dioService.get(
        url: '${baseUrl}/professionals/availability-frequency',
      );
      notifyListeners();
      if (responseData != null) {
        print('professional frequency ${responseData}');
        return responseData;
      } else {
        throw Exception('Données de professionnel invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des infos du professionnel: $error');
      throw Exception('Impossible de récupérer les infos de professionnel');
    }
  }

}