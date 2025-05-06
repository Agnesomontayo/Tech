import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/user_infos/history_page.dart';
import 'package:tech/screens/clients/user_infos/info_page.dart';
import 'package:tech/screens/clients/user_infos/notifications_page.dart';
import 'package:tech/screens/clients/user_infos/safety_page.dart';
import 'package:tech/screens/clients/user_infos/settings_page.dart';
import 'package:tech/screens/clients/widgets/PageHeaderWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../../clients/widgets/menuCirculaireWidget.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String baseImageUrl = '';
  Map<String, dynamic>? _profile;

  @override
  Future<void> _loadProfile() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final data = await appProvider.getProfile();
      setState(() {
        _profile = data;
      });
    } catch (error) {
      print('Erreur de chargement du profil : $error');
    }
  }

  void handleLogout() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final success = await appProvider.logout();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la déconnexion')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    return _profile == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      body: Column(
        children: [
          PageHeaderWidget(),
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
                            image: _profile != null
                                ? (_profile!['avatar'] != null
                                ? NetworkImage('${baseImageUrl}/${_profile!['avatar']}')
                                : NetworkImage(_profile!['profile_photo_url']))
                                : AssetImage(AssetsData.p) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),/*
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
                    ),*/
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
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserInformationsPage(
                                          firstName: _profile!['firstName'],
                                          lastName: _profile!['lastName'],
                                          phonenumber: _profile!['phonenumber'],
                                          email: _profile!['email'],
                                          imageUrl: _profile!['avatar'] != null && _profile!['avatar'].toString().isNotEmpty
                                                    ? '${baseImageUrl}/${_profile!['avatar']}'
                                                    : _profile!['profile_photo_url'],
                                        ),
                                  ),

                                );
                                if (result == true) {
                                  _loadProfile();
                                }
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
                                    builder: (context) => NotificationPage(),
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
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            handleLogout();
                                          },
                                          child: Text('Déconnexion'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
