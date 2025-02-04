import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import 'WorkerPresentationModal.dart';

class ServicePresentationListItem extends StatefulWidget {
  final String serviceName;
  final double rate;
  final String reviews;
  final String availability;
  final String distance;
  final String unit;
  final Color availabilityColor;
  final String imagePath;
  final String workIcon;
  final String work;
  final String iconPath;
  final String description;
  final String priceRange;

  const ServicePresentationListItem({
    super.key,
    required this.serviceName,
    required this.rate,
    required this.reviews,
    required this.availability,
    required this.distance,
    required this.unit,
    required this.availabilityColor,
    required this.imagePath,
    required this.iconPath,
    required this.work,
    required this.workIcon,
    required this.priceRange,
    required this.description,
  });

  @override
  State<ServicePresentationListItem> createState() =>
      _ServicePresentationListItemState();
}

class _ServicePresentationListItemState
    extends State<ServicePresentationListItem> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorsData.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1.4, // Ajustez le ratio pour adapter l'image à l'espace
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IntrinsicHeight(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          width: 100,
                          decoration: BoxDecoration(
                            color: ColorsData.purple260.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsData.purple255.withOpacity(0.2),
                                ),
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  widget.workIcon,
                                  fit: BoxFit.cover,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                  child:  Text(
                                    widget.work,
                                    style: GoogleFonts.brunoAce(
                                      textStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: ColorsData.purple00A,
                                      ),
                                    ),
                                  ),
                              )

                            ],
                          ),
                        ),
                      ),
                      Text(
                        widget.serviceName,
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            //color: Colors.white,
                          ),
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        widget.priceRange,
                        style: GoogleFonts.commissioner(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorsData.purple00A,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                  color: ColorsData.purple00C,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text('Commander',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: ColorsData.white),
                                  )
                              ),
                            ),
                            onTap: () {
                              print('bla');
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 25,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isClicked = !_isClicked; // Inverse l'état à chaque clic
                });
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                height: 30,
                width: 30,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                child: SvgPicture.asset(
                  _isClicked ? AssetsData.favFullIcon : AssetsData.favIcon,
                  color: _isClicked ? Colors.red : Colors.grey,
                  width: 23,
                  height: 25,
                ),
              ),
            ),
          )
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return WorkerPresentationModal(
              name: widget.serviceName,
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
      },
    );
  }
}
