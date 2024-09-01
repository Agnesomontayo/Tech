import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importez le package flutter_svg
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';

class SearchBarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0), // Ajustez les marges selon vos besoins
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: ColorsData.purple260.withOpacity(0.7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0), // Couleur de l'ombre
              spreadRadius: 1, // Étalement de l'ombre
              blurRadius: 5, // Flou de l'ombre
              offset: Offset(0, 5), // Décalage de l'ombre (position)
            ),
          ],
        ),
        child: TextField(
          style: GoogleFonts.karla(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              AssetsData.searchIcon,
              fit: BoxFit.scaleDown,
              width: 15, // Largeur souhaitée
              height: 15,
              color: ColorsData.purple00A,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 2.0,
                  height: 30.0,
                  color: ColorsData.purple00A,
                ),
                SvgPicture.asset(
                  AssetsData.filterIcon,
                  fit: BoxFit.scaleDown,
                  width: 20,
                  height: 20,
                  color: ColorsData.purple00A,
                ),
              ],
            ),
            hintText: 'Recherche',
            hintStyle: TextStyle(
              color: ColorsData.grey6b.withOpacity(0.7),
              fontSize: 15,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
