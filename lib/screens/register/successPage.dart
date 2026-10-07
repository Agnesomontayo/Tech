import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/splashscreen.dart';
import '../clients/register/client_registration_page.dart';
import '../professionnel/register/professional_registration_page.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Succès'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Félicitations ! Vous êtes inscrit et connecté.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de profil du client
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
              child: Text('Voir le profil du client'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de profil du professionnel
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              },
              child: Text('Voir le profil professionnel'),
            ),
          ],
        ),
      ),
    );
  }
}