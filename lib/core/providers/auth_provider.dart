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

class AuthProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: ''); // Assurez-vous que la valeur est correcte

  String _token = '';
  User _user = User(id: -1, nom: '', prenom: '', email: '', phonenumber: '', typeprofil: '');

  final storage = FlutterSecureStorage();
  /*bool get isAuthenticated {
    return _token.isNotEmpty;
  }*/

  User get user {
    return _user;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners(); // Notifier les auditeurs que l'état a changé
  }
  Future<String> logIn(String email, String password) async {
    try {
      final responseData = await _connectedUserServices.logIn(
        url: '${ConstData.urlBase}login',
        body: {
          'email': email,
          'password': password,
        },
      );
      print('Response Data: $responseData');

      if (responseData is Map<String, dynamic> && responseData.containsKey('token') && responseData['token'] != null) {
        final token = responseData['token'];

        // Stockez le token de manière sécurisée
        await storage.write(key: 'authToken', value: token);

        return ''; // Authentification réussie
      } else {
        // Si l'API renvoie un message d'erreur explicite, utilisez-le
        if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
          // Affichez le message d'erreur à l'utilisateur
          final apiError = responseData['message'];
          return apiError;
        }

        // Sinon, affichez un message générique
        return 'Mot de passe ou e-mail incorrect';
      }
    } catch (error) {
      // En cas d'erreur réseau ou autre, affichez l'erreur complète
      print('Erreur lors de l\'authentification : $error');
      return 'Erreur lors de l\'authentification : $error';
    }
  }
  Future<void> logOut() async {
    // Appelez votre API de déconnexion
    // Effacez également les données du token et de l'utilisateur ici

    notifyListeners();
  }


  Future<String> signUpClient(String nom, String prenom, String email, String password, String phonenumber) async {
    try {
      final responseData = await _connectedUserServices.signUp(
        url: '${ConstData.urlBase}register',
        body: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          'phonenumber': phonenumber,
          'typeprofil': 'client',
        },
      );

      print('Response Data: $responseData'); // Affichez la réponse renvoyée par l'API dans la console
      if (responseData != null) {
        if (responseData['success'] != null && responseData['success'] is bool && responseData['success']) {
          if (responseData['token'] != null) { // Vérifiez la présence du champ "token"
            _token = responseData['token'];
            notifyListeners();
            return ''; // Inscription réussie
          } else {
            return 'La réponse ne contient pas de jeton (token)';
          }
        } else {
          return 'Erreur lors de l\'inscription';
        }
      } else {
        return 'Réponse vide ou null';
      }
    } catch (error) {
      return 'Erreur lors de l\'inscription : $error';
    }
  }

  Future<String> signUpProfessional(String nom, String prenom, String email, String password, String phonenumber, String experience, String profession) async {
    try {

      final responseData = await _connectedUserServices.signUp(
        url: '${ConstData.urlBase}register',
        body: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          'phonenumber': phonenumber,
          'typeprofil': 'professionnel',
          'experience': experience,
          'profession': profession,
        },
      );
      print('Response Data: $responseData');

      if (responseData != null){
        if(responseData['success'] != null && responseData['success'] is bool && responseData['success']){
          if (responseData['token'] != null){
            _token = responseData['token'];
            notifyListeners();
            return ''; // Inscription réussie
          }else {
            return 'La réponse ne contient pas de jeton (token)';
          }
        }else {
          return 'Erreur lors de l\'inscription';
        }
      }else {
        return 'Réponse vide ou null';
      }

    } catch (error) {
      return 'Erreur lors de l\'inscription : $error';
    }
  }

 /* Future<void> _storeTokenSecurely(String token) async {
    try {
      await _storage.write(key: 'authToken', value: token);
    } catch (error) {
      // Gérer les erreurs liées au stockage sécurisé, par exemple, enregistrer dans un journal.
      throw Exception('Erreur lors du stockage du token : $error');
    }
  }

  Future<void> _storeUserDataSecurely(User user) async {
    try {
      final userData = user.toJson(); // Supposons que vous ayez une méthode toJson() dans votre classe User.
      await _storage.write(key: 'userData', value: jsonEncode(userData));
    } catch (error) {
      // Gérer les erreurs liées au stockage sécurisé, par exemple, enregistrer dans un journal.
      throw Exception('Erreur lors du stockage des données utilisateur : $error');
    }
  }

// Pour récupérer le token stocké de manière sécurisée
  Future<String?> _getStoredToken() async {
    try {
      final token = await _storage.read(key: 'authToken');
      return token;
    } catch (error) {
      // Gérer les erreurs liées au stockage sécurisé, par exemple, enregistrer dans un journal.
      throw Exception('Erreur lors de la récupération du token : $error');
    }
  }

// Pour récupérer les données utilisateur stockées de manière sécurisée
  Future<User?> _getStoredUserData() async {
    try {
      final userDataString = await _storage.read(key: 'userData');
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        return User.fromJson(userData); // Supposons que vous ayez une méthode fromJson() dans votre classe User.
      } else {
        return null;
      }
    } catch (error) {
      // Gérer les erreurs liées au stockage sécurisé, par exemple, enregistrer dans un journal.
      throw Exception('Erreur lors de la récupération des données utilisateur : $error');
    }
  }*/

}

/*
class AuthenticationState {
  bool _isAuthenticated = false;
  User? _authenticatedUser;

  bool get isAuthenticated => _isAuthenticated;
  User? get authenticatedUser => _authenticatedUser;

  void setUserAuthenticated(User user) {
    _isAuthenticated = true;
    _authenticatedUser = user;
  }

  void signOut() {
    _isAuthenticated = false;
    _authenticatedUser = null;
  }
}*/
