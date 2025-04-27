// client_registration_page.dart

import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/clients/widgets/CustumInputs.dart';
import 'package:provider/provider.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:tech/screens/clients/widgets/CustumDropdown.dart';

import '../client_home/MainScreen.dart';

class ClientRegistrationPage extends StatefulWidget {
  @override
  _ClientRegistrationPageState createState() => _ClientRegistrationPageState();
  }
  class _ClientRegistrationPageState extends State<ClientRegistrationPage> {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController firstnameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController cpasswordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    String signUpMessage = '';

    bool? rememberMe = false;
    bool isButtonPressed = false;
    bool isLinkPressed = false;
    bool LinkPressed = false;

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
                          "Inscription",
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
                        SizedBox(height: 200),
                        CustomTextInput(
                            hintText: 'NOM',
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: ColorsData.purple00A,
                              size: 22,
                            )
                        ),
                        CustomTextInput(
                            hintText: 'Prénoms',
                            controller: firstnameController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              color: ColorsData.purple00A,
                              size: 22,
                            )
                        ),
                        SizedBox(height: 10),
                        CustomTextInput(
                            hintText: 'Email',
                            controller: emailController,
                            obscureText: false,
                            prefixIcon: Icon(
                              Icons.mail_outline_rounded,
                              color: ColorsData.purple00A,
                              size: 22,
                            )
                        ),
                        SizedBox(height: 10),
                        CustomTextInput(
                            hintText: '+229 XX-XX-XX-XX ',
                            controller: numberController,
                            obscureText: false,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.local_phone_outlined,
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
                        SizedBox(height: 10),
                        CustomTextInput(
                            hintText: ' Confirmation ',
                            controller: cpasswordController,
                            obscureText: true,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: ColorsData.purple00A,
                              size: 22,
                            )
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async{
                            String lastName  =  nameController.text;
                            String firstName = firstnameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String cpassword = cpasswordController.text;
                            String phonenumber  =  numberController.text;

                            String signUpResult = await authProvider.signUpClient(
                              lastName,
                              firstName,
                              email,
                              password,
                              phonenumber,
                            );

                            if (signUpResult.isEmpty) {
                                debugPrint('Inscription r\éussie: $signUpResult');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainScreen()),
                              );
                            } else {
                               debugPrint('Échec de l\'inscription : $signUpResult');
                              setState(() {
                                signUpMessage = signUpResult;
                             //   isButtonPressed = !isButtonPressed; // Inverser la valeur de isButtonPressed
                              });
                            }

                          },
                          /*  style: ElevatedButton.styleFrom(
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
                          child: Container(
                            width: 300,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              'C est parti' ,
                              style: GoogleFonts.brunoAce(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          signUpMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )

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
      cpasswordController.clear();
      nameController.clear();
      firstnameController.clear();
      numberController.clear();
      setState(() {
        signUpMessage = '';
      });

      await Future.delayed(Duration(seconds: 1));
      setState(() {});
    }
  }

