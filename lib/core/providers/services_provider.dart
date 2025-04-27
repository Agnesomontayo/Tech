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

class ServicesProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: '');
  String _token = '';
  Future<String?> getToken() async {
    return await storage.read(key: 'authToken');
  }
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();

  User get user => _user;

  // liste services

  Future<List<dynamic>> getManyServices() async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/services',
      );

      if (responseData != null && responseData is List) {
        return responseData;
      } else {
        throw Exception('Données de services invalides');
      }
    } catch (error) {
      print('Erreur lors de la récupération des services: $error');
      throw Exception('Impossible de récupérer les services');
    }
  }

  // récupérer une service

  Future<Map<String, dynamic>> getOneService (int serviceId) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.get(
        url: '${baseUrl}/services/${serviceId}',
      );
      print('service info $responseData');

      if (responseData != null) {
        return responseData;
      } else {
        throw Exception('Ce service n\'existe pas');
      }
    } catch (error) {
      print('Erreur lors de la récupération le service: $error');
      throw Exception('Impossible de récupérer le service');
    }
  }

// ajouter une profession

// modifier une profession

// supprimer une profession

}