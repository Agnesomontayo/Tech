import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/colors.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  const TitleWidget ({required this.title}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Text(
        title!,
        style: GoogleFonts.karla(
          color: ColorsData.purple00A,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );

  }
}
