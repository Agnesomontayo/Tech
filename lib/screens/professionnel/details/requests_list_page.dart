import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/RequestCard.dart';

import '../../../core/const/assets.dart';
import '../widgets/HistoryClientCardWidget.dart';

class WorkRequestLists extends StatefulWidget {
  const WorkRequestLists({super.key});

  @override
  State<WorkRequestLists> createState() => _WorkRequestListsState();
}

class _WorkRequestListsState extends State<WorkRequestLists> {
  List<Map<String, String>> requests = [
    {"name": "Jean Dupont", "imagePath": AssetsData.best, "service": "Plombier disponible"},
    {"name": "Alice Martin", "imagePath": AssetsData.best, "service": "Électricienne"},
    {"name": "David Noel", "imagePath": AssetsData.best, "service": "Menuisier"},
  ];

  void handleDecision(int index, String decision) {
    print("Demande ${requests[index]["name"]} -> $decision");
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return RequestCard(
                name: requests[index]["name"]!,
                imagePath: requests[index]["imagePath"]!,
                service: requests[index]["service"]!,
                onDecision: (decision) => handleDecision(index, decision),
              );
            },
            childCount: requests.length,
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
