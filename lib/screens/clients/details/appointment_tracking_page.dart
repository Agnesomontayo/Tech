import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tech/core/utils/func.dart';
import 'package:tech/screens/clients/client_forms/review_form.dart';
import 'dart:convert';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/models/appointment.dart';
import '../../../core/models/service.dart';
import '../../../core/providers/client_provider.dart';
import '../../../core/services/professional_location_service.dart';
import '../../../core/services/reverb_appointment_service.dart';
import '../widgets/CustumAppBar.dart';
import 'package:provider/provider.dart';

class AppointmentTrackingPage extends StatefulWidget {
  final int appointmentId;
  final int currentUserId;
  final String baseUrl;
  final String userToken;
  final String appKey;
  final String typeProfile;

  const AppointmentTrackingPage({
    super.key,
    required this.appointmentId,
    required this.currentUserId,
    required this.baseUrl,
    required this.userToken,
    required this.appKey,
    required this.typeProfile,
  });

  @override
  State<AppointmentTrackingPage> createState() => _AppointmentTrackingPageState();
}

class _AppointmentTrackingPageState extends State<AppointmentTrackingPage> {
  late ReverbAppointmentService _appointmentService;
  AppointmentDisplayData? _appointmentData;
  ServiceRequestDisplayData? _serviceRequestData;

  String _statusMessage = 'Connexion en cours...';
  bool _isConnected = false;
  Timer? _countdownTimer;
  int _currentRemainingMinutes = 0;
  DateTime? _appointmentStartTime;
  DateTime? _lastUpdateTimestamp;
  bool isProfessional = false;
  late GoogleMapController _mapController;
  LatLng? _clientLocation;
  LatLng? _professionalLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;


  void _initReverbService() {
    _appointmentService = ReverbAppointmentService(
      baseUrl: widget.baseUrl,
      token: widget.userToken,
      appKey: widget.appKey,
      appointmentId: widget.appointmentId,
      userId: widget.currentUserId,
      //debug: true,
      onAppointmentUpdate: _handleAppointmentUpdate,
      onConnected: _handleReverbConnected,
      onError: _handleReverbError,
      onDisconnected: _handleReverbDisconnected,
    );

    _appointmentService.connect();
  }

