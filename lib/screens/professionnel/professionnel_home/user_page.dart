import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/professionnel/details/notification_page.dart';
import 'package:tech/screens/professionnel/widgets/ProfessionnalNotificationCard.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../user_infos/history_page.dart';
import '../user_infos/info_page.dart';
import '../user_infos/notifications_page.dart';
import '../user_infos/safety_page.dart';
import '../user_infos/settings_page.dart';
import '../widgets/menuCirsulaireWidget.dart';

class ProfessionnalUserPage extends StatefulWidget {
  const ProfessionnalUserPage({super.key});

  @override
  State<ProfessionnalUserPage> createState() => _ProfessionnalUserPageState();
}

class _ProfessionnalUserPageState extends State<ProfessionnalUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: Card(
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
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MenuCirculaireWidget();
                    },
                  );
                },
              ),
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
                              border: Border.all(
                                  color: ColorsData.purple00A, width: 1)),
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
                                        'Informations personnelles',
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserInformationsPage(),
                                      ),
                                    );
                                  },
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkNotificationPage(),
                                      ),
                                    );
                                  },
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettingsPage(),
                                      ),
                                    );
                                  },
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryPage(),
                                      ),
                                    );
                                  },
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SafetyPage(),
                                      ),
                                    );
                                  },
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
                )),
          )
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 100.0),
        child: FloatingActionButton(
            backgroundColor: ColorsData.purple00A,
            shape: CircleBorder(),
            onPressed: () => {},
            child: SvgPicture.asset(AssetsData.chatIcon)),
      ),
    );
  }
}
