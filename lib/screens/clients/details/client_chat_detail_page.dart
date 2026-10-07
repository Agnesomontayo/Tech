/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech/core/const/colors.dart';

import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/services/reverb_service.dart';
import 'package:provider/provider.dart';

class ClientChatDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final int userId;
  final int currentUserId;
  final String? messageText;
  final String? time;

  const ClientChatDetailPage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.userId,
    required this.currentUserId,
    this.messageText,
    this.time,
  });

  @override
  State<ClientChatDetailPage> createState() => _ClientChatDetailPageState();
}

class _ClientChatDetailPageState extends State<ClientChatDetailPage> {
  late ReverbChatService _chatService;
  List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;

  @override
  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken');
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    //_chatService.disconnect();
    super.dispose();
  }

  Future<void> _init() async {
    final url = await ApiHelper.getUrl();
    final token = await getToken();

    if (token == null) {
      print("Aucun token trouvé");
      return;
    }

    _chatService = ReverbChatService(
      baseUrl: url,
      token: token,
      appKey: 'pu8fzsphp4gk5znq6ybs',
      userId: widget.currentUserId,
      debug: true,
      onMessageReceived: (data) {
        if (!mounted) return;

        if (data['type'] == 'typing') {
          setState(() => isTyping = true);
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) setState(() => isTyping = false);
          });
        } else if (data['sender_id'] == widget.userId) {
          setState(() {
            final content = data['content'] is String
                ? data['content']
                : jsonEncode(data['content']);
            messages.add(ChatMessage(
              content: content,
              senderType: 'receiver',
              businessType: data['type'] ?? 'text',
            ));
            isTyping = false;
          });
          _scrollToBottom();
        }
      },
      onConnectionEstablished: () => print('Connecté à Reverb'),
      onError: (e) => print('Erreur : $e'),
    );

    _chatService.connect();
    _loadChatHistory();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _loadChatHistory() async {
    try {
      final history = await _chatService.fetchChatHistory(widget.userId);
      setState(() {
        messages = history.map((msg) {
          return ChatMessage(
            content: msg['content'],
            senderType: msg['sender_id'] == widget.currentUserId
                ? 'sender'
                : 'receiver',
            businessType: msg['type'] ?? 'text',
          );
        }).toList();
        _scrollToBottom();
      });
    } catch (e) {
      print('Erreur lors du chargement du chat : $e');
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        content: text,
        senderType: 'sender',
        businessType: 'text',
      ));
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      await _chatService.sendMessage(
        receiverId: widget.userId,
        text: text,
      );
    } catch (e) {
      print('Erreur d\'envoi : $e');
    }
  }

  void _handleAcceptRequest(ChatMessage message) {
    // À compléter : logique d'acceptation
    print('Demande acceptée : ${message.content}');
  }

  void _handleRefuseRequest(ChatMessage message) {
    // À compléter : logique de refus
    print('Demande refusée : ${message.content}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(width: 2),
                CircleAvatar(
                  backgroundImage: widget.imageUrl != null
                      ? NetworkImage(widget.imageUrl)
                      : AssetImage(AssetsData.best) as ImageProvider,
                  maxRadius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 6),
                      Text("Online",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.settings, color: Colors.black54),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            controller: _scrollController,
            itemCount: messages.length + (isTyping ? 1 : 0),
            padding: EdgeInsets.only(top: 10, bottom: 80),
            itemBuilder: (context, index) {
              if (isTyping && index == messages.length) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "${widget.name} écrit...",
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ),
                );
              }

              final message = messages[index];
              final isReceiver = message.senderType == 'receiver';

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Align(
                  alignment:
                      isReceiver ? Alignment.topLeft : Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: isReceiver
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isReceiver
                                ? Colors.grey.shade200
                                : ColorsData.purple260,
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                message.content,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              if (message.businessType == 'add_service_request' &&
                                  message.senderType == 'receiver')
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            _handleAcceptRequest(message),
                                        child: Text('Accepter'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade900,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _handleRefuseRequest(message),
                                        child: Text('Refuser'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade700,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 40),
              padding:
                  EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: ColorsData.purple00A,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Écris ton message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    child: Icon(Icons.send, color: Colors.white, size: 18),
                    backgroundColor: ColorsData.purple00A,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
