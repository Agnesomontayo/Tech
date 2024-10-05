import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/screens/clients/client_home/all_works.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/details/work_details.dart';
import 'package:tech/screens/widgets/logo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/widgets/Search_bar.dart';
import 'package:tech/screens/widgets/titleWidget.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:tech/screens/widgets/WorkCardWidget.dart';
import 'package:tech/screens/widgets/CustumAppBar.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';

import '../../widgets/ServicePresentationCard.dart';


class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
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
      _showRightButton = _scrollController.offset < _scrollController.position.maxScrollExtent;
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
          child:  Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: ColorsData.purple267,
                      surfaceTintColor: ColorsData.purple267,
                      shadowColor: ColorsData.grey,
                      margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 10 ),
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10 ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(AssetsData.p,),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child:  Column(
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
               SearchBarWidget(
                    readonly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                  ),
                //SizedBox(height: 20),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                          child: TitleWidget(title: 'Métiers'),
                        ),
                        Container(
                          height: 200,
                          //flex: 0,
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            crossAxisCount: 4,
                            children:  <Widget>[
                              WorkCard(
                                  iconPath: AssetsData.mecanicienIcon,
                                  title: 'Mécanique',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.menuisierIcon,
                                  title: 'Menuiserie',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.entretienIcon,
                                  title: 'Entretien',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.coutureIcon,
                                  title: 'Couture',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.electricienIcon,
                                  title: 'Electricité',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.coiffeurIcon,
                                  title: 'Coiffure',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.maconIcon,
                                  title: 'Maçonnerie',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WorkDetailPage()
                                        )
                                    );
                                  }
                              ),
                              WorkCard(
                                  iconPath: AssetsData.plusIcon,
                                  title: 'Plus',
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AllWorksPage()
                                        )
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                //SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleWidget(title: 'Les services populaires'),
                       GestureDetector(
                            onTap: () {
                              // Action à réaliser lors du clic
                              print("Lien cliqué !");
                            },
                            child: Text(
                              'Voir Tout',
                              style: TextStyle(
                                color: ColorsData.purple00A,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          )

                    ],
                  )
                  
                ),
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
                                      priceRange: '1000FCFA-3000FCFA'
                                  );;

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
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: TitleWidget(title: 'Les mieux notés'),
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
                                    width: 150,
                                    margin: EdgeInsets.symmetric(horizontal: 0),
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            height: 110,
                                            width: 110,
                                            child: CircleAvatar(
                                              radius: 70,
                                              backgroundImage: AssetImage(AssetsData.best),
                                            )
                                          ),
                                          Text(
                                            'Marie S. $index',
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Menuiserie',
                                            style: GoogleFonts.commissioner(
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: ColorsData.purple00A,
                                                height: 1.0
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 5,
                                            child: RatingBar.builder(
                                              initialRating: 2.5, // Note initiale
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true, // Permet de donner des demi-étoiles
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating); // Affiche la note sélectionnée
                                              },
                                            ),
                                          )
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
                    )

                ),
                SizedBox(height: 90,)
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
            child: SvgPicture.asset(
              AssetsData.chatIcon
            )
          ),
        )
    );
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