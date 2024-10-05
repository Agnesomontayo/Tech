import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';

import '../../../core/const/assets.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                color: ColorsData.purple267,
                surfaceTintColor: ColorsData.purple267,
                shadowColor: ColorsData.grey,
                margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 10 ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  AssetsData.menuIcon,
                  fit: BoxFit.scaleDown,
                  width: 38, // Largeur souhaitée
                  height: 37,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
                child: Card(
                  color: ColorsData.purple267,
                  surfaceTintColor: ColorsData.purple267,
                  shadowColor: ColorsData.grey,
                  margin: EdgeInsetsDirectional.symmetric(
                      horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(
                    AssetsData.searchIcon,
                    fit: BoxFit.scaleDown,
                    width: 38,
                    height: 37,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ColorsData.purple00A, width: 1)),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                AssetsData.p,
                              ),
                              // Remplacez par votre image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 15,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: ColorsData.purple00A,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              // Pour ajouter une bordure blanche autour de l'icône
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.all(25.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: ColorsData.purple266,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Container(
                          height: 200,
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 20,
                            crossAxisCount: 3,
                            children: <Widget>[
                              GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsData.infoIcon,
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Informations Supplémentaires',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsData.purple00AIcon),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                              GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsData.bellIcon,
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Notifications',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsData.purple00AIcon),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                              GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsData.menuSettingsIcon,
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Paramètres',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsData.purple00AIcon),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                              GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsData.historyIcon,
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Historique',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsData.purple00AIcon),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                              GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsData.shieldIcon,
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Sécurité',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsData.purple00AIcon),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                              GestureDetector(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsData.logoutIcon,
                                      fit: BoxFit.scaleDown,
                                      width: 22,
                                      height: 22,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Déconnexion',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsData.purple00AIcon),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              )),)

        ],
      )

    );
  }
}
