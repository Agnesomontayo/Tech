import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/colors.dart';

class HistoryClientCard extends StatefulWidget {
  final String name;
  final String imagePath ;
  final String service;
  final String date;
  final String hour;
  const HistoryClientCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.service,
    required this.date,
    required this.hour,
  });

  @override
  State<HistoryClientCard> createState() => _HistoryClientCardState();
}

class _HistoryClientCardState extends State<HistoryClientCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorsData.purple255.withOpacity(0.1),
        ),
        height: 110,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 100,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(
                        widget.imagePath
                    ),
                    fit: BoxFit.fill
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: ColorsData.purple00A
                      ),
                    ),
                  ),
                  Expanded(
                      child: Text(
                        widget.service,
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                            fontSize: 16,
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
                  Row(
                    children: [
                      /*Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: ColorsData.grey6b.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),*/
                      //SizedBox(width: 8,),
                      Text(
                          'Le ${widget.date}',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: ColorsData.grey6b.withOpacity(0.6)
                            ),
                          )
                      ),
                      SizedBox(width: 5,),
                      Text(
                          'à ${widget.hour}',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: ColorsData.grey6b.withOpacity(0.6)
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     onTap: (){},
     /* onTap: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return WorkerPresentationModal(
              name: name,
              rate: rate,
              availability: availability,
              availabilityColor: availabilityColor,
              distance: distance,
              unit: unit,
              imagePath: imagePath,
              reviews: reviews,
              description: description,
            );
          },
        );
      },*/
    );
  }
}
