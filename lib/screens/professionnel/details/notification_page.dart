import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/ProfessionnalNotificationCard.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/notification_provider.dart';
import '../../../core/utils/func.dart';
import 'notification_frequency_settings.dart';

class WorkNotificationPage extends StatefulWidget {
  final int professionId;
  final String currentFrequency;
  const WorkNotificationPage({
    super.key,
    required this.professionId,
    required this.currentFrequency,
  });

  @override
  State<WorkNotificationPage> createState() => _WorkNotificationPageState();
}

class _WorkNotificationPageState extends State<WorkNotificationPage> {
  List<dynamic> notifications = [];
  bool _isLoading = true;

  Future<void> fetchNotifications() async {
    try {
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      final data = await notificationProvider.getAvailabilityNotifications(widget.professionId);
      setState(() {
        notifications = data;
        //_isLoading = false;
      });
      print('Données appointments ${notifications}');
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5.0,
      ),
      body: Column(
        children: [
          // Pour ouvrir la page depuis un autre widget
          ElevatedButton(
            onPressed: () async {
              final newFrequency = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => FrequencySettingsPage(
                    initialFrequency: widget.currentFrequency,
                  ),
                ),
              );

              if (newFrequency != null) {
                setState(() {
                  //widget.currentFrequency = newFrequency;
                });
              }
            },
            child: Text('Modifier la fréquence'),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(notifications[index]['title']),
                        subtitle: Text(notifications[index]['content']),
                        trailing: Text(formatDate(notifications[index]['sent_at'])),
                      ),

                        Divider(height: 20, thickness: 1),
                    ],
                  );
                },
              )
          )
        ],
      )

      /*CustomScrollView(
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
      ),*/
    );
  }
}
