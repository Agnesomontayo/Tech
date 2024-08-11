import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/screens/home/all_works.dart';
import 'package:tech/screens/home/work_details.dart';
import 'package:tech/screens/widgets/logo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/widgets/Search_bar.dart';
import 'package:tech/screens/widgets/titleWidget.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:tech/screens/widgets/WorkCardWidget.dart';
import 'package:tech/screens/widgets/CustumAppBar.dart';


class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        toolbarHeight: 10,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Card(
                      //color: ,
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10 ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(AssetsData.p,),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour ',
                      style: GoogleFonts.commissioner(
                        textStyle: TextStyle(
                          color: ColorsData.purple13,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      'Comment pouvons-nous vous aider aujourd\'hui',
                      style: GoogleFonts.commissioner(
                        textStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),

              SearchBarWidget(),
              //SizedBox(height: 20),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: TitleWidget(title: 'Catégories'),
                    ),
                   Container(
                      height: 200,
                      //flex: 0,
                       child: GridView.count(
                         primary: false,
                         padding: const EdgeInsets.all(20),
                         crossAxisSpacing: 10,
                         mainAxisSpacing: 15,
                         crossAxisCount: 4,
                         children:  <Widget>[
                           WorkCard(
                               iconPath: AssetsData.mecanicienIcon,
                               title: 'Mécanique',
                                onTap: (){
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkDetailPage()
                                    )
                                );
                              }
                           ),
                           WorkCard(
                               iconPath: AssetsData.menuisierIcon,
                               title: 'Menuiserie',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => WorkDetailPage()
                                     )
                                 );
                               }
                           ),
                           WorkCard(
                               iconPath: AssetsData.entretienIcon,
                               title: 'Entretien',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => WorkDetailPage()
                                     )
                                 );
                               }
                           ),
                           WorkCard(
                               iconPath: AssetsData.coutureIcon,
                               title: 'Couture',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => WorkDetailPage()
                                     )
                                 );
                               }
                           ),
                           WorkCard(
                               iconPath: AssetsData.electricienIcon,
                               title: 'Electricité',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => WorkDetailPage()
                                     )
                                 );
                               }
                           ),
                           WorkCard(
                               iconPath: AssetsData.coiffeurIcon,
                               title: 'Coiffure',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => WorkDetailPage()
                                     )
                                 );
                               }
                           ),
                           WorkCard(
                               iconPath: AssetsData.maconIcon,
                               title: 'Maçonnerie',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => WorkDetailPage()
                                     )
                                 );
                               }
                           ),
                           WorkCard(
                               iconPath: AssetsData.plusIcon,
                               title: 'Plus',
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) => AllWorksPage()
                                     )
                                 );
                               }
                           ),
                         ],
                       ),
                   ),
                  ],
                )
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        displacement: 80,
        color: ColorsData.purple00A,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        semanticsLabel: "Pull to refresh",
        semanticsValue: "Refresh",
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    setState(() {});
  }
}