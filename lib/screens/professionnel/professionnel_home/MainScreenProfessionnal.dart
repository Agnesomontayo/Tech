import 'package:flutter/material.dart';
import 'package:tech/screens/professionnel/professionnel_home/logbook_page.dart';
import 'package:tech/screens/professionnel/professionnel_home/professionnal_map_page.dart';
import 'package:tech/screens/professionnel/professionnel_home/professionnel_home.dart';
import 'package:tech/screens/professionnel/professionnel_home/request_page.dart';
import 'package:tech/screens/professionnel/professionnel_home/user_page.dart';
import 'package:tech/screens/professionnel/widgets/CustomBottomNavigationBar.dart';

class MainScreenProfessionnal extends StatefulWidget {
  const MainScreenProfessionnal({super.key});

  @override
  State<MainScreenProfessionnal> createState() => _MainScreenProfessionnalState();
}

class _MainScreenProfessionnalState extends State<MainScreenProfessionnal> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return
            ProfessionnelHome();
      case 1:
        return
          ProfessionnalMapPage();
      case 2:
        return
          LogbookPage();
      case 3:
        return
          RequestPage();
      case 4:
        return
            ProfessionnalUserPage();
      default:
        return
          ProfessionnelHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2,
      ),
      body: getScreen(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

}
