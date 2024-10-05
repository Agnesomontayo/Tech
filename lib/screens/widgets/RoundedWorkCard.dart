import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/const/assets.dart';
import '../../core/const/colors.dart';

class RoundedWorkCard extends StatelessWidget {
  final String work;
  final String workIcon;
  const RoundedWorkCard({
    super.key,
    required this.work,
    required this.workIcon
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child:  Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          //width: 140,
          //height: 30,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: ColorsData.purple266,
              borderRadius: BorderRadius.circular(30)
          ),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsData.purple267
                  ),
                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: ColorsData.purple267,
                    child: SvgPicture.asset(
                        workIcon,
                        fit: BoxFit.cover,
                        height: 20,
                        width: 20,
                        color: ColorsData.purple00C,
                      ),
                  )
              ),
              SizedBox(width: 5,),
              Expanded(
                child: Text(
                  work,
                  style: GoogleFonts.brunoAce(
                    textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: ColorsData.purple00C,
                        height: 1.0
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
