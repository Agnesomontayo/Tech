import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../screens/clients/widgets/WorkerPresentationModal.dart';
import 'package:tech/core/helpers/utils.dart';

class WorkerPresentationCard extends StatelessWidget {
  final String name;
  final double rate;
  final String reviews;
  final String availability;
  final String distance;
  final String unit;
  final String imagePath ;
  final String biography;
  final String profession;
  const WorkerPresentationCard ({
    super.key,
    required this.name,
    required this.rate,
    required this.reviews,
    required this.availability,
    required this.distance,
    required this.unit,
    required this.imagePath,
    required this.biography,
    required this.profession,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ColorsData.purple255.withOpacity(0.1),
        ),
        height: 140,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 101,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: imagePath != null
                        ? NetworkImage(imagePath)
                        : AssetImage(AssetsData.best) as ImageProvider,
                    fit: BoxFit.fill
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalizeEachWord(name),
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    capitalizeFirstLetter(profession),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: ColorsData.purple00C,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                      Text(
                          rate.toString(),
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
                          ' $reviews avis',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: ColorsData.grey6b.withOpacity(0.5)
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            color: availability == 'available'
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                            availability == 'available'
                                ? 'Disponibble'
                                : 'Indisponible',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: ColorsData.white
                              ),
                            )
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(
                        Icons.location_on,
                        color: Color(0xFFFB0049),
                        size: 20,
                      ),
                      SizedBox(width: 5,),
                      Text(
                          'A $distance $unit',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return WorkerPresentationModal(
              name: name,
              rate: rate,
              availability: availability,
              distance: distance,
              unit: unit,
              imagePath: imagePath,
              reviews: reviews,
              biography: biography,
              profession: profession,
            );
          },
        );
      },
    );
  }
}
