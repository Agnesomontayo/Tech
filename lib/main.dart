import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tech/core/providers/appointment_provider.dart';
import 'package:tech/core/providers/client_provider.dart';
import 'package:tech/core/providers/professionCategory_provider.dart';
import 'package:tech/core/providers/profession_provider.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/appTypes_page.dart';
import 'package:tech/screens/clients/client_home/MainScreen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:tech/core/helpers/utils.dart';
import 'core/const/const.dart';
import 'core/providers/app_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/review_provider.dart';
import 'core/providers/search_provider.dart';
import 'core/providers/serviceRequest_provider.dart';
import 'core/providers/services_provider.dart';
import 'core/services/dio_service.dart';
import 'screens/splashscreen.dart';
import 'screens/login/login_page.dart';
import 'screens/register/register_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:tech/screens/clients/client_home/client_home.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  await requestLocationPermission();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    initializeDateFormatting().then((_) =>  runApp(
      /*ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: MyApp(),
      ),*/

      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
          ChangeNotifierProvider(create: (_) => ProfessioncategoryProvider()),
          ChangeNotifierProvider(create: (_) => ServicesProvider()),
          ChangeNotifierProvider(create: (_) => ProfessionProvider()),
          ChangeNotifierProvider(create: (_) => ProfessionalProvider()),
          ChangeNotifierProvider(create: (_) => ClientProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
          ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
          ChangeNotifierProvider(create: (_) => SearchProvider()),
          ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ],
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
        //'/': (context) => AppTypePage(),
        // '/': (context) => MainScreen(),
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) =>   RegisterPage(),

      },

    );
  }
}