import 'package:flutter/material.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/professionnel/widgets/HistoryClientCardWidget.dart';
import 'package:tech/screens/professionnel/widgets/clientCard.dart';

import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../clients/widgets/WorkerPresentationCard.dart';
import 'package:provider/provider.dart';

class ClientPage extends StatefulWidget {
  final int professionalId;
  const ClientPage({
    super.key,
    required this.professionalId,
  });

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  List<dynamic> clients = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      await _fetchClients();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchClients() async {
    try {
      final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final data = await professionalProvider.getClientsByProfessional(widget.professionalId);
      setState(() {
        clients = data['clients'];
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
    final actualClients = clients;
   if (_isLoading)
    return const Center(child: CircularProgressIndicator());
    if (actualClients.isEmpty) {
      return Center(
        child: Text('Aucune interaction trouvée 😢'),
      );
    }
    return  CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final client = actualClients[index];
                return Column(
                  children: [
                    Clientcard(
                        name: client['name'],
                        imagePath: client['avatar'] != null && client['avatar'].toString().isNotEmpty
                            ? '${baseImageUrl}/${client['avatar']}'
                            : client['profile_photo_url'],
                        phoneNumber: client['phone'],
                        clientId: client['client_id'],
                        professionalId: widget.professionalId
                    ),
                    if (index < actualClients.length-1)
                      Divider(height: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                  ],
                )
                  /*HistoryClientCard(
                  name: 'Abraham Monie $index',
                  imagePath: AssetsData.best,
                  service: 'Débouchage évier jjkvvjlkjlslfjbmbhbkn',
                  date: '20/01/2025',
                  hour: '09:55',
                )*/;
              },
              childCount: actualClients.length,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height *
                    0.20), // Ajoute du padding en bas
          ),
        ],
      );
  }
}
