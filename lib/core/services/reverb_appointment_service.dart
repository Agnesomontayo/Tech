/*
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ReverbAppointmentService {
  final String baseUrl;
  final String token;
  final String appKey;
  final String userId;
  final bool debug;

  final void Function(Map<String, dynamic>) onAppointmentUpdate;
  final VoidCallback onConnected;
  final void Function(dynamic) onError;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  String? _socketId;

  ReverbAppointmentService({
    required this.baseUrl,
    required this.token,
    required this.appKey,
    required this.userId,
    required this.onAppointmentUpdate,
    required this.onConnected,
    required this.onError,
    this.debug = false,
  });

  Future<void> connect() async {
    try {
      final url = 'ws://$baseUrl:8080/app/$appKey';
      if (debug) print('[Appointment] Connecting to $url');

      _channel = WebSocketChannel.connect(Uri.parse(url));

      _subscription = _channel!.stream.listen(
        _handleIncomingMessage,
        onError: (error) {
          if (debug) print('[Appointment] WebSocket error: $error');
          onError(error);
          _reconnect();
        },
        onDone: _reconnect,
      );
    } catch (e) {
      if (debug) print('[Appointment] Connection error: $e');
      onError(e);
      _reconnect();
    }
  }

  void _handleIncomingMessage(dynamic message) {
    if (debug) print('[Appointment] Raw message: $message');

    try {
      final data = jsonDecode(message);

      // Gestion de la connexion
      if (data['event'] == 'pusher:connection_established') {
        _socketId = jsonDecode(data['data'])['socket_id'];
        if (debug) print('[Appointment] Connected. Socket ID: $_socketId');
        _authenticateAndSubscribe();
        onConnected();
      }
      // Gestion des événements RDV
      else if (data['event'] == 'App\\Events\\AppointmentUpdated' ||
          data['event'] == 'appointment.updated') {
        _handleAppointmentUpdate(data['data']);
      }
    } catch (e) {
      if (debug) print('[Appointment] Message processing error: $e');
      onError(e);
    }
  }

  void _handleAppointmentUpdate(dynamic updateData) {
    try {
      final data = updateData is String ? jsonDecode(updateData) : updateData;

      if (debug) print('[Appointment] Update received: $data');

      onAppointmentUpdate({
        'id': data['appointment']['id'],
        'action': data['action'],
        'status': data['appointment']['status'],
        'remaining_minutes': data['remaining_minutes'],
        'timestamp': data['timestamp'],
        'user_id': userId,
      });
    } catch (e) {
      if (debug) print('[Appointment] Update processing error: $e');
      onError(e);
    }
  }

  Future<void> _authenticateAndSubscribe() async {
    try {
      final channel = 'private-appointment.$userId';
      final auth = await _authenticate(_socketId!, channel);

      if (auth != null) {
        _subscribe(channel, auth);

        _subscribe('presence-appointment.updates', auth);
      }
    } catch (e) {
      onError(e);
    }
  }

  Future<String?> _authenticate(String socketId, String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('http://$baseUrl:8000/broadcasting/auth'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'socket_id': socketId,
          'channel_name': channelName,
        }),
      );

      if (response.statusCode == 200) {
        if (debug) print('Authentifié avec succès');
        return jsonDecode(response.body)['auth'];
      } else {
        if (debug) print('Échec authentification: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      onError(e);
      return null;
    }
  }

  void _subscribe(String channelName, String auth) {
    final subscriptionPayload = {
      'event': 'pusher:subscribe',
      'data': {
        'channel': channelName,
        'auth': auth,
      }
    };
    _channel?.sink.add(jsonEncode(subscriptionPayload));
    if (debug) print('Souscription envoyée pour $channelName');
  }

  void _reconnect() {
    if (debug) print('Tentative de reconnexion...');
    Timer(Duration(seconds: 5), () => connect());
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    if (debug) print('Déconnecté du serveur Reverb');
  }

}*/


import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

class ReverbAppointmentService {
  final String baseUrl;
  final String token;
  final String appKey;
  final int appointmentId;
  final int userId;

  final void Function(Map<String, dynamic>) onAppointmentUpdate;
  final VoidCallback onConnected;
  final void Function(dynamic, [StackTrace?]) onError;
  final VoidCallback onDisconnected;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  String? _socketId;

  int _reconnectAttempt = 0;
  Timer? _reconnectTimer;
  static const int _maxReconnectDelaySeconds = 60;

  ReverbAppointmentService({
    required this.baseUrl,
    required this.token,
    required this.appKey,
    required this.appointmentId,
    required this.userId,
    required this.onAppointmentUpdate,
    required this.onConnected,
    required this.onError,
    required this.onDisconnected,
  });

