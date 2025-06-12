
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
  // Crée un contrôleur pour le package screenshot
  ScreenshotController screenshotController = ScreenshotController();

  // Le widget que vous souhaitez rendre en image
  final widgetToRender = Material(
    type: MaterialType.transparency, // Permet un fond transparent si nécessaire
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white, // Couleur de fond de votre marqueur
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
        mainAxisSize: MainAxisSize.min, // Indispensable pour que le Row prenne la taille minimale de ses enfants
        children: [
          // Indicateur de disponibilité (cercle de couleur)
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getAvailabilityColor(availability), // Fonction pour la couleur
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8), // Espace entre l'indicateur et le texte
          // Nom et profession du professionnel
          Column(
            mainAxisSize: MainAxisSize.min, // La colonne prend la taille minimale de ses enfants
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement du texte à gauche
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

  // Capture le widget et le convertit en Uint8List (tableau d'octets)
  // Le package screenshot s'occupe de tout le rendu off-screen,
  // y compris la création de RenderRepaintBoundary.
  final Uint8List? byteData = await screenshotController.captureFromWidget(
    widgetToRender,
    delay: const Duration(milliseconds: 50), // Un petit délai pour s'assurer que tout est rendu
    pixelRatio: 3.0, // Résolution de l'image (plus élevé = plus détaillé)
    // Vous pouvez spécifier une taille cible si vous voulez une image de dimensions fixes :
    // targetSize: const Size(200, 100),
  );

  // Vérifie si la capture a réussi
  if (byteData == null) {
    throw Exception("Erreur: Impossible de capturer le widget comme image pour le marqueur personnalisé.");
  }

  // Crée un BitmapDescriptor à partir des octets de l'image
  return BitmapDescriptor.fromBytes(byteData);
}

/// Détermine la couleur de l'indicateur de disponibilité.
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
/*Future<BitmapDescriptor> createCustomMarkerBitmap({
  required String name,
  required String profession,
  required String availability,
}) async {
  // Create a widget to render
  final widget = Material(
    type: MaterialType.transparency,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Availability indicator
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getAvailabilityColor(availability),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          // Name and profession text
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(profession, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    ),
  );

  // Render the widget to an image
  final RenderRepaintBoundary boundary = await _renderWidgetToImage(widget);
  final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}

Color _getAvailabilityColor(String availability) {
  switch (availability) {
    case 'available':
      return Colors.green;
    case 'unavailable':
      return Colors.red;
    default:
      return Colors.grey;
  }
}*/
/*

Future<RenderRepaintBoundary> _renderWidgetToImage(Widget widget) async {
  final RenderView renderView = RenderView(
    view: WidgetsBinding.instance.window,
    child: RenderPositionedBox(
      alignment: Alignment.center,
      child: RenderRepaintBoundary(),
    ),
    configuration: ViewConfiguration(
      //size: WidgetsBinding.instance.window.physicalSize,
      devicePixelRatio: WidgetsBinding.instance.window.devicePixelRatio,
    ),
  );

  final PipelineOwner pipelineOwner = PipelineOwner();
  pipelineOwner.rootNode = renderView;

  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: renderView.child! as RenderObjectWithChildMixin<RenderBox>,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: widget,
    ),
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  return renderView.child as RenderRepaintBoundary;
}
*/



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


