import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/const/colors.dart';

class ServicePresentationCard extends StatefulWidget {
  final String iconPath;
  final String serviceName;
  final String imagePath;
  final String priceRange;
  const ServicePresentationCard({
    super.key,
    required this.iconPath,
    required this.imagePath,
    required this.serviceName,
    required this.priceRange,
  });

  @override
  State<ServicePresentationCard> createState() => _ServicePresentationCardState();
}

class _ServicePresentationCardState extends State<ServicePresentationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 280,
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(
                widget.imagePath,
                //AssetsData.menage,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 15, // Positionne le conteneur en bas de l'image
                left: 0,
                right: 0,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                        color: ColorsData.white, // Ajuste la couleur avec opacité
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30, // Largeur du point
                          height: 30, // Hauteur du point
                          decoration: BoxDecoration(
                            color: ColorsData.purple255.withOpacity(0.3), // Couleur du point
                            shape: BoxShape.circle, // Forme circulaire
                          ),
                          child: SvgPicture.asset(
                           // AssetsData.entretienIcon,
                            widget.iconPath,
                            fit: BoxFit.scaleDown,
                            width: 15,
                            height: 15,
                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                          ],
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
