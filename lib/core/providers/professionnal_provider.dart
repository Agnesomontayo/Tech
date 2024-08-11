import 'package:flutter/foundation.dart';
import 'package:tech/core/models/professionel.dart';
import 'package:tech/core/services/dio_service.dart';
import 'package:tech/core/const/const.dart';
import 'package:tech/core/providers/auth_provider.dart';

class ProfessionalProvider with ChangeNotifier {
  final DioService _dioService = DioService(baseUrl: ConstData.urlBase, token: '');
  final AuthProvider _authProvider;

  ProfessionalProvider(this._authProvider);

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
        final professionelData = result['data']['user'];
        final professionel = Professionel.fromJson(professionelData);
        _authProvider.setUser(professionel);
      }

      return result;
    } catch (error) {
      return {'success': false, 'message': 'Une erreur s\'est produite lors de la connexion.'};
    }
  }

  Future<Map<String, dynamic>> registerProfessional(
      String nom,
      String prenom,
      String email,
      String telephone,
      String password,
      String experience,
      String profession,
      ) async {
    try {
      final result = await _dioService.post(
        url: '${ConstData.urlBase}register_professional', // Assurez-vous que l'URL d'inscription professionnelle est correcte
        body: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          'experience': experience,
          'profession': profession,
        },
      );

      if (result['success']) {
        final professionelData = result['data']['professionel'];
        final professionel = Professionel.fromJson(professionelData);
      }

      return result;
    } catch (error) {
      return {'success': false, 'message': 'Une erreur s\'est produite lors de l\'inscription professionnelle.'};
    }
  }
// Ajoutez d'autres méthodes spécifiques au professionnel si nécessaire
}