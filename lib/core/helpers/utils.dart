
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' as fsvg;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tech/core/services/professional_location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

Future<BitmapDescriptor> createCustomMarkerBitmap({
  required String name,
  required String profession,
  required String availability,
}) async {
  ScreenshotController screenshotController = ScreenshotController();

  final widgetToRender = Material(
    type: MaterialType.transparency,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Ombre pour un effet de profondeur
            blurRadius: 4,
            offset: Offset(0, 2), // Décalage de l'ombre
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _getAvailabilityColor(availability),
              shape: BoxShape.circle,
            ),
            child: Icon(
              availability == 'available'
                  ? Icons.online_prediction
                  : Icons.do_not_disturb_on,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Taille de police pour le nom
                  color: Colors.black,
                ),
              ),
              Text(
                profession,
                style: TextStyle(
                  fontSize: 12, // Taille de police pour la profession
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  final Uint8List? byteData = await screenshotController.captureFromWidget(
    widgetToRender,
    delay: const Duration(milliseconds: 50),
    pixelRatio: 3.0,
  );

  if (byteData == null) {
    throw Exception("Erreur: Impossible de capturer le widget comme image pour le marqueur personnalisé.");
  }

  return BitmapDescriptor.fromBytes(byteData);
}

Color _getAvailabilityColor(String availability) {
  switch (availability.toLowerCase()) { // Utilisation de toLowerCase pour une comparaison insensible à la casse
    case 'available':
      return Colors.green;
    case 'unavailable':
      return Colors.red;
    default:
      return Colors.grey; // Couleur par défaut si le statut est inconnu
  }
}


String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String formatDistance(double distanceInMeters) {
  if (distanceInMeters < 1000) {
    return 'A ${distanceInMeters.round()} m';
  } else {
    double distanceInKm = distanceInMeters / 1000.0;
    return 'A ${distanceInKm.toStringAsFixed(1)} km';
  }
}


String capitalizeEachWord(String text) {
  return text
      .split(' ')
      .map((word) => word.isNotEmpty
      ? word[0].toUpperCase() + word.substring(1)
      : '')
      .join(' ');
}

const updateTask = "update-location-task";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == updateTask) {
      final locationService = ProfessionalLocationService();

      try {
        print('Démarrage de la callback dispatcher');
        final position = await locationService.getCurrentPosition(background: true);
        print('Position récupérée: ${position?.latitude}, ${position?.longitude}');
        if (position == null) return Future.value(false);

        final token = inputData?['token'];
        if (token == null) return Future.value(false);

        final success = await locationService.sendLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          token: token,
        );
        return Future.value(success);
      } catch (e) {
        print('Erreur tâche fond: $e');
        return Future.value(false);
      }
    }
    return Future.value(false);
  });
}

Future<void> startBackgroundLocationUpdate(String token) async {
  await Workmanager().registerOneOffTask(/*registerPeriodicTask*/
    updateTask,
    updateTask,
    //frequency: Duration(minutes: 15),
    inputData: {
      'token': token,
    },
    existingWorkPolicy: ExistingWorkPolicy.replace,
    initialDelay: Duration(seconds: 10),
  );
}

Future<void> stopBackgroundLocationUpdate() async {
  await Workmanager().cancelByUniqueName(updateTask);
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.status;

  if (status.isDenied || status.isRestricted || status.isLimited) {
    print('🛑 Permission initialement refusée, demande en cours...');
    status = await Permission.location.request();
  }

  if (status.isGranted) {
    print('✅ Permission localisation accordée');
  } else if (status.isPermanentlyDenied) {
    print('❌ Permission refusée définitivement, ouvrir les paramètres...');
    await openAppSettings();
  }
}


