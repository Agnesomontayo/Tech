import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ReverbChatService {
  final String baseUrl;
  final String token;
  final String appKey;
  final int userId;
  final bool debug;

  late WebSocketChannel _channel;
  late StreamSubscription _subscription;
  late String _socketId;

  final Function(Map<String, dynamic>) onMessageReceived;
  final Function() onConnectionEstablished;
  final Function(dynamic) onError;

  ReverbChatService({
    required this.baseUrl,
    required this.token,
    required this.appKey,
    required this.userId,
    required this.onMessageReceived,
    required this.onConnectionEstablished,
    required this.onError,
    this.debug = false,
  });

  Future<void> connect() async {
    try {
      final url = 'ws://$baseUrl:8080/app/$appKey';
      print('Tentative de connexion à $url');
      if (debug) print('Connexion à $url');

      _channel = WebSocketChannel.connect(Uri.parse(url));

      _subscription = _channel.stream.listen(
        _handleIncomingMessage,
        onError: onError,
        onDone: _reconnect,
      );
      print('Abonnement au flux WebSocket fait');
    } catch (e) {
      print(' Erreur lors de la connexion WebSocket: $e');
      onError(e);
    }
  }

  void _handleIncomingMessage(dynamic message) {
    if (debug) print('Message brut reçu: $message');

    try {
      final data = jsonDecode(message);
      if (debug) print('Message décodé: $data');

      if (data['event'] == 'pusher:connection_established') {
        print('Connexion établie');
        _socketId = jsonDecode(data['data'])['socket_id'];
        print('Socket ID: $_socketId');
        _authenticateAndSubscribe();
        onConnectionEstablished();
      }else if (data['event'] == 'message.updated') {
        final messageData = data['data'] ?? data;
        _handleMessageUpdate(messageData is String ? jsonDecode(messageData) : messageData);
      }/*else if (data['event'] == 'message.updated') {
        final messageData = data['data'];
        Map<String, dynamic> parsedMessageData;

        if (messageData is String) {
          parsedMessageData = jsonDecode(messageData);
        } else if (messageData is Map) {
          parsedMessageData = Map<String, dynamic>.from(messageData);
        } else {
          print('Données inattendues dans message.updated: $messageData');
          return;
        }

        _handleMessageUpdate(parsedMessageData);
      }*/
      else if ((data['event'] as String).startsWith('App\\Events\\')) {
        final eventData = data['data'];
        Map<String, dynamic> parsedData;

        // Décodage correct
        if (eventData is String) {
          parsedData = jsonDecode(eventData);
        } else if (eventData is Map) {
          parsedData = Map<String, dynamic>.from(eventData);
        } else {
          print('Données inattendues: $eventData');
          return;
        }

        if (parsedData['type'] == 'add_service_request' || parsedData['type'] == 'update_status_service_request') {
          print('Mise à jour de la demande reçue !');
          _handleServiceRequest(parsedData);
        } else {
          // Message classique
          onMessageReceived(parsedData);
        }
      } else {
        print('Événement non géré: ${data['event']}');
      }
    } catch (e) {
      print('Erreur de traitement du message: $e');
    }
  }

  void _handleMessageUpdate(Map<String, dynamic> updateData) {
    if (debug) print('Données brutes dans _handleMessageUpdate : $updateData (${updateData.runtimeType})');

    dynamic messageData = updateData.containsKey('data') ? updateData['data'] : updateData;
    if (messageData is String) {
      try {
        messageData = jsonDecode(messageData);
      } catch (e) {
        print('Erreur JSON decode dans _handleMessageUpdate: $e');
        return;
      }
    }

    if (messageData is! Map<String, dynamic>) {
      print('Format inattendu pour messageData dans _handleMessageUpdate : $messageData');
      return;
    }

    final processedData = Map<String, dynamic>.from(messageData);

    if (debug) print('Mise à jour de message: $processedData');

    if (processedData['type'] == 'update_status_service_request') {
      _handleServiceRequest(processedData);
    } else {
      onMessageReceived({
        ...processedData,
        'is_update': true,
      });
    }
  }

  /*void _handleServiceRequest(Map<String, dynamic> requestData) {
    if (debug) print('Demande de service reçue: $requestData');

    // Standardisation du format
    final content = requestData['content'] is String
        ? jsonDecode(requestData['content'])
        : requestData['content'];

    onMessageReceived({
      'id': requestData['id'],
      'type': requestData['type'],
      'sender_id': requestData['sender_id'],
      'content': jsonEncode(content),//content,
      'status': content['status'],
      'updated_at': requestData['updated_at'],
    });
  }*/
  void _handleServiceRequest(Map<String, dynamic> requestData) {
    if (debug) print('Demande de service reçue: $requestData');

    final content = requestData['content'] is String
        ? jsonDecode(requestData['content'])
        : requestData['content'];

    onMessageReceived({
      'id': requestData['id'],
      'type': requestData['type'],
      'sender_id': requestData['sender_id'],
      'content': jsonEncode(content),
      'status': content['status'],
      'updated_at': requestData['updated_at'],
      'is_update': requestData['is_update'] ?? false,
      'is_new': requestData['is_new'] ?? true,
      'is_service_request': true,
    });
  }

  Future<void> _authenticateAndSubscribe() async {
    try {
      final channel = 'private-chat.$userId';
      final auth = await _authenticate(_socketId, channel);
      if (auth != null) {
        _subscribe(channel, auth);
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
    _channel.sink.add(jsonEncode(subscriptionPayload));
    if (debug) print('Souscription envoyée pour $channelName');
  }

  void _reconnect() {
    if (debug) print('Tentative de reconnexion...');
    Timer(Duration(seconds: 5), () => connect());
  }

  Future<void> disconnect() async {
    await _subscription.cancel();
    await _channel.sink.close();
    if (debug) print('Déconnecté du serveur Reverb');
  }

  Future<bool> sendMessage({
    required int receiverId,
    required String text,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://$baseUrl:8000/api/messages/$receiverId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'sender_id': userId,
          'receiver_id': receiverId,
          'content': text,
          'type': 'text'
        }),
      );

      if (response.statusCode == 200) {
        if (debug) print('Message envoyé');
        return true;
      } else {
        if (debug) print('Erreur message: ${response.body}');
        return false;
      }
    } catch (e) {
      onError(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchChatHistory(int receiverId) async {
    final response = await http.get(
      Uri.parse('http://$baseUrl:8000/api/messages/$receiverId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Réponse status: ${response.statusCode}');
    print('Réponse body: ${response.body}');
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Erreur lors du chargement des messages');
    }
  }

}
