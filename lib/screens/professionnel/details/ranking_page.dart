import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/RankingProfessionnalCard.dart';

import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/professionnal_provider.dart';
import '../widgets/HistoryClientCardWidget.dart';
import 'package:provider/provider.dart';

class RankingPage extends StatefulWidget {
  final int professionId;
  const RankingPage({
    super.key,
    required this.professionId,
  });

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<dynamic> professionals = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      await _fetchProfessionals();
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

  Future<void> _fetchProfessionals() async {
    try {
      final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final data = await professionalProvider.getGlobalRankingProfessionalByProfession(widget.professionId);
      setState(() {
        professionals = data;
        //_isLoading = false;
      });
      print('Données appointments ${professionals}');
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
    if (_isLoading)
      return const Center(child: CircularProgressIndicator());
    if (professionals.isEmpty) {
      return Center(
        child: Text('Aucune interaction trouvée 😢'),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final professional = professionals[index];
              return Column(
                children: [
                  RankingProfessionalCard(
                    name: professional['user']['lastName']+' '+professional['user']['firstName'],
                    imagePath: professional['user']['avatar'] != null && professional['user']['avatar'].toString().isNotEmpty
                              ? '${baseImageUrl}/${professional['user']['avatar']}' : professional['user']['profile_photo_url'],
                    rank: professional['rank'],
                    rate: (professional['review_avg_rate'] ?? 0).toDouble(),
                  ),
                  if (index < professionals.length-1)
                    Divider(height: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                ],
              );
            },
            childCount: professionals.length,
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
