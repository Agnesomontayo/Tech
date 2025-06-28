import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';

class RequestHistoryCard extends StatefulWidget {
  final int id;
  final String imagePath ;
  final String service;
  final String scheduled_at;
  final String status;
  final int? duration;
  final String created_at;
  const RequestHistoryCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.service,
    required this.scheduled_at,
    required this.status,
    this.duration,
    required this.created_at,
  });

  @override
  State<RequestHistoryCard> createState() => _RequestHistoryCardState();
}

class _RequestHistoryCardState extends State<RequestHistoryCard> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorsData.purple255.withOpacity(0.1),
        ),
        // height: 110,
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
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Demande N°${widget.id}',
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                        'Prévu le ${widget.scheduled_at}',
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.0
                          ),
                        )
                    ),
                    SizedBox(height: 5,),
                    if (widget.status == 'accepted' && widget.duration != null)
                      Row(
                        children: [
                          Text(
                              'Durée: ${widget.duration}',
                              style: GoogleFonts.karla(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              )
                          ),
                          Spacer(),
                        ],
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
                    Text(
                        'Envoyée ${widget.created_at}',
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
        ),
      ),
      onTap: (){},
    );
  }
}
