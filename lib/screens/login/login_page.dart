import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/client_home/client_home.dart';
import 'package:tech/screens/professionnel/professionnel_home/professionnel_home.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/clients/widgets/CustumInputs.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../clients/client_home/MainScreen.dart';
import '../professionnel/professionnel_home/MainScreenProfessionnal.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool? rememberMe = false;
  bool isButtonPressed = false;
  bool isLinkPressed = false;
  bool LinkPressed = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -270,
              left: -160,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 550,
                  height: 450,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsData.purple00A.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -150,
              left: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsData.purple00A,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ClipOval(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcATop,
                              ),
                              child: SvgPicture.asset(
                                AssetsData.ProfcustomLogo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      "Connexion",
                      style: GoogleFonts.brunoAce(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    SizedBox(height: 210),
                    CustomTextInput(
                      hintText: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: ColorsData.purple00A,
                        size: 22,
                      )
                      ),

                    SizedBox(height: 10),
                    CustomTextInput(
                      hintText: 'Mot de passe',
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: ColorsData.purple00A,
                        size: 22,
                      )
                    ),
                    Row(
                      children: <Widget>[
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: ColorsData.purple00A,
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.purple, width: 2),
                              ),
                              onChanged: (bool? a) {
                                setState(() {
                                  rememberMe = a;
                                });
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Text(
                                'Se souvenir de moi',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              LinkPressed = !LinkPressed;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Mot de passe oublié',
                               style: TextStyle(
                                color: ColorsData.purple00A,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                decoration: LinkPressed ? TextDecoration.underline : TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text;
                        String password = passwordController.text;

                        debugPrint('Connexion...');
                        final loginResult = await authProvider.logIn(email, password);

                        final errorMessage = loginResult['error'];
                        final profileType = loginResult['profileType'];

                        if (errorMessage.isEmpty) {
                          debugPrint('Connexion réussie');

                          if (profileType == 'client') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                            );
                          } else if (profileType == 'professionnel') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreenProfessionnal()),
                            );
                          } else {
                            debugPrint('Type de profil inconnu : $profileType');
                          }

                        } else {
                          debugPrint('Échec de connexion : $errorMessage');

                          setState(() {
                            this.errorMessage = 'Mot de passe ou e-mail incorrect';
                            isButtonPressed = !isButtonPressed;
                          });
                        }
                      },

                      child: Container(
                        width: 300,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          'Connexion',
                          style: GoogleFonts.brunoAce(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        ),
                      ),
                     /* style: ElevatedButton.styleFrom(
                        primary: isButtonPressed ? Colors.white : ColorsData.purple00A,
                        onPrimary: isButtonPressed ? ColorsData.purple00A : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: ColorsData.purple00A,
                            width: 2,
                          ),
                        ),
                      ),*/
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLinkPressed = !isLinkPressed;
                        });
                       Navigator.pushNamed(context, '/signup');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Vous n'avez pas de compte? ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            // decoration: isLinkPressed ? TextDecoration.underline : TextDecoration.none, // Souligner le texte si le lien est cliqué
                          ),
                          children: [
                            TextSpan(
                              text: "Inscrivez-vous",
                              style: TextStyle(
                                color: ColorsData.purple00A,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                decoration: isLinkPressed ? TextDecoration.underline : TextDecoration.none, // Souligner le texte si le lien est cliqué
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    emailController.clear();
    passwordController.clear();

    await Future.delayed(Duration(seconds: 1));

    setState(() {});
  }
}