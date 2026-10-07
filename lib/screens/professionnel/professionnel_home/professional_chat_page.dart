import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/client_provider.dart';
import '../widgets/professional_conversation_list_item.dart';

class ProfessionalChatPage extends StatefulWidget {
  final int currentUserId;
  final String currentUserProfileImage;
  final String typeProfil;
  const ProfessionalChatPage({
    super.key,
    required this.currentUserId,
    required this.currentUserProfileImage,
    required this.typeProfil,
  });

  @override
  State<ProfessionalChatPage> createState() => _ProfessionalChatPageState();
}

class _ProfessionalChatPageState extends State<ProfessionalChatPage> {
  List<dynamic> chatClients = [];
  // int? currentUserId;
  //List<dynamic> services = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchClients();
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchClients() async {
    try {
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      final data = await clientProvider.getClientRequestedProfessionalsList(widget.currentUserId);
      setState(() {
        chatClients = data;
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
        fontSize: 25, fontWeight: FontWeight.bold)
    )
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
              itemCount: chatClients.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final client = chatClients[index];
                return ProfessionalConversationListItem(
                  currentUserId: widget.currentUserId ?? 0,
                  userId: client['user']['id'],
                  name: client['user']['lastName'] + ' ' + client['user']['firstName'],
                  messageText: '',//chatClients[index].messageText ?? '',
                  imageUrl: client['user']['avatar'] != null
                      ? baseImageUrl + '/' + client['user']['avatar']
                      : client['user']['profile_photo_url'],
                  time: '',//chatClients[index].time ?? '',
                  currentUserProfileImage: widget.currentUserProfileImage,
                  isMessageRead: false,
                  typeProfil: widget.typeProfil,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