  Map<String, dynamic> getStatusConfig(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.completed:
        return {
          'label': 'Terminé',
          'color': Colors.green.shade100,
          'icon': Icons.check,
          'iconColor': Colors.green.shade700
        };
      case AppointmentStatus.started:
        return {
          'label': 'En cours',
          'color': Colors.blue.shade100,
          'icon': Icons.play_arrow,
          'iconColor': Colors.blue.shade700
        };
      case AppointmentStatus.paused:
        return {
          'label': 'En pause',
          'color': Colors.orange.shade100,
          'icon': Icons.pause,
          'iconColor': Colors.orange.shade700
        };
      case AppointmentStatus.stopped:
        return {
          'label': 'Arrêté',
          'color': Colors.red.shade100,
          'icon': Icons.stop,
          'iconColor': Colors.red.shade700
        };
      case AppointmentStatus.planned:
        return {
          'label': 'En attente',
          'color': Colors.blueGrey.shade100,
          'icon': Icons.pending_actions,
          'iconColor': Colors.blueGrey.shade700
        };
      case AppointmentStatus.unknown:
      default:
        return {
          'label': 'Inconnu',
          'color': Colors.grey.shade100,
          'icon': Icons.close,
          'iconColor': Colors.grey.shade700
        };
    }
  }

  /*Future<void> _fetchInitialAppointmentState() async {
    try {
      final response = await http.get(
        Uri.parse('http://${widget.baseUrl}:8000/api/appointments/${widget.appointmentId}'),
        headers: {
          'Authorization': 'Bearer ${widget.userToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print('data ${data}');
        setState(() {
          _appointmentData = AppointmentDisplayData.fromJson(data);
          _serviceRequestData = ServiceRequestDisplayData.fromJson(data['service_request']);
          print('clientId ${_serviceRequestData?.client_id}');
          print('professionnalId ${_serviceRequestData?.professional_id}');
          _statusMessage = 'Rendez-vous chargé.';
          widget.typeProfile == 'professionnel' ? isProfessional = true : isProfessional = false;
        });
      } else {
        setState(() {
          _statusMessage = 'Erreur chargement RDV: ${response.statusCode}';
          print('Failed to load initial appointment state: ${response.body}');
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Erreur réseau/parsing: $e';
        print('Error fetching initial appointment state: $e');
      });
    }
  }*/

  Future<void> _fetchInitialAppointmentState() async {
    try {
      final response = await http.get(
        Uri.parse('http://${widget.baseUrl}:8000/api/appointments/${widget.appointmentId}'),
        headers: {
          'Authorization': 'Bearer ${widget.userToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Données complètes reçues: $data'); // Debug complet

        if (data['service_request'] == null) {
          throw Exception('Données service_request manquantes dans la réponse');
        }

        setState(() {
          _appointmentData = AppointmentDisplayData.fromJson(data);
          _serviceRequestData = ServiceRequestDisplayData.fromJson(data['service_request']);

          // Vérification explicite des IDs
          if (_serviceRequestData?.client_id == null || _serviceRequestData?.professional_id == null) {
            throw Exception('IDs client ou professionnel manquants dans service_request');
          }

          print('Client ID: ${_serviceRequestData?.client_id}');
          print('Professional ID: ${_serviceRequestData?.professional_id}');

          _statusMessage = 'Rendez-vous chargé.';
          isProfessional = widget.typeProfile == 'professionnel';
        });

        // Appeler _getLocations() seulement après avoir tout initialisé
        if (mounted) {
          await _getLocations();
        }
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error fetching initial appointment state: $e');
      if (mounted) {
        setState(() {
          _statusMessage = 'Erreur: ${e.toString()}';
        });
        _showErrorSnackBar('Erreur de chargement du rendez-vous');
      }
    }
  }

  void _handleAppointmentUpdate(Map<String, dynamic> data) {
    if (!mounted) return;

    // Gardez le log pour le débogage
    print('Received Reverb Update Event Payload: $data');

    setState(() {
      _appointmentData = AppointmentDisplayData.fromJson(data);
      _currentRemainingMinutes = _appointmentData!.remainingMinutes;

      if (_appointmentData!.status == AppointmentStatus.started) {
        _startCountdown();
      } else {
        _stopCountdown();
      }
      if (_appointmentData!.action == 'completed' || _appointmentData!.action == 'stopped') {
       // _showReviewForm(context);
      }
    });
  }

  void _handleReverbConnected() {
    if (!mounted) return;
    setState(() {
      _isConnected = true;
      _statusMessage = 'Connecté aux mises à jour en temps réel.';
    });
    print('Connected to appointment updates');
  }

  void _handleReverbError(dynamic error, [StackTrace? stackTrace]) {
    if (!mounted) return;
    setState(() {
      _isConnected = false;
      _statusMessage = 'Erreur de connexion en temps réel: $error';
    });
    print('Appointment update error: $error\n$stackTrace');
  }

  void _handleReverbDisconnected() {
    if (!mounted) return;
    setState(() {
      _isConnected = false;
      _statusMessage = 'Déconnecté du service de mise à jour. Tentative de reconnexion...';
    });
    print('Disconnected from Reverb.');
  }

  void _showReviewForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ReviewForm(
        clientId: _serviceRequestData!.client_id!,
        professionalId: _serviceRequestData!.professional_id!,
      ),
    );
  }

  void _startCountdown() {
    _lastUpdateTimestamp = DateTime.now();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        _stopCountdown();
        return;
      }

      setState(() {
        final now = DateTime.now();
        final secondsSinceLastUpdate = now.difference(_lastUpdateTimestamp!).inSeconds;

        final int initialRemainingSeconds = _appointmentData!.remainingMinutes * 60;
        int newRemainingSeconds = initialRemainingSeconds - secondsSinceLastUpdate;

        _currentRemainingMinutes = (newRemainingSeconds / 60).ceil().clamp(0, _appointmentData!.durationMinutes);

        if (newRemainingSeconds <= 0) {
          _currentRemainingMinutes = 0;
          _stopCountdown();
        }
      });
    });
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  Future<void> _getLocations() async {
    if (!mounted) return;

    // Vérification approfondie
    if (_serviceRequestData == null) {
      print('ServiceRequestData non initialisé');
      return;
    }

    final clientId = _serviceRequestData?.client_id;
    final professionalId = _serviceRequestData?.professional_id;

    if (clientId == null || professionalId == null) {
      print('IDs manquants - client: $clientId, professional: $professionalId');
      return;
    }

    try {
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);

      print('Récupération position pour client: $clientId');
      final clientResponse = await clientProvider.getClientLocation(clientId);
      _processClientResponse(clientResponse);

      print('Récupération position pour professionnel: $professionalId');
      final proResponse = await clientProvider.getProfessionalLocation(professionalId);
      _processProfessionalResponse(proResponse);

      if (_clientLocation != null && _professionalLocation != null) {
        print('Calcul itinéraire entre client et professionnel');
        await _getPolyline();
      } else {
        print('Positions insuffisantes pour calculer itinéraire');
      }
    } catch (e) {
      print('Erreur récupération positions: $e');
      _showErrorSnackBar('Erreur de chargement des positions');
    }
  }

  void _processClientResponse(Map<String, dynamic>? response) {
    if (response == null || response['latitude'] == null || response['longitude'] == null) {
      print('Réponse client incomplète');
      return;
    }

    final lat = double.tryParse(response['latitude'].toString());
    final lng = double.tryParse(response['longitude'].toString());

    if (lat == null || lng == null) {
      print('Coordonnées client invalides');
      return;
    }

    setState(() {
      _clientLocation = LatLng(lat, lng);
      _markers.add(
        Marker(
          markerId: const MarkerId('client'),
          position: _clientLocation!,
          infoWindow: const InfoWindow(title: 'Client'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  void _processProfessionalResponse(Map<String, dynamic>? response) {
    if (response == null || response['latitude'] == null || response['longitude'] == null) {
      print('Réponse professionnel incomplète');
      return;
    }

    final lat = double.tryParse(response['latitude'].toString());
    final lng = double.tryParse(response['longitude'].toString());

    if (lat == null || lng == null) {
      print('Coordonnées professionnel invalides');
      return;
    }

    setState(() {
      _professionalLocation = LatLng(lat, lng);
      _markers.add(
        Marker(
          markerId: const MarkerId('professional'),
          position: _professionalLocation!,
          infoWindow: const InfoWindow(title: 'Prestataire'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  Future<void> _getPolyline() async {
    try {
      // 1. Créez un objet PolylineRequest
      final PolylineRequest request = PolylineRequest(
        origin: PointLatLng(_professionalLocation!.latitude, _professionalLocation!.longitude),
        destination: PointLatLng(_clientLocation!.latitude, _clientLocation!.longitude),
        mode: TravelMode.driving, // 'mode' remplace 'travelMode' ici
         // Votre clé API
      );

      // 2. Passez l'objet request à la méthode
      final result = await _polylinePoints.getRouteBetweenCoordinates(
        request: request, // Utilisez le paramètre nommé 'request'
        googleApiKey: 'AIzaSyCgnqFTts4IdXVmulti0NvaByi7ZzKL7xg',
      );

      if (result.points.isNotEmpty) {
        setState(() {
          _polylineCoordinates = result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: _polylineCoordinates,
              color: ColorsData.purple00A, // Assurez-vous que ColorsData est accessible
              width: 5,
            ),
          );
        });
      }
    } catch (e) {
      print('Erreur calcul itinéraire: $e');
    }
  }

  void _startLocationUpdates() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (widget.typeProfile == 'professionnel') {
        _updateProfessionalLocation();
      } else {
        _getLocations();
      }
    });
  }

  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken'); // Récupérer le token
  }

  Future<void> _updateProfessionalLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final token = await _getToken();
      final locationService = ProfessionalLocationService();
      print('professionnal position ${position}');
      await locationService.sendLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        token: token!,
      );
     /* await http.post(
        Uri.parse('http://${widget.baseUrl}:8000/api/update-location'),
        headers: {'Authorization': 'Bearer ${await _getToken()}'},
        body: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );*/
    } catch (e) {
      print('Erreur mise à jour position: $e');
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    print('typeprofile: ${widget.typeProfile}');
    _polylinePoints = PolylinePoints();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
       _initReverbService();
      await _fetchInitialAppointmentState();
      _startLocationUpdates();
    });
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  @override
  void dispose() {
    _appointmentService.disconnect();
    _stopCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Suivi du Rendez-vous')),
        appBar:  AppBar(
          toolbarHeight: 2.0,
        ),
      body: _appointmentData == null
      ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height *
                    0.20), // Ajoute du padding en bas
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustumAppBar(title: 'Suivi du Rendez-vous'),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black.withOpacity(0.13),
                              width: 1.5,
                            )
                        )
                    ),
                    child: Text(
                      'Rendez-vous N°${widget.appointmentId}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ColorsData.purple00A,
                        ),
                      ),
                    ),
                  ),
                  //Text(_statusMessage, style: TextStyle(color: _isConnected ? Colors.green : Colors.red)),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Etat du rendez-vous',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: ColorsData.purple00A,
                              ),
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2.0),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: getStatusConfig(_appointmentData!.status)['color'] ?? Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (getStatusConfig(_appointmentData!.status)['iconColor'] ?? Colors.grey).withOpacity(0.15),
                                  ),
                                  child: Icon(
                                    getStatusConfig(_appointmentData!.status)['icon'] ?? Icons.access_time,
                                    size: 30,
                                    color: getStatusConfig(_appointmentData!.status)['iconColor'] ?? Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  getStatusConfig(_appointmentData!.status)['label'] ?? '',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: getStatusConfig(_appointmentData!.status)['iconColor'] ?? Colors.grey,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black.withOpacity(0.13),
                                    width: 1.0,
                                  )
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                  _buildInfosListItems(
                    'Service demandé',
                    _serviceRequestData!.service!.label,
                    null,
                    null,
                    _serviceRequestData!.service!.imageUrl != null
                        ? 'http://${widget.baseUrl}:8000/api/${_serviceRequestData!.service!.imageUrl}'
                        : null,
                    null,
                  ),
                  _buildInfosListItems(
                    'Prestataire',
                    _serviceRequestData!.professional!.name,
                    null,
                    null,
                    null,
                    _serviceRequestData!.professional?.avatarUrl != null
                        ? 'http://${widget.baseUrl}:8000/api/${_serviceRequestData!.professional?.avatarUrl}'
                        : _serviceRequestData!.professional?.profile_photo_url,
                  ),
                  _buildInfosListItems(
                    'Client',
                    _serviceRequestData!.client!.name,
                    null,
                    null,
                    null,
                    _serviceRequestData!.client?.avatarUrl != null
                        ? 'http://${widget.baseUrl}:8000/api/${_serviceRequestData!.client?.avatarUrl}'
                        : _serviceRequestData!.client?.profile_photo_url,
                  ),
                  if (_appointmentData!.start_date != null)
                  _buildInfosListItems(
                    'Début du rendez-vous',
                    formatDate((_appointmentData!.start_date).toString()),
                    null,
                    Icons.more_time,
                    null,
                    null,
                  ) else
                    _buildInfosListItems(
                      'Début du rendez-vous',
                      'Le rendez-vous n\'a pas encore commencé',
                      null,
                      Icons.more_time,
                      null,
                      null,
                    ),
                  _buildInfosListItems(
                    'Temps restant',
                    '${_currentRemainingMinutes} minutes',
                    null,
                    Icons.timer,
                    null,
                    null,
                  ),
                  if (_appointmentData!.end_date != null)
                  _buildInfosListItems(
                    'Fin du rendez-vous',
                    formatDate((_appointmentData!.end_date).toString()) ?? 'Le rendez-vous n\'est pas terminé',
                    null,
                    Icons.access_time,
                    null,
                    null,
                  ) else
                    _buildInfosListItems(
                      'Fin du rendez-vous',
                      'Le rendez-vous n\'est pas terminé',
                      null,
                      Icons.access_time,
                      null,
                      null,
                    ),
                  /*const SizedBox(height: 10),
                  Text('${_appointmentData!.serviceRequest.service.label}'),
                  Text('Statut: ${_appointmentData!.status.toApiString().toUpperCase()}', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 5),
                  Text('Temps restant: ${_currentRemainingMinutes} minutes', style: Theme.of(context).textTheme.titleLarge),
                  */
                  const SizedBox(height: 30),
                  if (_clientLocation != null && widget.typeProfile == 'professionnel')
                    Container(
                      height: 300,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _clientLocation!,
                          zoom: 14,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        onMapCreated: (controller) {
                          setState(() {
                            _mapController = controller;
                          });
                        },
                      ),
                    ),
                  const SizedBox(height: 30),
                  if (!isProfessional && _appointmentData!.status == AppointmentStatus.completed || !isProfessional && _appointmentData!.status == AppointmentStatus.stopped)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {_showReviewForm(context);},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsData.purple00A,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        child: Text(
                            'Noter ce prestataire',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            )
                        ),
                      ),
                    ),
                  //const Spacer(),
                  Flexible(
                    fit: FlexFit.loose, // Permet au contenu de ne pas prendre TOUT l'espace restant s'il n'en a pas besoin
                    child: _buildActionButtons(),
                  )
                ],
              ),
            )
          ),
    );
  }

  /// Construit les boutons d'action en fonction du statut du rendez-vous.
  Widget _buildActionButtons() {
    if (_appointmentData == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isProfessional) ...[
          if (_appointmentData!.status == AppointmentStatus.planned)
            _buildActionButton(context, 'Démarrer le RDV', _startAppointment, Colors.green.shade900,),
          if (_appointmentData!.status == AppointmentStatus.started)
            _buildActionButton(context, 'Mettre en pause', _pauseAppointment, Color(0xFF43464C),),
          if (_appointmentData!.status == AppointmentStatus.paused)
            _buildActionButton(context, 'Reprendre', _resumeAppointment, Color(0xFF007DDD),),
        ],
        SizedBox(width: 10.0,),
        if (_appointmentData!.status == AppointmentStatus.started ||
            _appointmentData!.status == AppointmentStatus.paused ||
            _appointmentData!.status == AppointmentStatus.planned)
          _buildActionButton(context, 'Arrêter le RDV', _forceStopAppointment, Colors.red.shade700),
      ],
    );
  }

  Widget _buildInfosListItems(String title, String textBody, String? subtitle, IconData? icon, String? image, String? avatar){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: GoogleFonts.karla(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: ColorsData.purple00A,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Colors.black.withOpacity(0.13),
                      width: 1.0,
                    )
                )
            ),
            padding: EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                if (image != null)
                Container(
                  height: 80,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ) else if (icon != null)
                  Container(
                    child: Center(
                      child: Icon(
                        icon,
                        size: 40,
                        color: ColorsData.purple00A,
                      ),
                    ),
                  ) else if (avatar != null)
                    Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: NetworkImage(avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                    )
                else if (icon == null && image == null && avatar == null)
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage(AssetsData.noImage) as ImageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ) ,
                SizedBox(width: 5,),
                Expanded(
                  child: Text(
                    textBody,
                    //overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        //color: ColorsData.purple00A,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, AsyncCallback onPressed, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: SizedBox(
        //width: double.infinity,
        width: 150,
        //height: 50,
        child: ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Text("Traitement..."),
                      ],
                    ),
                  ),
                );
              },
            );
            await onPressed();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  // --- Appels API REST vers votre backend Laravel ---

  Future<void> _startAppointment() async {
    await _sendAppointmentAction('start');
  }

  Future<void> _pauseAppointment() async {
    await _sendAppointmentAction('pause');
  }

  Future<void> _resumeAppointment() async {
    await _sendAppointmentAction('resume');
  }

  Future<void> _forceStopAppointment() async {
    await _sendAppointmentAction('force-stop');
  }

  Future<void> _sendAppointmentAction(String action) async {
    try {
      final response = await http.post(
        Uri.parse('http://${widget.baseUrl}:8000/api/appointments/${widget.appointmentId}/$action'),
        headers: {
          'Authorization': 'Bearer ${widget.userToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('$action action successful');
      } else {
        final errorBody = jsonDecode(response.body);
        print('$action action failed: ${response.statusCode} - ${errorBody['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${errorBody['message'] ?? 'Action échouée'}')),
        );
      }
    } catch (e) {
      print('Network error for $action: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau: $e')),
      );
    }
  }

}