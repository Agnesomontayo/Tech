import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tech/screens/professionnel/professionnel_home/professional_chat_page.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';

class ChatButtonWidget extends StatefulWidget {
  final String currentUserProfileImage;
  final int currentUserId;
  final String typeProfile;
  const ChatButtonWidget({
    super.key,
    required this.currentUserProfileImage,
    required this.currentUserId,
    required this.typeProfile,
  });

  @override
  State<ChatButtonWidget> createState() => _ChatButtonWidgetState();
}

class _ChatButtonWidgetState extends State<ChatButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 100.0),
        child: FloatingActionButton(
            backgroundColor: ColorsData.purple00A,
            shape: CircleBorder(),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfessionalChatPage(
                      currentUserProfileImage: widget.currentUserProfileImage,
                      currentUserId: widget.currentUserId,
                      typeProfil: widget.typeProfile,
                    )),
              ),
            },
            child: SvgPicture.asset(
                AssetsData.chatIcon
            )
        )
    );
  }
}