  Future<void> connect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      final wsUrl = 'ws://$baseUrl:8080/app/$appKey';
      _log('[Appointment] Connecting to $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _handleIncomingMessage,
        onError: (error, stackTrace) {
          _log('[Appointment] WebSocket error: $error\n$stackTrace');
          onError(error, stackTrace);
          _scheduleReconnect();
        },
        onDone: () {
          _log('[Appointment] WebSocket disconnected.');
          onDisconnected();
          _scheduleReconnect();
        },
      );
    } catch (e, st) {
      _log('[Appointment] Initial connection error: $e\n$st');
      onError(e, st);
      _scheduleReconnect();
    }
  }

  void _handleIncomingMessage(dynamic message) {
    _log('[Appointment] Raw message: $message');

    try {
      final data = jsonDecode(message);

      if (data['event'] == 'pusher:connection_established')  {
        _socketId = jsonDecode(data['data'])['socket_id'];
        _log('[Appointment] Connected. Socket ID: $_socketId');
        _reconnectAttempt = 0; // Réinitialise les tentatives de reconnexion après succès
        _authenticateAndSubscribe();
        onConnected();
      }
      // Utilisation du nom de l'événement défini dans broadcastAs()
      else if (data['event'] == 'appointment.updated') {
        _handleAppointmentUpdate(data['data']);
      }

      else if (data['event'] == 'pusher:error') {
        _log('[Appointment] Pusher error: ${data['data']}');
        onError('Pusher error: ${data['data']}');
      }
    } catch (e, st) {
      _log('[Appointment] Message processing error: $e\n$st');
      onError(e, st);
    }
  }

  /// Traite les données d'un événement de mise à jour de rendez-vous.
  void _handleAppointmentUpdate(dynamic updateData) {
    try {
      // Les données peuvent déjà être un Map si elles sont passées directement par Reverb.
      // Si c'est une chaîne JSON, il faut la décoder.
      final Map<String, dynamic> data = updateData is String ? jsonDecode(updateData) : updateData;

      _log('[Appointment] Update received: $data');

      onAppointmentUpdate({
        'id': data['appointment']?['id'], // Utilisation de l'opérateur null-safe
        'action': data['action'],
        'status': data['appointment']?['status'],
        'remaining_minutes': data['remaining_minutes'],
        'timestamp': data['timestamp'],
        'user_id': userId, // L'ID de l'utilisateur courant, pas l'ID de l'utilisateur de l'update
      });
    } catch (e, st) {
      _log('[Appointment] Update processing error: $e\n$st');
      onError(e, st);
    }
  }

  /// Authentifie le socket et s'abonne aux canaux.
  Future<void> _authenticateAndSubscribe() async {
    if (_socketId == null) {
      _log('[Appointment] Socket ID is null, cannot authenticate.');
      onError('Socket ID is null, cannot authenticate.');
      return;
    }

    try {
      final privateChannelName = 'private-appointment.${appointmentId}'; // CHANGÉ !
      final privateAuth = await _authenticate(_socketId!, privateChannelName);
      if (privateAuth != null) {
        _subscribe(privateChannelName, privateAuth);
      } else {
        _log('Failed to authenticate for $privateChannelName');
      }

      /*final presenceChannelName = 'presence.appointment.${appointmentId}';
      final presenceAuth = await _authenticate(_socketId!, presenceChannelName);
      if (presenceAuth != null) {
        _subscribe(presenceChannelName, presenceAuth);
      } else {
        _log('Failed to authenticate for $presenceChannelName');
      }*/
    } catch (e, st) {
      _log('[Appointment] Authentication and subscription error: $e\n$st');
      onError(e, st);
    }
  }


  Future<String?> _authenticate(String socketId, String channelName) async {
    try {
      final authUrl = 'http://$baseUrl:8000/broadcasting/auth'; // Utiliser le chemin API si vous avez des guards 'api'
      _log('[Appointment] Authenticating for $channelName with $socketId');
      final response = await http.post(
        Uri.parse(authUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'socket_id': socketId,
          'channel_name': channelName,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        _log('[Appointment] Authentication successful for $channelName.');
        return jsonDecode(response.body)['auth'];
      } else {
        _log('[Appointment] Authentication failed (${response.statusCode}) for $channelName: ${response.body}');
        onError('Authentication failed: ${response.body}', StackTrace.current); // Inclure le corps de la réponse en cas d'erreur
        return null;
      }
    } on TimeoutException {
      _log('[Appointment] Authentication timed out for $channelName.');
      onError('Authentication timed out for $channelName.', StackTrace.current);
      return null;
    } catch (e, st) {
      _log('[Appointment] Authentication request error for $channelName: $e\n$st');
      onError(e, st);
      return null;
    }
  }

  /// Envoie un message de souscription au serveur WebSocket.
  void _subscribe(String channelName, String auth) {
    final subscriptionPayload = {
      'event': 'pusher:subscribe',
      'data': {
        'channel': channelName,
        'auth': auth,
      }
    };
    _channel?.sink.add(jsonEncode(subscriptionPayload));
    _log('[Appointment] Subscription sent for $channelName');
  }

  /// Planifie une reconnexion avec un délai exponentiel.
  void _scheduleReconnect() {
    _reconnectAttempt++;
    final delay = Duration(seconds: (2 * _reconnectAttempt).clamp(1, _maxReconnectDelaySeconds));
    _log('[Appointment] Scheduling reconnect in ${delay.inSeconds} seconds (attempt $_reconnectAttempt).');
    _reconnectTimer = Timer(delay, () => connect());
  }

  /// Déconnecte le service WebSocket.
  Future<void> disconnect() async {
    _reconnectTimer?.cancel(); // Annuler toute reconnexion planifiée
    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _subscription = null;
    _log('[Appointment] Disconnected from Reverb server.');
    onDisconnected(); // Appeler le callback de déconnexion lors d'un disconnect manuel
  }

  // Fonction utilitaire pour le logging conditionnel
  void _log(String message) {
    if (kDebugMode) { // Utilisez kDebugMode pour un contrôle en production
      print(message);
    }
  }
}
