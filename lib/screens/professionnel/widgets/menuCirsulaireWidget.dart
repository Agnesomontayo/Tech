import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/assets.dart';

import '../../../core/const/colors.dart';

class MenuCirculaireWidget extends StatefulWidget {
  @override
  _MenuCirculaireWidgetState createState() => _MenuCirculaireWidgetState();
}

class _MenuCirculaireWidgetState extends State<MenuCirculaireWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true); // Animation continue (effet de vague)

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation de Dialog pleine page
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value * 1.5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.elliptical(700, 1500)
                    ),
                    color: ColorsData.purple00A.withOpacity(0.3),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: -190,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.4,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.elliptical(700, 1000)
                ),
                color: ColorsData.purple00A,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 210.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50,),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: ColorsData.white,
                          size: 30,
                        ), // Icône de retour
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: 50,),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsData.chatIcon,
                                    fit: BoxFit.scaleDown,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Messagerie',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsData.searchIcon,
                                    fit: BoxFit.scaleDown,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Voir vos clients',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsData.favIcon,
                                    fit: BoxFit.scaleDown,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Le classement',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           // SizedBox(height: 50),
                           /* GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsData.starIcon,
                                    fit: BoxFit.scaleDown,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Vos statistiques',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                            SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsData.infoBullIcon,
                                    fit: BoxFit.scaleDown,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Centre d\'aide',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetsData.pageIcon,
                                    fit: BoxFit.scaleDown,
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Conditions générales',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}