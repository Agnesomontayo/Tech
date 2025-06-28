import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/professionnel/widgets/RequestCard.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/appointment_provider.dart';
import '../../clients/details/appointment_tracking_page.dart';
import '../widgets/HistoryClientCardWidget.dart';
import 'package:provider/provider.dart';

class WorkRequestLists extends StatefulWidget {
  final int professionalId;
  final int currentUserId;
  const WorkRequestLists({
    super.key,
    required this.professionalId,
    required this.currentUserId
  });

  @override
  State<WorkRequestLists> createState() => _WorkRequestListsState();
}

class _WorkRequestListsState extends State<WorkRequestLists> {
  List<dynamic> appointments = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      await _fetchAppointments();
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

  Future<void> _fetchAppointments() async {
    try {
      final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
      final data = await appointmentProvider.getManyProfessionalAppointments(widget.professionalId);
      setState(() {
        appointments = data;
        //_isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        //_isLoading = false;
      });
    }
  }

  Map<String, dynamic> getStatusConfig(String status) {
    switch (status) {
      case 'completed':
        return {
          'label': 'Terminé',
          'color': Colors.green.shade100,
          'icon': Icons.check,
          'iconColor': Colors.green.shade700
        };
      case 'started':
        return {
          'label': 'En cours',
          'color': Colors.blue.shade100,
          'icon': Icons.play_arrow,
          'iconColor': Colors.blue.shade700
        };
      case 'paused':
        return {
          'label': 'En pause',
          'color': Colors.orange.shade100,
          'icon': Icons.pause,
          'iconColor': Colors.orange.shade700
        };
      case 'stopped':
        return {
          'label': 'Arrêté',
          'color': Colors.red.shade100,
          'icon': Icons.stop,
          'iconColor': Colors.red.shade700
        };
      case 'planned':
        return {
          'label': 'En attente',
          'color': Colors.blueGrey.shade100,
          'icon': Icons.pending_actions,
          'iconColor': Colors.blueGrey.shade700
        };
      case 'unknown':
      default:
        return {
          'label': 'Inconnu',
          'color': Colors.grey.shade100,
          'icon': Icons.close,
          'iconColor': Colors.grey.shade700
        };
    }
  }

  Future<String?> _getToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken');
  }

  _handleTrackingRequest(BuildContext context,int appointmentId) async {
    String url = await ApiHelper.getUrl();
    String? token = await _getToken();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentTrackingPage(
        appointmentId: appointmentId,
        currentUserId: widget.currentUserId,
        baseUrl: url,
        userToken: token!,
        appKey: 'pu8fzsphp4gk5znq6ybs',
        typeProfile: 'professionnel',
      )),
    );
  }


  @override
  void initState() {
    super.initState();
    _loadInfos();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentList = appointments;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : appointmentList.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 50,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun rendez-vous trouvé',
            style: GoogleFonts.karla(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous n\'avez pas encore de rendez-vous programmés',
            style: GoogleFonts.karla(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    )
        : CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final appointment = appointments[index];
              return Card(
                  shadowColor: ColorsData.purple00A,
                  surfaceTintColor: ColorsData.purple00A,
                  color: ColorsData.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black.withOpacity(0.13),
                                    width: 1.0,
                                  )
                              )
                          ),
                          child: Text(
                            'Rendez-vous N°${appointment['appointment_id']}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: ColorsData.purple00A,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Etat du rendez-vous',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: ColorsData.purple00A,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2.0),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: getStatusConfig(appointment['status'])['color'] ?? Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (getStatusConfig(appointment['status'])['iconColor'] ?? Colors.grey).withOpacity(0.15),
                                      ),
                                      child: Icon(
                                        getStatusConfig(appointment['status'])['icon'] ?? Icons.access_time,
                                        size: 20,
                                        color: getStatusConfig(appointment['status'])['iconColor'] ?? Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        getStatusConfig(appointment['status'])['label'] ?? '',
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: getStatusConfig(appointment['status'])['iconColor'] ?? Colors.grey,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0,),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.13),
                                          width: 1.0,
                                        )
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Service demandé',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: ColorsData.purple00A,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.13),
                                          width: 1.0,
                                        )
                                    )
                                ),
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    if (baseImageUrl == null || baseImageUrl.isEmpty)
                                      Container(
                                        height: 62,
                                        width: 72,
                                        child: CircularProgressIndicator(),
                                      ),
                                    Container(
                                      height: 62,
                                      width: 72,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: appointment['service']['image'] != null
                                              ? NetworkImage('${baseImageUrl}/${appointment['service']['image']}')
                                              : AssetImage(AssetsData.noImage) as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Text(
                                        appointment['service']['label']  ?? '',
                                        //overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            height: 1.2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            //color: ColorsData.purple00A,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Client',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: ColorsData.purple00A,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: Colors.black.withOpacity(0.13),
                                          width: 1.0,
                                        )
                                    )
                                ),
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    if (baseImageUrl == null || baseImageUrl.isEmpty)
                                      Container(
                                        height: 62,
                                        width: 72,
                                        child: CircularProgressIndicator(),
                                      ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        image: DecorationImage(
                                          image: appointment['client']['avatar'] != null
                                              ? NetworkImage('${baseImageUrl}/${appointment['client']['avatar']}')
                                              : NetworkImage(appointment['client']['profile_photo_url']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.0,),
                                    Expanded(
                                      child: Text(
                                        appointment['client']['name']  ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (appointment['appointment_id'] != null) {
                                await _handleTrackingRequest(context, appointment['appointment_id'] as int);
                              } else {
                                print('Erreur: appointment_id est null pour le suivi du rendez-vous.');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Impossible de suivre: ID de rendez-vous manquant.')),
                                );
                              }
                            },
                            child: Text('Suivre le rendez-vous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsData.purple00A,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
              );
            },
            childCount: appointments.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 20), // Ajoute le padding de sécurité + un peu plus
        ),
      ],
    );
  }
}
