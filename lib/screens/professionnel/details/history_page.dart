import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/HistoryClientCardWidget.dart';

import '../../../core/const/assets.dart';
import '../../clients/widgets/WorkerPresentationCard.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return  CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return HistoryClientCard(
                  name: 'Abraham Monie $index',
                  imagePath: AssetsData.best,
                  service: 'Débouchage évier jjkvvjlkjlslfjbmbhbkn',
                  date: '20/01/2025',
                  hour: '09:55',
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
