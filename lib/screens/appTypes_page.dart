import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/client_home/MainScreen.dart';
import 'package:tech/screens/professionnel/professionnel_home/MainScreenProfessionnal.dart';
import 'package:tech/screens/professionnel/professionnel_home/professionnel_home.dart';

import 'clients/client_home/client_home.dart';

class AppTypePage extends StatefulWidget {
  const AppTypePage({super.key});

  @override
  State<AppTypePage> createState() => _AppTypePageState();
}

class _AppTypePageState extends State<AppTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },

                child: Container(
                  width: 300,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    'Client',
                    style: GoogleFonts.brunoAce(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ),
                ),
              ),
              SizedBox(height: 50.0,),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreenProfessionnal()),
                  );
                },

                child: Container(
                  width: 300,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    'Professionnel',
                    style: GoogleFonts.brunoAce(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
