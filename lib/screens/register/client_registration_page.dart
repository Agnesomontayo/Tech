// client_registration_page.dart

import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/widgets/CustumInputs.dart';
import 'package:provider/provider.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:tech/screens/widgets/CustumDropdown.dart';

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
    String signUpMessage = ''; // Ajoutez cette ligne pour stocker le message

    bool? rememberMe = false;
    bool isButtonPressed = false;
    bool isLinkPressed = false;
    bool LinkPressed = false;

    @override
    Widget build(BuildContext context) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false); // Obtenir une référence à AuthProvider
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView( // Utiliser SingleChildScrollView pour éviter l'erreur "bottom overflowed"
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
                            keyboardType: TextInputType.phone, // Utiliser TextInputType.phone pour le clavier numérique
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
                            // Handle login button pressed
                            String nom  =  nameController.text;
                            String prenom = firstnameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String cpassword = cpasswordController.text;
                            String phonenumber  =  numberController.text;

                            String signUpResult = await authProvider.signUpClient(
                              nom,
                              prenom,
                              email,
                              password,
                              phonenumber,
                            );
                            // Traiter le résultat de l'inscription
                            if (signUpResult.isEmpty) {
                              // L'inscription a réussi, vous pouvez naviguer vers une nouvelle page par exemple
                              debugPrint('Inscription r\éussie: $signUpResult');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SuccessPage()),
                              );
                            } else {
                              // L'inscription a échoué, affichez un message d'erreur à l'utilisateur
                              debugPrint('Échec de l\'inscription : $signUpResult');
                              setState(() {
                                signUpMessage = signUpResult; // Mettre à jour le message
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
                        SizedBox(height: 10), // Ajoutez un espace vertical
                        Text(
                          signUpMessage, // Utilisez le message stocké dans l'état
                          style: TextStyle(
                            color: Colors.red, // Couleur du texte en fonction du type de message
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
          displacement: 80, // Ajuster la distance de déplacement pour afficher l'indicateur de rafraîchissement (par défaut, c'est 40)
          color: ColorsData.purple00A, // Couleur de l'indicateur de rafraîchissement circulaire
          backgroundColor: Colors.white, // Couleur de fond de l'indicateur de rafraîchissement circulaire
          strokeWidth: 2.5, // Épaisseur du cercle de chargement
          semanticsLabel: "Pull to refresh", // Libellé pour les lecteurs d'écran
          semanticsValue: "Refresh", // Valeur pour les lecteurs d'écran
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

      await Future.delayed(Duration(seconds: 1)); // Simule un chargement asynchrone de données

      setState(() {}); // Pour signaler à Flutter que l'état de la page a changé
    }
  }

