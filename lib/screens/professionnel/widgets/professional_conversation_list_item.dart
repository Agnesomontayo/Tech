import 'package:flutter/material.dart';

import '../../../core/const/assets.dart';
import '../../chats/chat_details.dart';
import '../details/professional_chat_detail_page.dart';

class ProfessionalConversationListItem extends StatefulWidget {
  final int userId;
  final int currentUserId;
  final String name;
  final String messageText;
  final String imageUrl;
  final String time;
  final bool isMessageRead;
  final String currentUserProfileImage;
  const ProfessionalConversationListItem({
    super.key,
    required this.userId,
    required this.currentUserId,
    required this.name,
    required this.messageText,
    required this.imageUrl,
    required this.time,
    required this.isMessageRead,
    required this.currentUserProfileImage,
  });

  @override
  State<ProfessionalConversationListItem> createState() => _ProfessionalConversationListItemState();
}

class _ProfessionalConversationListItemState extends State<ProfessionalConversationListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              currentUserId: widget.currentUserId,
              userId: widget.userId,
              name: widget.name,
              imageUrl: widget.imageUrl,
              messageText: widget.messageText,
              time: widget.time,
              //isMessageRead: widget.isMessageRead,
              currentUserProfileImage: widget.currentUserProfileImage,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: widget.imageUrl != null
                  ? NetworkImage(widget.imageUrl)
                  : AssetImage(AssetsData.best) as ImageProvider,
              maxRadius: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.name, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                      widget.messageText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
