import 'package:flutter/material.dart';
import 'package:tech/screens/widgets/CustomBottomNavbar.dart';
import 'client_home.dart';
import 'favorite_page.dart';
import 'map_page.dart';
import 'user_page.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
          ClientHome();
      case 1:
        return
          MapPage();
      case 2:
        return
          FavoritePage();
      case 3:
        return
          UserPage();
      default:
        return
          ClientHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreen(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

}