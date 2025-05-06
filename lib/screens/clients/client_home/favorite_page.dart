import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/widgets/ServicePresentationCard.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../clients/widgets/menuCirculaireWidget.dart';
import '../widgets/PageHeaderWidget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeaderWidget(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: TitleWidget(title: 'Vos services préférés'),
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
                                            //iconPath: AssetsData.entretienIcon,
                                            imagePath: AssetsData.menage,
                                            serviceName:
                                                'Nettoyage complet $index',
                                            //priceRange: '1000FCFA-3000FCFA'
                                        );
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
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        child: TitleWidget(title: 'Vos petits chouchous'),
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
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 0),
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
                                                    backgroundImage: AssetImage(
                                                        AssetsData.best),
                                                  )),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          ColorsData.purple00A,
                                                      height: 1.0),
                                                ),
                                              ),
                                            ],
                                          )),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
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
      ),
    );

  }

  @override
  void dispose() {
    _scrollController.dispose();
    //focusNode.dispose();
    super.dispose();
  }
}
