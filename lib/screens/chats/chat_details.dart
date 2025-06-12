import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/chats/chat_widgets/new_request_message_card.dart';

import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/models/chat_message.dart';
import '../../../core/services/reverb_service.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final int userId;
  final int currentUserId;
  final String currentUserProfileImage;
  final String? messageText;
  final String? time;
  final String typeProfil;

  const ChatDetailPage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.userId,
    required this.currentUserId,
    required this.currentUserProfileImage,
    this.messageText,
    this.time,
    required this.typeProfil,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
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
   // _scrollController.dispose();
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

        // Typing indicator
        if (data['type'] == 'typing') {
          setState(() => isTyping = true);
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) setState(() => isTyping = false);
          });
          return;
        }

        setState(() {
          // Service Request Update Logic
          if (data['is_service_request'] == true) {
            _handleServiceRequestUpdate(data);
          }
          // Regular Message Logic
          else {
            _handleRegularMessage(data);
          }
        });
      },
      onConnectionEstablished: () => print('Connecté à Reverb'),
      onError: (e) => print('Erreur : $e'),
    );

    _chatService.connect();
    _loadChatHistory();
  }

  void _handleServiceRequestUpdate(Map<String, dynamic> data) {
    final messageId = data['id'];
    final index = messages.indexWhere((m) => m.id == messageId);

    final newMessage = ChatMessage(
      id: messageId,
      content: data['content'],
      senderType: data['sender_id'] == widget.currentUserId ? 'sender' : 'receiver',
      businessType: data['type'],
    );

    if (index != -1) {
      messages[index] = newMessage;
    } else if (data['is_new'] == true) {
      messages.add(newMessage);
    }
  }

  void _handleRegularMessage(Map<String, dynamic> data) {
    if (data['sender_id'] == widget.userId) {
      messages.add(ChatMessage(
        id: data['id'],
        content: data['content'] is String ? data['content'] : jsonEncode(
            data['content']),
        senderType: 'receiver',
        businessType: data['type'] ?? 'text',
      ));
    }
  }
  /*void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }*/

  void _loadChatHistory() async {
    try {
      final history = await _chatService.fetchChatHistory(widget.userId);
      setState(() {
        messages = history.map((msg) {
          return ChatMessage(
            id: msg['id'],
            content: msg['content'],
            senderType: msg['sender_id'] == widget.currentUserId
                ? 'sender'
                : 'receiver',
            businessType: msg['type'] ?? 'text',
          );
        }).toList();
        //_scrollToBottom();
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

   // _scrollToBottom();

    try {
      await _chatService.sendMessage(
        receiverId: widget.userId,
        text: text,
      );
    } catch (e) {
      print('Erreur d\'envoi : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          Positioned.fill (
            child: ListView.builder(
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
                if (message.businessType == 'add_service_request' || message.businessType == 'update_status_service_request' ){
                  return NewRequestMessageCard(
                    key: ValueKey(message.id),
                    isReceiver: isReceiver,
                    content: message.content,
                    senderType: message.senderType,
                    businessType: message.businessType,
                    currentUserProfileImage: widget.currentUserProfileImage,
                    messageBody: message,
                    currentUserId: widget.currentUserId,
                    typeProfil: widget.typeProfil,
                  );
                }
                else {
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
                                  /*Padding(
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
                                ),*/

                                ],
                              )),
                        ],
                      ),
                    ),
                  );}

              },
            ),
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
