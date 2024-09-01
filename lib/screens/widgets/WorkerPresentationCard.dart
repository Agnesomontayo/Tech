import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/const/assets.dart';
import '../../core/const/colors.dart';

class WorkerPresentationCard extends StatelessWidget {
  final String name;
  final String rate;
  final String reviews;
  final String availability;
  final String distance;
  final String unit;
  final Color availabilityColor;
  const WorkerPresentationCard ({
    super.key,
    required this.name,
    required this.rate,
    required this.reviews,
    required this.availability,
    required this.distance,
    required this.unit,
    required this.availabilityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorsData.purple255.withOpacity(0.1),
      ),
      height: 111,
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
                  image: AssetImage(AssetsData.best),
                  fit: BoxFit.fill
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.karla(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
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
                        rate,
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
                          color: availabilityColor,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text(
                          availability,
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
    );
  }
}
