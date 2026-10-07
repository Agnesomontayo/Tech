import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';

class AppointmentHistoryCard extends StatefulWidget {
  final int id;
  final String imagePath ;
  final String service;
  final String? start_date;
  final String? end_date;
  final String status;
  final String created_at;
  const AppointmentHistoryCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.service,
     this.start_date,
     this.end_date,
    required this.status,
    required this.created_at,
  });

  @override
  State<AppointmentHistoryCard> createState() => _AppointmentHistoryCardState();
}

class _AppointmentHistoryCardState extends State<AppointmentHistoryCard> {
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorsData.purple255.withOpacity(0.1),
        ),
        //height: 110,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: IntrinsicHeight(
          child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 100,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: widget.imagePath != null
                        ? NetworkImage(widget.imagePath)
                        : AssetImage(AssetsData.menage) as ImageProvider,
                    fit: BoxFit.fill
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Rendez-vous N°${widget.id}',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: ColorsData.purple00A
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.service,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      textAlign: TextAlign.justify,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  SizedBox(height: 5,),
                    if (widget.status != 'planned' && widget.start_date != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Début ${widget.start_date ?? 'Non spécifié'}',
                              style: GoogleFonts.karla(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  height: 1.0
                                ),
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  SizedBox(height: 5,),
                  if (widget.status == 'completed' || widget.status == 'stopped')
                    Text(
                        'Fin ${widget.end_date}',
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.0
                            //fontStyle: FontStyle.italic,
                            //color: ColorsData.grey6b.withOpacity(0.6)
                          ),
                        )
                    ),
                  SizedBox(height: 5,),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2.0),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: getStatusConfig(widget.status)['color'] ?? Colors.grey.shade100,
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
                              color: (getStatusConfig(widget.status)['iconColor'] ?? Colors.grey).withOpacity(0.15),
                            ),
                            child: Icon(
                              getStatusConfig(widget.status)['icon'] ?? Icons.access_time,
                              size: 20,
                              color: getStatusConfig(widget.status)['iconColor'] ?? Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              getStatusConfig(widget.status)['label'] ?? '',
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.karla(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: getStatusConfig(widget.status)['iconColor'] ?? Colors.grey,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                      'Crée ${widget.created_at}',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: ColorsData.grey6b
                        ),
                      )
                  ),

                ],
              ),
            ),
          ],
        ),
        )
      ),
      onTap: (){},
    );
  }
}
