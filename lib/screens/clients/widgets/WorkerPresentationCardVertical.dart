import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/utils.dart';
import '../../../screens/clients/widgets/WorkerPresentationModal.dart';
import '../client_forms/new_request_form.dart';

class WorkerPresentationCardVertical extends StatefulWidget {
  final String name;
  final double rate;
  final int reviews;
  final String availability;
  final int distance;
  final String unit;
  final String imagePath ;
  final String profession;
  final int serviceId;
  final int clientId;
  final String? clientName;
  final String serviceLabel;
  final int professionalId;

  const WorkerPresentationCardVertical({
    super.key,
    required this.name,
    required this.rate,
    required this.reviews,
    required this.availability,
    required this.distance,
    required this.unit,
    required this.imagePath,
    required this.profession,
    required this.serviceId,
    required this.clientId,
    this.clientName,
    required this.serviceLabel,
    required this.professionalId,
  });

  @override
  State<WorkerPresentationCardVertical> createState() => _WorkerPresentationCardVerticalState();
}

class _WorkerPresentationCardVerticalState extends State<WorkerPresentationCardVertical> {

  void _openFormModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewRequestFormModal(clientId: widget.clientId, clientName: widget.clientName, serviceId: widget.serviceId, serviceLabel: widget.serviceLabel, professionalId: widget.professionalId, professionalName: widget.name,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xAAF6E7FB),
        ),
        //height: 211,
        width: 180,
        margin: EdgeInsets.symmetric( horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Stack( // Utilisation d'un Stack pour superposer l'icône
          children: [
        Column(
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                image: DecorationImage(
                  image: widget.imagePath != null
                      ? NetworkImage(widget.imagePath)
                      : AssetImage(AssetsData.p) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5,),
                  Container(
                    //height: 40,
                    child:  Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFFFB0049),
                        size: 20,
                      ),
                      SizedBox(width: 5,),
                      Text(
                          formatDistance(widget.distance.toDouble()),
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      Text(
                          widget.rate.toString(),
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          )
                      ),
                      SizedBox(width: 8,),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: ColorsData.grey6b.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      SizedBox(width: 8,),
                      Text(
                          ' ${widget.reviews} avis',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: ColorsData.grey6b.withOpacity(0.9)
                            ),
                          )
                      ),
                    ],
                  ),
                  GestureDetector(
                    child:  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          color: ColorsData.purple00C,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                          'Choisir ce prestataire',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: ColorsData.white
                            ),
                          )
                      ),
                    ),
                    onTap: () {
                      _openFormModal(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(4), // Petit padding pour l'icône
              decoration: BoxDecoration(
                color: widget.availability == 'available'
                    ? Colors.green.shade700
                    : Colors.red.shade700, // Rouge plus foncé
                shape: BoxShape.circle, // Forme circulaire
              ),
              child: Icon(
                widget.availability == 'available'
                    ? Icons.online_prediction // Icône de coche pour disponible
                    : Icons.do_not_disturb_on, // Icône de croix pour indisponible
                color: Colors.white,
                size: 18, // Taille de l'icône
              ),
            ),
        )
          ]
        )
      ),
     /* onTap: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return WorkerPresentationModal(
              name: widget.name,
              rate: widget.rate,
              availability: widget.availability,
              availabilityColor: widget.availabilityColor,
              distance: widget.distance,
              unit: widget.unit,
              imagePath: widget.imagePath,
              reviews: widget.reviews,
              description: widget.description,
            );
          },
        );
      },*/
    );
  }
}
