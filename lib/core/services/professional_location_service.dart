import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

import '../helpers/apiHelpers.dart';

class ProfessionalLocationService {
  final Dio _dio = Dio();

  Future<bool> sendLocation({
    required double latitude,
    required double longitude,
    required String token,
  }) async {
    try {
      print('Envoi de la localisation...');
      String baseUrl = await ApiHelper.getApiUrl();
      final String apiUrl = '${baseUrl}/update-location';

      final response = await _dio.post(
        apiUrl,
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: Duration(milliseconds: 5000),
          sendTimeout: Duration(milliseconds: 5000),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur API envoi localisation: $e');
      return false;
    }
  }

  Future<Position?> getCurrentPosition({bool background = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('❌ Service de localisation désactivé');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print('❌ Permission refusée : $permission');
      if (background) return null;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('❌ Permission refusée après demande : $permission');
        return null;
      }
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      print('✅ Position obtenue: ${pos.latitude}, ${pos.longitude}');
      return pos;
    } catch (e) {
      print('❌ Erreur Geolocator: $e');
      return null;
    }
  }


/*Future<Position?> getCurrentPosition({bool background = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (background) return null; // Ne rien faire en tâche de fond
      print('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      if (background) return null; // Ne pas demander de permission en tâche de fond
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('Location permissions are denied');
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: Duration(seconds: 10),
    );
  }*/

}
