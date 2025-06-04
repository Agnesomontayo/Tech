import 'package:flutter/cupertino.dart';

class ChatMessage{
  final int id;
  String content;
  final String senderType;
  final String businessType;
  ChatMessage({
    this.id = 0,
    required this.content,
    required this.senderType,
    this.businessType = 'text',
  });
}
