import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/utils/func.dart';
import 'package:tech/screens/clients/client_forms/accept_request_form.dart';
import 'package:tech/screens/clients/details/appointment_tracking_page.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/models/chat_message.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/serviceRequest_provider.dart';

class NewRequestMessageCard extends StatefulWidget {
  final bool isReceiver;
  final String content;
  final String senderType;
  final String businessType;
  final String currentUserProfileImage;
  final ChatMessage messageBody;
  final int currentUserId;
  final String typeProfil;

  const NewRequestMessageCard({
    super.key,
    required this.isReceiver,
    required this.content,
    required this.senderType,
    required this.businessType,
    required this.currentUserProfileImage,
    required this.messageBody,
    required this.currentUserId,
    required this.typeProfil,
  });

  @override
  State<NewRequestMessageCard> createState() => _NewRequestMessageCardState();
}

class _NewRequestMessageCardState extends State<NewRequestMessageCard> {
  String baseImageUrl = '';
  late ChatMessage message ;
  Map<String, dynamic>? data;
  bool isModified = false;
  int serviceRequestId = 0;
  bool showAcceptationBottomRow = true;
  bool showCancelBottom = false;
  bool showCancelBottomToSender = true;
  Map<String, dynamic> statusConfig = {};
  bool showAppointmentTrackingButton = false;

