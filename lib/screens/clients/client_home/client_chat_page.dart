import 'package:flutter/material.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/clients/widgets/client_conversation_list_item.dart';

import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/models/professionel.dart';
import 'package:provider/provider.dart';

class ClientChatPage extends StatefulWidget {
  final int currentUserId;
  final String currentUserProfileImage;
  final String typeProfile;
  const ClientChatPage({
    super.key,
    required this.currentUserId,
    required this.currentUserProfileImage,
    required this.typeProfile,
  });

  @override
  State<ClientChatPage> createState() => _ClientChatPageState();
}

class _ClientChatPageState extends State<ClientChatPage> {
  List<dynamic> chatProfessionals = [];
 // int? currentUserId;
  //List<dynamic> services = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchProfessionals();
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProfessionals() async {
    try {
      final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final data = await professionalProvider.getClientRequestedProfessionalsList(widget.currentUserId);
      setState(() {
        chatProfessionals = data;
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInfos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Conversations",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,
                      color: Colors.grey.shade600, size: 20),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
              ),
            ),*/
            ListView.builder(
              itemCount: chatProfessionals.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final professional = chatProfessionals[index];
                return ClientConversationListItem(
                  currentUserId: widget.currentUserId ?? 0,
                  currentUserProfileImage: widget.currentUserProfileImage,
                  typeProfile: widget.typeProfile,
                  userId: professional['user']['id'],
                  name: professional['user']['lastName'] + ' ' + professional['user']['firstName'],
                  messageText: '',//chatProfessionals[index].messageText ?? '',
                  imageUrl: professional['user']['avatar'] != null
                      ? baseImageUrl + '/' + professional['user']['avatar']
                      : professional['user']['profile_photo_url'],
                  time: '',//chatProfessionals[index].time ?? '',
                  isMessageRead: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
