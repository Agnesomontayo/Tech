import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';

class RankingProfessionalCard extends StatefulWidget {
  final String name;
  final String imagePath ;
  final int rank;
  final double rate;
  const RankingProfessionalCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.rank,
    required this.rate,
  });

  @override
  State<RankingProfessionalCard> createState() => _RankingProfessionalCardState();
}

class _RankingProfessionalCardState extends State<RankingProfessionalCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
         // color: ColorsData.purple255.withOpacity(0.1),
        ),
        height: 70,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image:  widget.imagePath != null
                        ? NetworkImage(widget.imagePath)
                        : AssetImage(AssetsData.menage) as ImageProvider,
                    fit: BoxFit.fill
                ),
              ),
            ),
            Expanded(
              child: Text(
                widget.name,
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: ColorsData.purple00A
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _getRankContainer(widget.rank),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
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
                          ],
                        )
                    )
                  ],
                )
            )
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

Widget _getRankContainer(int index) {
  if(index <= 3){
    switch (index) {
      case 1:
        return _buildContainer(Color(0xFFFFD34B), Color(0xFFFFE5A1), Color(0xFFC0970C), Color(0xD2FFCD31), index);
      case 2:
        return _buildContainer(Color(0xFFD9D9D9), Color(0xFFFFFCFC), Color(0xFF737373), Color(0xD2ECE8E8), index);
      case 3:
        return _buildContainer(Color(0xFFFFA260), Color(0xFFFFEEE1), Color(0xFFCF6215), Color(0xD2FFA273), index);
      default:
        return _buildContainer(Color(0xFFB276E2), Color(0xFFE7CDFC), Color(0xFF530096), Color(0xD2FFCD31), index);
    }
  } else {
    return _buildContainer(Color(0xFFB276E2), Color(0xFFE7CDFC), Color(0xFF530096), Color(0xD2FFCD31), index);
  }
}

Widget _buildContainer(Color firstColor, Color secondColor, Color thirdColor, Color backgroundColor, int rank) {
  return  Container(
    padding: EdgeInsets.all(4.0),
    height: 35,
    width: 35,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            firstColor, //Color(0xFFFFD34B),
            secondColor, //Color(0xFFFFE5A1),
            thirdColor,//Color(0xFFC0970C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        //color: Color(0xFFEC9F04),
        borderRadius: BorderRadius.circular(30.0)
    ),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor,//Color(0xD2FFCD31),
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: Text(
        rank.toString(),
        style: GoogleFonts.brunoAce(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
