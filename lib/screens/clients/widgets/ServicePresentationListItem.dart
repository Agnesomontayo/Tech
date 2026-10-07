import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tech/screens/clients/widgets/ServicePresentationModal.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../client_forms/new_request_form.dart';
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
  final int serviceId;
  final int clientId;
  final String? clientName;

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
    required this.serviceId,
    required this.clientId,
    this.clientName,
  });

  @override
  State<ServicePresentationListItem> createState() =>
      _ServicePresentationListItemState();
}

class _ServicePresentationListItemState
    extends State<ServicePresentationListItem> {
  bool _isClicked = false;

  /*@override
  void _openFormModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewRequestFormModal(serviceId: widget.serviceId),
    );
  }*/

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
                        aspectRatio: 1.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:  widget.imagePath.startsWith('http')
                              ? Image.network(
                            widget.imagePath,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                              : Image.asset(
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
                      SizedBox(height: 6,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.description,
                                style: GoogleFonts.karla(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0x55050505),
                                  ),
                                ),
                                textAlign: TextAlign.justify,
                                maxLines: null,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Row(
                       // mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                              _openFormModal(context);
                              print('bla');
                            },
                          )
                        ],
                      )*/
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
                  _isClicked = !_isClicked;
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
            return ServicePresentationModal(
              label: widget.serviceName,
              rate: widget.rate,
              availability: widget.availability,
              availabilityColor: widget.availabilityColor,
              distance: widget.distance,
              unit: widget.unit,
              imagePath: widget.imagePath,
              reviews: widget.reviews,
              description: widget.description,
              serviceId: widget.serviceId,
              clientId: widget.clientId,
              clientName: widget.clientName,
            );
          },
        );
      },
    );
  }
}
