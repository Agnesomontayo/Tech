import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/colors.dart';

class WorkCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  const WorkCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child:  Column(
        children: [
          Container(
            //margin: EdgeInsets.symmetric(vertical: 2.0),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: ColorsData.purple260.withOpacity(0.7),
            ),
            child: SvgPicture.asset(
              iconPath,
              fit: BoxFit.scaleDown,
              width: 15,
              height: 15,
            ),
          ),
          //SizedBox(height: 2.0,),
          Text(
            title,
            style: GoogleFonts.commissioner(
              textStyle: TextStyle(
                fontSize: 10,
                color: ColorsData.purple00A,
              ),
            ),
          )
        ],
      ),
    );
  }
}
