import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/const/const.dart';
import 'core/providers/auth_provider.dart';
import 'core/services/dio_service.dart';
import 'screens/splashscreen.dart';
import 'screens/login/login_page.dart';
import 'screens/register/register_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:tech/screens/home/client_home.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    initializeDateFormatting().then((_) =>  runApp(
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: MyApp(),
      ),
    ));
  });


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Route initiale, par exemple le splash screen
      routes: {
         '/': (context) => ClientHome(),
        /*'/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) =>   RegisterPage(),*/

      },

    );
  }
}