import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../screens/clients/widgets/WorkerPresentationModal.dart';
import '../client_forms/new_request_form.dart';

class WorkerPresentationCardVertical extends StatefulWidget {
  final String name;
  final double rate;
  final String reviews;
  final String availability;
  final String distance;
  final String unit;
  final Color availabilityColor;
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
    required this.availabilityColor,
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
        child: Column(
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
                    height: 40,
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
                  Container(
                    height: 40,
                    child: Text(
                      widget.profession,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: ColorsData.purple00C,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2,),
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
