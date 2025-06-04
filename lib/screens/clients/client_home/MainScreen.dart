import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/widgets/CustomBottomNavbar.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../widgets/menuCirculaireWidget.dart';
import 'client_home.dart';
import 'favorite_page.dart';
import 'map_page.dart';
import 'user_page.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic> profile = {};
  late String baseImageUrl;
  bool isLoading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return
          ClientHome(
            profile: profile,
            baseImageUrl: baseImageUrl,
          );
      case 1:
        return
          MapPage(
            profile: profile,
            baseImageUrl: baseImageUrl,
          );
      case 2:
        return
          FavoritePage(
            profile: profile,
            baseImageUrl: baseImageUrl,
          );
      case 3:
        return
          UserPage();
      default:
        return
          ClientHome(
            profile: profile,
            baseImageUrl: baseImageUrl,
          );
    }
  }

  @override
  Future<void> _loadProfile() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final data = await appProvider.getProfile();
      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       toolbarHeight: 2,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          :getScreen(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: isLoading
          ? null
          :CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

}