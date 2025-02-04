import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importez le package flutter_svg
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/colors.dart';

class CustumAppBar extends StatelessWidget {
  final String title;

  CustumAppBar ({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
          margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
            color: ColorsData.purple260.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                    Icons.chevron_left,
                    color: ColorsData.purple00A,
                    size: 30,
                ), // Icône de retour
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 20,),
              Expanded(
                  child:  Text(
                      title,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: ColorsData.purple00A,
                          fontSize: 20,
                          height: 1.0
                        ),
                      ),
                    ),
                  )
            ],
          ),
        )
    );
  }
}


