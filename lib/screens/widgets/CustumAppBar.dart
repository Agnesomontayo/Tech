import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importez le package flutter_svg
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/colors.dart';

class CustumAppBar extends StatelessWidget {
 /* final String titleText; // Texte du titre
  final String userAvatarSvgPath; // Chemin de l'image SVG de la photo de profil de l'utilisateur dans assets

  CustumAppBar({required this.titleText, required this.userAvatarSvgPath});*/

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
              'ProFinder', // Affiche le texte "Profinder" à gauche
              style: GoogleFonts.brunoAce(
                  textStyle: TextStyle(
                    color: ColorsData.purple00A,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              )
          ),
          Spacer(),
          //SizedBox(width: 16.0),
          CircleAvatar(
            radius: 20, // Ajustez la taille selon vos besoins
            backgroundColor: Colors.transparent, // Couleur de l'arrière-plan transparente pour le cercle
            child: SvgPicture.asset(
              'assets/images/profil.svg', // Charge la photo de profil SVG depuis assets
              width: 35, // Ajustez la largeur selon vos besoins
              height: 35, // Ajustez la hauteur selon vos besoins
            ),
          ),
        ],
      ),
      backgroundColor: ColorsData.transparent,
      shadowColor: ColorsData.transparent,
    );
  }
}


