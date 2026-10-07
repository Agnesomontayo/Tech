import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/utils.dart';

class ServicePresentationCard extends StatefulWidget {
  final String iconPath;
  final String serviceName;
  final String imagePath;
  final String description;

  const ServicePresentationCard({
    super.key,
    required this.iconPath,
    required this.imagePath,
    required this.serviceName,
    required this.description,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: ColorsData.white,
                          // Ajuste la couleur avec opacité
                          borderRadius: BorderRadius.circular(10)),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.serviceName,
                            style: GoogleFonts.karla(
                              textStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          const SizedBox(height: 2), // espace entre les textes
                           Text(
                              capitalizeFirstLetter(widget.description),
                              style: GoogleFonts.commissioner(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ColorsData.purple00A,
                                  fontStyle: FontStyle.italic,
                                  height: 1.0,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,

                            ),
                        ],
                      ),
                      /*Row(
                        children: [
                          *//*Container(
                            width: 30, // Largeur du point
                            height: 30, // Hauteur du point
                            decoration: BoxDecoration(
                              color: ColorsData.purple255.withOpacity(0.3),
                              // Couleur du point
                              shape: BoxShape.circle, // Forme circulaire
                            ),
                            child: SvgPicture.asset(
                              // AssetsData.entretienIcon,
                              widget.iconPath,
                              fit: BoxFit.scaleDown,
                              width: 15,
                              height: 15,
                            ),
                          ),*//*
                          *//*SizedBox(
                            width: 10.0,
                          ),*//*

                        ],
                      ),*/
                    ),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
       /* Positioned(
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
              BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                color: Colors.black.withOpacity(0.4),
              ),
              child: SvgPicture.asset(
                _isClicked ? AssetsData.favFullIcon : AssetsData.favIcon,
                color: _isClicked ? Colors.red : Colors.white,
                width: 23,
                height: 25,
              ),
            ),
          ),
        )*/
      ],
    );
  }
}
