import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/professionnel/details/history_page.dart';
import 'package:tech/screens/professionnel/details/ranking_page.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../widgets/menuCirsulaireWidget.dart';

class LogbookPage extends StatefulWidget {
  const LogbookPage({super.key});

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  @override


  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: ColorsData.purple00A.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TabBar(
                    labelStyle: GoogleFonts.karla(
                      textStyle: TextStyle(
                        color: ColorsData.white,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: ColorsData.purple00A
                      ),
                      //labelColor: Colors.white,
                      tabs: [
                        Tab(text: 'Historique',),
                        Tab(text: 'Classement',)
                      ]
                  ),
                )
            ),
            title:  GestureDetector(
              child: Card(
                color: ColorsData.purple267,
                surfaceTintColor: ColorsData.purple267,
                shadowColor: ColorsData.grey,
               // margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 10 ),
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
          ),
          body: TabBarView(
              children: [
                HistoryPage(),
                RankingPage()
              ]
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.symmetric(vertical: 100.0),
            child: FloatingActionButton(
                backgroundColor: ColorsData.purple00A,
                shape: CircleBorder(),
                onPressed: () => {},
                child: SvgPicture.asset(AssetsData.chatIcon)),
          ),
        )
    );
  }
}