  void _openFormModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AcceptRequestForm(
        serviceRequestId: serviceRequestId,
      ),
    );
  }

  Map<String, dynamic> getStatusConfig(String status) {
    switch (status) {
      case 'accepted':
        return {
          'label': 'Acceptée',
          'color': Colors.green.shade100,
          'icon': Icons.check,
          'iconColor': Colors.green
        };
      case 'rejected':
        return {
          'label': 'Rejetée',
          'color': Colors.red.shade100,
          'icon': Icons.close,
          'iconColor': Colors.red
        };
      case 'canceled':
        return {
          'label': 'Annulée',
          'color': Colors.blue.shade100,
          'icon': Icons.undo,
          'iconColor': Colors.blue
        };
      case 'pending':
      default:
        return {
          'label': 'En attente',
          'color':  Colors.orange.shade100,
          'icon': Icons.hourglass_top,
          'iconColor': Colors.orange
        };
    }
  }

  Future<void> _initialiseShowButtons(String status) async {
    if (status == 'accepted') {
      setState(() {
        showAcceptationBottomRow = false;
        showCancelBottom = false;
        showCancelBottomToSender = false;
        showAppointmentTrackingButton = true;
      });
    } else if (status == 'pending') {
      setState(() {
        showAcceptationBottomRow = true;
        showCancelBottom = false;
        showCancelBottomToSender = true;
      });
    } else if (status == 'rejected' || status == 'canceled') {
      setState(() {
        showAcceptationBottomRow = false;
        showCancelBottom = false;
        showCancelBottomToSender = false;
      });
    }
  }

  void _handleAcceptRequest(BuildContext context) async {
    print('Demande acceptée : ');
    _openFormModal(context);
    if (mounted) setState(() => _loadInfos());
    //await _loadInfos();
    setState(() {
      showAcceptationBottomRow = false;
      showCancelBottom = true;
    });
  }

  void _handleRefuseRequest() async {
      try {
        print('Demande refusée : ');
        final requestProvider = Provider.of<ServiceRequestProvider>(context, listen: false);
        final request = await requestProvider.updateServiceRequestStatus(
            serviceRequestId,
            'rejected',
            null,
            null
        );
        print('Demande mise à jour : $request');
        setState(() {
          showAcceptationBottomRow = false;
          showCancelBottom = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Demande mise à jour avec succès !')),
        );
        if (mounted) setState(() => _loadInfos());
        //await _loadInfos();
      } catch (e) {
        print('Erreur: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'envoi de la demande')),
        );
      }
  }

  void _handleCancelRequest() async{
    try {
      print('Demande annulée : ');
      final requestProvider = Provider.of<ServiceRequestProvider>(context, listen: false);
      final request = await requestProvider.updateServiceRequestStatus(
          serviceRequestId,
          'canceled',
          null,
          null
      );
      print('Demande mise à jour : $request');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande mise à jour avec succès !')),
      );
      setState(() {
        showAcceptationBottomRow = false;
        showCancelBottom = false;
      });
      if (mounted) setState(() => _loadInfos());
      //await _loadInfos();
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'envoi de la demande')),
      );
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
            typeProfile: widget.typeProfil,
        )),
      );
  }
  final List<Map<String, dynamic>> durations = [
    {'label': '5 minutes', 'value': 5},
    {'label': '15 minutes', 'value': 15},
    {'label': '30 minutes', 'value': 30},
    {'label': '45 minutes', 'value': 45},
    {'label': '1 heure', 'value': 60},
    {'label': '1 heure 15 minutes', 'value': 75},
    {'label': '1h30', 'value': 90},
    {'label': '1 heure 45 minutes', 'value': 105},
    {'label': '2 heures', 'value': 120},
    {'label': '2 heures 15 minutes', 'value': 135},
    {'label': '2 heures 30 minutes', 'value': 150},
    {'label': '2 heures 45 minutes', 'value': 165},
    {'label': '3 heures', 'value': 180},
    {'label': 'Plus de 3 heures', 'value': 0},
  ];

  String getDurationLabel(int? value) {
    if (value == null) return 'N/A';
    final match = durations.firstWhere(
          (d) => d['value'] == value,
      orElse: () => {'label': '${value} minutes'},
    );
    return match['label'];
  }

  Future<void> _loadInfos () async {
      String url = await ApiHelper.getApiUrl();
      if (!mounted) return;

      final newData = jsonDecode(widget.messageBody.content);
      setState((){
        /*baseImageUrl = url;
        message = widget.messageBody;
        data = jsonDecode(message.content);
        data!['isModified'] == true ? isModified = true : isModified = false;
        serviceRequestId = data!['id'];
        statusConfig = getStatusConfig(data!['status']);*/
        baseImageUrl = url;
        message = widget.messageBody;
        data = newData;
        data!['isModified'] == true ? isModified = true : isModified = false;
        serviceRequestId = newData['id'];
        statusConfig = getStatusConfig(newData['status']);
      });
      _initialiseShowButtons(newData['status']);
      print('data: $data');
      print('baseurl: ${baseImageUrl}');
  }

  @override
  void didUpdateWidget(NewRequestMessageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (jsonEncode(oldWidget.messageBody.content) !=
        jsonEncode(widget.messageBody.content)) {
      _loadInfos();
    }
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _loadInfos();
    final provider = Provider.of<ServiceRequestProvider>(context, listen: false);
    provider.requestUpdates.stream.listen((id) {
      if (id == serviceRequestId && mounted) _loadInfos();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('BUILDING WITH DATA: ${data?['status']}');
    if (data == null) {
      return Center(child: CircularProgressIndicator());
    }
    final actualData = data!;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Align(
            alignment:
            widget.isReceiver ? Alignment.topLeft : Alignment.topRight,
            child: Column(
                crossAxisAlignment: widget.isReceiver
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget.isReceiver
                            ? Colors.grey.shade200
                            : ColorsData.purple260,
                      ),
                      padding: EdgeInsets.all(6.0),
                      child: Card(
                        surfaceTintColor: ColorsData.white,
                        color: ColorsData.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(13.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.0),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: statusConfig['color'] ?? Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (statusConfig['iconColor'] ?? Colors.grey).withOpacity(0.15),
                                          ),
                                          child: Icon(
                                            statusConfig['icon'] ?? Icons.access_time,
                                            size: 14,
                                            color: statusConfig['iconColor'] ?? Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          statusConfig['label'] ?? '',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: statusConfig['iconColor'] ?? Colors.grey,
                                              height: 1.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
                                  actualData['title'] ?? '',
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
                                                image: actualData['service']['image'] != null
                                                    ? NetworkImage('${baseImageUrl}/${actualData['service']['image']}')
                                                    : AssetImage(AssetsData.menage) as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Expanded(
                                              child: Text(
                                                actualData['service']['label']  ?? '',
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
                                        'Prestataire',
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
                                                image: actualData['professional']['avatar'] != null
                                                    ? NetworkImage('${baseImageUrl}/${actualData['professional']['avatar']}')
                                                    : NetworkImage(actualData['professional']['profile_photo_url']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0,),
                                          Text(
                                            actualData['professional']['name']  ?? '',
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                //color: ColorsData.purple00A,
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
                                                image: actualData['client']['avatar'] != null
                                                    ? NetworkImage('${baseImageUrl}/${actualData['client']['avatar']}')
                                                    : NetworkImage(actualData['client']['profile_photo_url']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0,),
                                          Text(
                                            actualData['client']['name']  ?? '',
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                //color: ColorsData.purple00A,
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
                                        'Date et heure d’arrivée souhaitée',
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
                                          Container(
                                            child: Center(
                                              child: Icon(
                                                Icons.event_note,
                                                size: 25,
                                                color: ColorsData.purple00A,
                                              ),
                                            ),
                                            ),
                                          SizedBox(width: 5.0,),
                                          Text(
                                            formatDate(actualData['scheduled_at'])  ?? '',
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                //color: ColorsData.purple00A,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              if (isModified) ...[
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Prix',
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
                                            Container(
                                              child: Center(
                                                child: Icon(
                                                  Icons.attach_money,
                                                  size: 25,
                                                  color: ColorsData.purple00A,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              '${actualData['price'] ?? 'N/A'}'' FCFA',
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.karla(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
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
                                          'Durée',
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
                                            Container(
                                              child: Center(
                                                child: Icon(
                                                  Icons.timer,
                                                  size: 25,
                                                  color: ColorsData.purple00A,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                                getDurationLabel(actualData['duration_minutes']) ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.karla(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Note additionnelle du client',
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
                                          Container(
                                            child: Center(
                                              child: Icon(
                                                Icons.speaker_notes_outlined,
                                                size: 30,
                                                color: ColorsData.purple00A,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0,),
                                          Text(
                                            actualData['note'] != null && actualData['note'] is String && actualData['note'].isNotEmpty
                                                ? actualData['note']
                                                : "Aucune note",
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                                //color: ColorsData.purple00A,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              if (widget.senderType == 'sender' && showCancelBottomToSender || showCancelBottom)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ElevatedButton(
                                    onPressed: _handleCancelRequest,
                                    child: Text('Annuler'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF007DDD),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                )
                              else if (widget.senderType == 'receiver' && showAcceptationBottomRow)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            _handleAcceptRequest(context),
                                        child: Text('Accepter'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Colors.green.shade900,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _handleRefuseRequest(),
                                        child: Text('Refuser'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade700,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (showAppointmentTrackingButton && actualData['appointment_id'] != null)
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (actualData['appointment_id'] != null) {
                                          await _handleTrackingRequest(context, actualData['appointment_id'] as int);
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
                        ),
                      )
                ]
            )
        )
    );
  }
}
