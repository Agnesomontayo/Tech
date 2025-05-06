import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ServicePresentationCard extends StatefulWidget {
  //final String iconPath;
  final String serviceName;
  final String imagePath;
  //final String priceRange;

  const ServicePresentationCard({
    super.key,
    //required this.iconPath,
    required this.imagePath,
    required this.serviceName,
   // required this.priceRange,
  });

  @override
  State<ServicePresentationCard> createState() =>
      _ServicePresentationCardState();
}

class _ServicePresentationCardState extends State<ServicePresentationCard> {
  bool _isClicked = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: 280,
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    widget.imagePath != null && widget.imagePath.isNotEmpty
                        ? Image.network(
                      widget.imagePath,
                      key: ValueKey(widget.imagePath),
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
                    ): Image.asset(
                      AssetsData.menage,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: ColorsData.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            /*Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: ColorsData.purple255.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                widget.iconPath,
                                fit: BoxFit.scaleDown,
                                width: 15,
                                height: 15,
                              ),
                            ),*/
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.serviceName,
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  /*Text(
                                    widget.priceRange,
                                    style: GoogleFonts.commissioner(
                                      textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: ColorsData.purple00A,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                            GestureDetector(
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
                                BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: ColorsData.purple255.withOpacity(0.3),
                                ),
                                child: SvgPicture.asset(
                                  _isClicked ? AssetsData.favFullIcon : AssetsData.favIcon,
                                  color: _isClicked ? Colors.red : Colors.black,
                                  width: 23,
                                  height: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
        Positioned(
          top: 15,
          right: 25,
          child: GestureDetector(
            onTap: () {
              print('bla');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: ColorsData.purple00A,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2), // décalage vertical
                  ),
                ],
              ),
              child: Text(
                'Commander',
                textAlign: TextAlign.center,
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorsData.white,
                  ),
                ),
              ),
            ),
          )
        )
      ],
    );
  }
}

