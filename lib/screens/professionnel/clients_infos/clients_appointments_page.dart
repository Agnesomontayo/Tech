import 'package:flutter/material.dart';
import 'package:tech/core/utils/func.dart';
import 'package:tech/screens/professionnel/widgets/appointment_history_card.dart';

class ClientAppointmentsPage extends StatefulWidget {
  final List<dynamic> appointments;
  final String baseImaeUrl;
  const ClientAppointmentsPage({
    super.key,
    required this.appointments,
    required this.baseImaeUrl,
  });

  @override
  State<ClientAppointmentsPage> createState() => _ClientAppointmentsPageState();
}

class _ClientAppointmentsPageState extends State<ClientAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    final appointments = widget.appointments;
    if (appointments.isEmpty) {
      return Center(
        child: Text('Aucune interaction trouvée 😢'),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final appointment = appointments[index];
              return Column(
                children: [
                  AppointmentHistoryCard(
                      id: appointment['id'],
                      imagePath: '${widget.baseImaeUrl}/${appointment['service']['image']}',
                      service: appointment['service']['name'],
                      start_date: appointment['start_time'] == null ? null : formatDate(appointment['start_time']),
                      end_date: appointment['end_time'] == null ? null : formatDate(appointment['end_time']),
                      status: appointment['status'],
                      created_at: formatDate(appointment['created_at'])
                  ),
                  if (index < appointments.length-1)
                    Divider(height: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                ],
              );
            },
            childCount: appointments.length,
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
