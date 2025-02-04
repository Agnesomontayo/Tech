import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/professionnel/widgets/menuCirsulaireWidget.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../clients/client_home/all_services.dart';
import '../../clients/client_home/all_works.dart';
import '../../clients/details/work_details.dart';
import '../../professionnel/widgets/ServicePresentationCard.dart';
import '../../clients/widgets/WorkCardWidget.dart';
import '../../clients/widgets/titleWidget.dart';

class ProfessionnelHome extends StatefulWidget {
  const ProfessionnelHome({super.key});

  @override
  State<ProfessionnelHome> createState() => _ProfessionnelHomeState();
}

class _ProfessionnelHomeState extends State<ProfessionnelHome> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftButton = false;
  bool _showRightButton = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _showLeftButton = _scrollController.offset > 0;
      _showRightButton =
          _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Card(
                          color: ColorsData.purple267,
                          surfaceTintColor: ColorsData.purple267,
                          shadowColor: ColorsData.grey,
                          margin: EdgeInsetsDirectional.symmetric(
                              horizontal: 15, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SvgPicture.asset(
                            AssetsData.menuIcon,
                            fit: BoxFit.scaleDown,
                            width: 38, // Largeur souhaitée
                            height: 37,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MenuCirculaireWidget();
                            },
                          );
                        },
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                            AssetsData.p,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour ',
                          style: GoogleFonts.commissioner(
                            textStyle: TextStyle(
                              color: ColorsData.purple13,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'Comment pouvons-nous vous aider aujourd\'hui',
                          style: GoogleFonts.commissioner(
                            textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 20),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8.0),
                            child: TitleWidget(title: 'Vos statistiques'),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            //flex: 0,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 8.0),
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFD9D9D),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          alignment: Alignment.center,
                                          // Centrer le texte
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    AssetsData.groupsIcon,
                                                    fit: BoxFit.scaleDown,
                                                    width: 20,
                                                    height: 18,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Vos clients',
                                                      style: GoogleFonts
                                                          .commissioner(
                                                        textStyle: TextStyle(
                                                          color:
                                                              ColorsData.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '100.000',
                                                  style:
                                                      GoogleFonts.commissioner(
                                                    textStyle: TextStyle(
                                                      color: ColorsData.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(width: 5),
                                    // Espacement entre les deux conteneurs
                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 8.0),
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFFCDF94),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          alignment: Alignment.center,
                                          // Centrer le texte
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    AssetsData.ratesIcon,
                                                    fit: BoxFit.scaleDown,
                                                    width: 18,
                                                    height: 18,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Notes',
                                                      style: GoogleFonts
                                                          .commissioner(
                                                        textStyle: TextStyle(
                                                          color:
                                                              ColorsData.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '4.5',
                                                  style:
                                                      GoogleFonts.commissioner(
                                                    textStyle: TextStyle(
                                                      color: ColorsData.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  //SizedBox(height: 20),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Ils vous font plus confiance que les autres ',
                          style: GoogleFonts.commissioner(
                            textStyle: TextStyle(
                              color: ColorsData.purple13,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Le cercle de gauche
                              Transform.translate(
                                offset: Offset(-90, 10),
                                // Décalage pour positionner le cercle à gauche
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 1'),
                                  ),
                                ),
                              ),

                              // Le cercle de droite
                              Transform.translate(
                                offset: Offset(85, 10),
                                // Décalage pour positionner le cercle à droite
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 3'),
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0, 35),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 2'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          'Les prestataires les plus populaires ',
                          style: GoogleFonts.commissioner(
                            textStyle: TextStyle(
                              color: ColorsData.purple13,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Le cercle de gauche
                              Transform.translate(
                                offset: Offset(-110, 0),
                                // Décalage pour positionner le cercle à gauche
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 1'),
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-55, 0),
                                // Décalage pour positionner le cercle à gauche
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 2'),
                                  ),
                                ),
                              ),

                              // Le cercle de droite
                              Transform.translate(
                                offset: Offset(110, 0),
                                // Décalage pour positionner le cercle à droite
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child:
                                    Text('Box 5'),
                                  ),
                                ),
                              ),

                              // Le cercle de droite
                              Transform.translate(
                                offset: Offset(55, 0),
                                // Décalage pour positionner le cercle à droite
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 4'),
                                  ),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0, 0),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(60.0),
                                  ),
                                  child: Center(
                                    child: Text('Box 3'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleWidget(title: 'Services tendances'),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllServicesPage()));
                            },
                            child: Text(
                              'Voir Tout',
                              style: TextStyle(
                                  color: ColorsData.purple00A,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      )),
                  Container(
                    height: 230,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  scrollDirection: Axis.horizontal,
                                  controller: _scrollController,
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return ServicePresentationCard(
                                        iconPath: AssetsData.entretienIcon,
                                        imagePath: AssetsData.menage,
                                        serviceName: 'Nettoyage complet $index',
                                        priceRange: '1000FCFA-3000FCFA');
                                  },
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Visibility(
                                    visible: _showLeftButton,
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      color: ColorsData.white,
                                      surfaceTintColor: ColorsData.white,
                                      shape: CircleBorder(),
                                      child: IconButton(
                                        style: IconButton.styleFrom(
                                          shape: CircleBorder(),
                                        ),
                                        hoverColor: Colors.transparent,
                                        icon: Icon(
                                          Icons.chevron_left,
                                          color: ColorsData.purple00A,
                                          size: 30,
                                        ),
                                        onPressed: _scrollLeft,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Visibility(
                                    visible: _showRightButton,
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      color: ColorsData.white,
                                      surfaceTintColor: ColorsData.white,
                                      shape: CircleBorder(),
                                      child: IconButton(
                                        style: IconButton.styleFrom(
                                          shape: CircleBorder(),
                                        ),
                                        hoverColor: Colors.transparent,
                                        icon: Icon(
                                          Icons.chevron_right,
                                          color: ColorsData.purple00A,
                                          size: 30,
                                        ),
                                        onPressed: _scrollRight,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: TitleWidget(title: 'Nos petits conseils'),
                  ),
                  Container(
                      height: 200,
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 300,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: ColorsData.purple13,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Marie S. $index',
                                                style: GoogleFonts.karla(
                                                  textStyle: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
            ),
          ),
          displacement: 80,
          color: ColorsData.purple00A,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          semanticsLabel: "Pull to refresh",
          semanticsValue: "Refresh",
        ),
        // extendBody: true,
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(vertical: 100.0),
          child: FloatingActionButton(
              backgroundColor: ColorsData.purple00A,
              shape: CircleBorder(),
              onPressed: () => {},
              child: SvgPicture.asset(AssetsData.chatIcon)),
        ));
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    //focusNode.dispose();
    super.dispose();
  }
}
