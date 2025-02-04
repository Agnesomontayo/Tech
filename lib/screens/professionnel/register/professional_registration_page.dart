// professional_registration_page.dart

import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/models/profession.dart';
import 'package:tech/core/models/profession.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/clients/widgets/CustumInputs.dart';
import 'package:tech/screens/clients/widgets/CustumDropdown.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:tech/core/providers/auth_provider.dart';

import '../../../core/models/profession.dart';

class ProfessionalRegistrationPage extends StatefulWidget {
  @override
  _ProfessionalRegistrationPageState createState() => _ProfessionalRegistrationPageState();
}

class _ProfessionalRegistrationPageState  extends State<ProfessionalRegistrationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  bool? rememberMe = false;
  bool isButtonPressed = false;
  bool isLinkPressed = false;
  String? selectedValue;
  String errorMessage = '';
  List<Profession> professions = [];
  int? selectedProfessionId;// Liste des professions
  //Profession? selectedProfession; // Utiliser le type Profession au lieu d'int

  bool isRefreshing = false;



  @override
  void initState() {
    super.initState();
    fetchProfessions();
  }

  Future<void> fetchProfessions() async {
    try {
      final response = await Dio().get('http://192.168.116.185:8000/api/professions');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Profession> professionList = data.map((item) => Profession.fromJson(item)).toList();
        setState(() {
          professions = professionList;
        });
      } else {
        print('Réponse non réussie. Code de statut : ${response.statusCode}');
      }
    } catch (error) {
      // Gérer les erreurs
      print('Erreur lors de la récupération des professions : $error');
    }
  }


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
                    Builder(
                      builder: (BuildContext context) {
                        // Utiliser un Builder pour envelopper le CustomDropdown
                        return
                          CustomDropdown(
                            value: selectedProfessionId, // Utiliser null pour afficher une valeur vide pendant le rafraîchissement
                            hintText: 'Select a profession',
                            prefixIcon: Icon(
                              Icons.work_outline_rounded,
                              color: ColorsData.purple00A,
                              size: 22,
                            ),
                            onChanged: (value) {
                              final selectedProfession = professions.firstWhere((profession) => profession.id == value);
                              setState(() {
                                selectedProfessionId = value;// Assurez-vous que value est de type Profession
                              });
                            },

                            options: professions.map((Profession profession) {
                              return DropdownOption(
                                value: profession.id,  // Assurez-vous que la valeur correspond à ce que vous attendez
                                label: profession.label,
                              );
                            }).toList(),
                          );
                      },
                    ),
                    SizedBox(height: 30),
                    CustomTextInput(
                        hintText: 'Nombre d année d experience',
                        controller: experienceController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(
                          Icons.work_outline_rounded,
                          color: ColorsData.purple00A,
                          size: 22,
                        )
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle login button pressed
                        String nom = nameController.text;
                        String prenom = firstnameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;
                        String cpassword = cpasswordController.text;
                        String phonenumber = numberController.text;
                        String experience = experienceController.text;

                        if (password == cpassword) {
                          // Les mots de passe correspondent, procédez à l'inscription

                          // Affichez un log avant l'inscription
                          debugPrint('Tentative d\'inscription...');

                          print('Nom: $nom');
                          print('Prénom: $prenom');
                          print('Email: $email');
                          print('Numéro de téléphone: $phonenumber');
                          print('Expérience: $experience');
                          print('Profession ID: $selectedProfessionId');

                          String signUpResult = await authProvider.signUpProfessional(
                            nom,
                            prenom,
                            email,
                            password,
                            phonenumber,
                            experience,
                            selectedProfessionId.toString(),
                          );

                          // Traitez le résultat de l'inscription
                          if (signUpResult.isEmpty) {
                            // L'inscription a réussi

                            // Affichez un log après l'inscription réussie
                            debugPrint('Inscription réussie');

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SuccessPage()),
                            );
                          } else {
                            // L'inscription a échoué

                            // Affichez un log en cas d'échec d'inscription
                            debugPrint('Échec de l\'inscription : $signUpResult');

                            setState(() {
                              errorMessage = signUpResult;
                              isButtonPressed = !isButtonPressed;
                            });
                          }
                        } else {
                          // Les mots de passe ne correspondent pas

                          // Affichez un log en cas de non-correspondance des mots de passe
                          debugPrint('Les mots de passe ne correspondent pas');

                          setState(() {
                            errorMessage = 'Les mots de passe ne correspondent pas';
                          });
                        }
                        setState(() {
                          isButtonPressed = !isButtonPressed; // Inverser la valeur de isButtonPressed
                        });
                      },
                      /*style: ElevatedButton.styleFrom(
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
    experienceController.clear();
    //resetDropdown(); // Réinitialiser le dropdown


    await Future.delayed(Duration(seconds: 1)); // Simule un chargement asynchrone de données

    setState(() {}); // Pour signaler à Flutter que l'état de la page a changé
  }
}
