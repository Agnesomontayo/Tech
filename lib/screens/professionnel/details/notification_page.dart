import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/ProfessionnalNotificationCard.dart';

class WorkNotificationPage extends StatefulWidget {
  const WorkNotificationPage({super.key});

  @override
  State<WorkNotificationPage> createState() => _WorkNotificationPageState();
}

class _WorkNotificationPageState extends State<WorkNotificationPage> {
  void handleDecision(int index, String decision) {
    print("Disponible $decision");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5.0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return ProfessionalNotificationCard(
                  onDecision: (decision) => handleDecision(index, decision),
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
      ),
    );
  }
}
