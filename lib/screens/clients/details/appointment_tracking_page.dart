import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tech/screens/clients/client_forms/review_form.dart';
import 'dart:convert';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/models/appointment.dart';
import '../../../core/models/service.dart';
import '../../../core/services/reverb_appointment_service.dart';
import '../widgets/CustumAppBar.dart';

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
        print('data ${data}');
        setState(() {
          _appointmentData = AppointmentDisplayData.fromJson(data);
          _serviceRequestData = ServiceRequestDisplayData.fromJson(data['service_request']);
          print('_appointmentData ${_appointmentData}');
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
  }

  /// Gère les mises à jour de rendez-vous reçues via Reverb.

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
  /// Callback lorsque Reverb est connecté.
  void _handleReverbConnected() {
    if (!mounted) return;
    setState(() {
      _isConnected = true;
      _statusMessage = 'Connecté aux mises à jour en temps réel.';
    });
    print('Connected to appointment updates');
  }

  /// Callback en cas d'erreur Reverb.
  void _handleReverbError(dynamic error, [StackTrace? stackTrace]) {
    if (!mounted) return;
    setState(() {
      _isConnected = false;
      _statusMessage = 'Erreur de connexion en temps réel: $error';
    });
    print('Appointment update error: $error\n$stackTrace');
  }

  /// Callback lorsque Reverb est déconnecté.
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
    //_stopCountdown();
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

  @override
  void initState() {
    super.initState();
    print('typeprofile: ${widget.typeProfile}');
    _initReverbService();
    _fetchInitialAppointmentState();
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
                                  height: 40,
                                  width: 40,
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
                  _buildInfosListItems(
                    'Temps restant',
                    '${_currentRemainingMinutes} minutes',
                    null,
                    Icons.timer,
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
                  if (!isProfessional && _appointmentData!.status == AppointmentStatus.completed || _appointmentData!.status == AppointmentStatus.stopped)
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
                  height: 90,
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
                        height: 80,
                        width: 80,
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

  void _submitReview(double rating, String comment) {
    print('Review submitted: Rating: $rating, Comment: $comment');
  }
}