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

class AuthProvider with ChangeNotifier {
  final DioService _connectedUserServices = DioService(baseUrl: ConstData.urlBase, token: ''); // Assurez-vous que la valeur est correcte

  String _token = '';
  User _user = User(id: -1, lastName: '', firstName: '', email: '', phonenumber: '', typeprofile: '');

  final storage = FlutterSecureStorage();
  /*bool get isAuthenticated {
    return _token.isNotEmpty;
  }*/

  User get user {
    return _user;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      print('Appel à : $baseUrl/login');
      final responseData = await _connectedUserServices.logIn(
        url: '$baseUrl/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      print('Response Data: $responseData');

      if (responseData is Map<String, dynamic> && responseData.containsKey('token') && responseData.containsKey('user')) {
        final token = responseData['token'];
        final user = responseData['user'];

        await storage.write(key: 'authToken', value: token);

        await storage.write(key: 'userId', value: user['id'].toString());
        await storage.write(key: 'typeprofile', value: user['typeprofile']);
        await storage.write(key: 'email', value: user['email']);

        notifyListeners();
        return {
          'error': '',
          'profileType': user['typeprofile'],
        };
      } else {
        final apiError = responseData['message'] ?? 'Mot de passe ou e-mail incorrect';
        return {
          'error': apiError,
          'profileType': '',
        };
      }
    } catch (error) {
      print('Erreur lors de l\'authentification : $error');
      return {
        'error': 'Erreur lors de l\'authentification : $error',
        'profileType': '',
      };
    }
  }

  Future<void> logOut() async {
    notifyListeners();
  }


  Future<String> signUpClient(String firstName, String lastName, String email, String password, String phonenumber) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.signUp(
        url: '$baseUrl/register',
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phonenumber': phonenumber,
          'typeprofile': 'client',
        },
      );

      print('Response Data: $responseData');
      if (responseData != null) {
        if (responseData['success'] != null && responseData['success'] == true) {
          if (responseData['token'] != null) {
            final token = responseData['token'];
            final user = responseData['user'];

            await storage.write(key: 'authToken', value: token);

            await storage.write(key: 'userId', value: user['id'].toString());
            await storage.write(key: 'profileType', value: user['typeprofile']);
            await storage.write(key: 'email', value: user['email']);

            _token = token;
            notifyListeners();

            return '';
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

  Future<String> signUpProfessional(String firstName, String lastName, String email, String password, String phonenumber, String experience, String profession) async {
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final responseData = await _connectedUserServices.signUp(
        url: '$baseUrl/register',
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phonenumber': phonenumber,
          'typeprofile': 'professionnel',
          'experience': experience,
          'profession': profession,
        },
      );
      print('Response Data: $responseData');

      if (responseData != null){
        if(responseData['success'] != null && responseData['success'] is bool && responseData['success']){
          if (responseData['token'] != null){
            final token = responseData['token'];
            final user = responseData['user'];

            await storage.write(key: 'authToken', value: token);

            await storage.write(key: 'userId', value: user['id'].toString());
            await storage.write(key: 'profileType', value: user['typeprofile']);
            await storage.write(key: 'email', value: user['email']);

            _token = token;
            notifyListeners();
            return '';
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
