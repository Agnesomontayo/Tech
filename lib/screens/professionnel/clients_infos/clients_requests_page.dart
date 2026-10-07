import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/widgets/request_history_card.dart';

import '../../../core/const/assets.dart';
import '../../../core/utils/func.dart';
import '../widgets/HistoryClientCardWidget.dart';
import 'package:tech/core/helpers/utils.dart';

class ClientRequestsPage extends StatefulWidget {
  final List<dynamic> requests;
  final String baseImaeUrl;
  const ClientRequestsPage({
    super.key,
    required this.requests,
    required this.baseImaeUrl,
  });

  @override
  State<ClientRequestsPage> createState() => _ClientRequestsPageState();
}

class _ClientRequestsPageState extends State<ClientRequestsPage> {
  @override
  Widget build(BuildContext context) {
    final requests = widget.requests;
    if (requests.isEmpty) {
      return Center(
        child: Text('Aucune interaction trouvée 😢'),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final request = requests[index];
              return Column(
                children: [
                  RequestHistoryCard(
                      id: request['id'],
                      imagePath: '${widget.baseImaeUrl}/${request['service']['image']}',
                      service: request['service']['name'],
                      created_at: formatDate(request['created_at']),
                      scheduled_at: formatDate(request['scheduled_at']),
                      status: request['status'],
                  ),
                  if (index < requests.length-1)
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
