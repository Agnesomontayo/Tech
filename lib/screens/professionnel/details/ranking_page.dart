import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/RankingProfessionnalCard.dart';

import '../../../core/const/assets.dart';
import '../widgets/HistoryClientCardWidget.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
                children: [
                  RankingProfessionalCard(
                    name: 'Abraham Monie $index',
                    imagePath: AssetsData.best,
                    rank: 3,
                    rate: 4.0,
                  ),
                  if (index < 19)
                    Divider(height: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                ],
              );
            },
            childCount: 20,
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
