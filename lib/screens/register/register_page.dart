import 'package:flutter/material.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../clients/register/client_registration_page.dart';
import '../professionnel/register/professional_registration_page.dart';
import 'package:tech/screens/clients/widgets/CustumInputs.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool isLinkPressed = false;
  bool isClientSelected = false;
  bool isProfessionalSelected = false;

  void selectClient() {
    setState(() {
      isClientSelected = true;
      isProfessionalSelected = false;
    });
  }

  void selectProfessional() {
    setState(() {
      isClientSelected = false;
      isProfessionalSelected = true;
    });
  }

  void nextPage() {
    if (_currentPageIndex < 2 && (isClientSelected || isProfessionalSelected)) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }}

  void previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }
  void reloadPage() {
    setState(() {
      isClientSelected = false;
      isProfessionalSelected = false;
      _currentPageIndex = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1)); // Simuler un délai de rafraîchissement
          setState(() {
            reloadPage(); // Réinitialiser les valeurs et recharger la page
          });
        },
     child: SingleChildScrollView(
       physics: AlwaysScrollableScrollPhysics(),
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
            SizedBox(height: 200),
            Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 0.0,
                  top: 220.0,
                  bottom: 0.0,
                ),
              child: Text(
                'Etes-vous un(e) :',
                style: GoogleFonts.karla(
                  textStyle:  TextStyle(
                    color:  ColorsData.black ,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 0.0,
                  top: 300.0,
                  bottom: 0.0,
                ),

                child: Row( // Utilisation de Row pour placer les cercles sur la même ligne
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isClientSelected = true;
                          isProfessionalSelected = false;
                          _currentPageIndex = 0;
                        });
                      },
                     // behavior: HitTestBehavior.translucent,
                      child: Column(
                        children: [
                          Container(
                            width: 130, // Ajuster la taille du cercle du client
                            height: 130, // Ajuster la taille du cercle du client
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isClientSelected ? ColorsData.purple255 : ColorsData.purple255,
                             /* border: isClientSelected
                                  ? Border.all(
                                color: ColorsData.white, // Couleur de la bordure
                                width: 3, // Épaisseur de la bordure
                              )
                                  : null, // Pas de bordure lorsque non sélectionné*/
                              boxShadow: isClientSelected
                                  ? [
                                BoxShadow(
                                  color: ColorsData.purple00A,
                                  spreadRadius: 6,
                                  blurRadius: 0,
                                  offset: Offset(0,0),
                                ),
                                BoxShadow(
                                  color: ColorsData.white,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(0,0),
                                ),
                              ]
                                  : [],
                            ),
                            child: ClipOval(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Transform.scale(
                                  scale: 0.8, // Ajuster la taille de l'image
                                  child: SvgPicture.asset(
                                    AssetsData.clientIcon,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Client',
                            style: GoogleFonts.karla(
                              textStyle: isClientSelected ? TextStyle(
                                color:  ColorsData.purple00A ,
                                fontWeight: FontWeight.bold,
                              ) : TextStyle(
                                color:   Colors.black,
                                fontWeight: FontWeight.bold,
                              ) ,
                            ),
                          ),
                        ],
                      ),

                    ),
                    SizedBox(width: 50),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isClientSelected = false;
                          isProfessionalSelected = true;
                          _currentPageIndex = 0; // Définir l'étape du formulaire pour le professionnel
                        });
                      },
                     // behavior: HitTestBehavior.translucent,
                      child: Column(
                        children: [
                          Container(
                            width: 130, // Ajuster la taille du cercle du professionnel
                            height: 130, // Ajuster la taille du cercle du professionnel
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isProfessionalSelected ? ColorsData.purple255 : ColorsData.purple255,
                              boxShadow: isProfessionalSelected
                                  ? [
                                BoxShadow(
                                  color: ColorsData.purple00A,
                                  spreadRadius: 6,
                                  blurRadius: 0,
                                  offset: Offset(0,0),
                                ),
                                BoxShadow(
                                  color: ColorsData.white,
                                  spreadRadius: 3,
                                  blurRadius: 0,
                                  offset: Offset(0,0),
                                ),
                              ]
                                  : [],
                            ),
                            child: ClipOval(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Transform.scale(
                                  scale: 0.8, // Ajuster la taille de l'image
                                  child: SvgPicture.asset(
                                    AssetsData.workerIcon,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Professionnel',
                            style: GoogleFonts.karla(
                                textStyle: isProfessionalSelected ? TextStyle(
                                color:  ColorsData.purple00A ,
                                fontWeight: FontWeight.bold,
                              ) : TextStyle(
                                  color:   Colors.black,
                                  fontWeight: FontWeight.bold,
                                ) ,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 0.0,
                  top: 650.0,
                  bottom: 0.0,
                ),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLinkPressed = !isLinkPressed; // Inverser l'état du lien lorsqu'il est cliqué
                    });
                    // Ajouter ici la navigation vers la page d'inscription
                    // Par exemple, si vous utilisez les routes nommées, vous pouvez utiliser :
                    Navigator.pushNamed(context, '/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Vous avez déjà un compte? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        // decoration: isLinkPressed ? TextDecoration.underline : TextDecoration.none, // Souligner le texte si le lien est cliqué
                      ),
                      children: [
                        TextSpan(
                          text: "Connectez vous",
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
            )
            ),
            Container(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 290.0,
                    top: 550.0,
                    bottom: 0.0,
                  ),
                  child:  GestureDetector(
                    onTap: () {
                      if (isClientSelected || isProfessionalSelected) {
                        if (isClientSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientRegistrationPage(),
                            ),
                          ).then((value) {
                            reloadPage(); // Appelé après que l'utilisateur revient à cette page
                          });
                        } else if (isProfessionalSelected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfessionalRegistrationPage(),
                            ),
                          ).then((value) {
                            reloadPage(); // Appelé après que l'utilisateur revient à cette page
                          });
                        }
                      }
                    },
                    child: Text(
                      "Suivant",
                      style: TextStyle(
                        color: (isClientSelected || isProfessionalSelected)
                            ? ColorsData.purple00A
                            : Colors.grey, // Couleur désactivée lorsque rien n'est sélectionné
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
            ),

          /*  if (isClientSelected || isProfessionalSelected)
              IndexedStack(
                index: _currentPageIndex,
                children: [
                  if (isClientSelected) ClientRegistrationPage(),
                  if (isProfessionalSelected) ProfessionalRegistrationPage(),
                ],
              ),*/

          ],
        ),
      ),
        displacement: 80, // Ajuster la distance de déplacement pour afficher l'indicateur de rafraîchissement (par défaut, c'est 40)
        color: ColorsData.purple00A, // Couleur de l'indicateur de rafraîchissement circulaire
        backgroundColor: Colors.white, // Couleur de fond de l'indicateur de rafraîchissement circulaire
        strokeWidth: 2.5, // Épaisseur du cercle de chargement
        semanticsLabel: "Pull to refresh", // Libellé pour les lecteurs d'écran
        semanticsValue: "Refresh", // Valeur pour les lecteurs d'écran

    )
    );
  }
}