import 'package:flutter/foundation.dart';
import 'package:tech/core/models/client.dart';
import 'package:tech/core/services/dio_service.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:tech/core/const/const.dart';

class ClientProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');
  final AuthProvider _authProvider;

  ClientProvider(this._authProvider);

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    try {
      final result = await _dioService.post(
        url: '${ConstData.urlBase}login',
        body: {
          'email': email,
          'password': password,
        },
      );

      if (result['success']) {
        final clientData = result['data']['user'];
        final client = Client.fromJson(clientData);
        _authProvider.setUser(client);
      }

      return result;
    } catch (error) {
      return {'success': false, 'message': 'Une erreur s\'est produite lors de la connexion.'};
    }
  }

  Future<Map<String, dynamic>> signUp(
      String nom,
      String prenom,
      String email,
      String telephone,
      String password,
      ) async {
    try {
      final result = await _dioService.post(
        url: '${ConstData.urlBase}register',
        body: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
          'password': password,
        },
      );

      if (result['success']) {
        final clientData = result['data']['user'];
        final client = Client.fromJson(clientData);
        _authProvider.setUser(client);
      }

      return result;
    } catch (error) {
      return {'success': false, 'message': 'Une erreur s\'est produite lors de l\'inscription.'};
    }
  }

// Ajoutez d'autres méthodes spécifiques au client si nécessaire
}