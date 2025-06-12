import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/clients/client_home/all_works.dart';
import 'package:tech/screens/clients/client_home/client_chat_page.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/details/work_details.dart';
import 'package:tech/screens/clients/widgets/chat_button_widget.dart';
import 'package:tech/screens/clients/widgets/logo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/register/successPage.dart';
import 'package:tech/screens/clients/widgets/Search_bar.dart';
import 'package:tech/screens/clients/widgets/menuCirculaireWidget.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import 'package:tech/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:tech/screens/clients/widgets/WorkCardWidget.dart';
import 'package:tech/screens/clients/widgets/CustumAppBar.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';

import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/professionCategory_provider.dart';
import '../../../core/providers/services_provider.dart';
import '../../clients/widgets/ServicePresentationCard.dart';
import 'all_services.dart';


class ClientHome extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String baseImageUrl;
  const ClientHome({
    super.key,
    required this.profile,
    required this.baseImageUrl,
  });
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftButton = false;
  bool _showRightButton = true;

  List<dynamic> categories = [];
  List<dynamic> services = [];
  bool _isLoading = true;
  List<dynamic> topRatedProfessionals = [];


  Future<void> _loadInfos() async {
    try {
      _fetchCategories();
      fetchServices();
      fetchTopRatedProfessionals();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final categoriesProvider = Provider.of<ProfessioncategoryProvider>(context, listen: false);
      final responseData = await categoriesProvider.getManyCategories();

      setState(() {
        categories = responseData;
        //_isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      if (!mounted) return;
      setState(() {
        //_isLoading = false;
      });
    }
  }

  Future<void> fetchServices() async {
    try {
      final serviceProvider = Provider.of<ServicesProvider>(context, listen: false);
      final data = await serviceProvider.getManyServices();
      setState(() {
        services = data.take(20).toList();
      });
    } catch (e) {
      print('Erreur: $e');
      if (!mounted) return;
    }
  }

  Future<void> fetchTopRatedProfessionals() async {
    try {
      final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final data = await professionalProvider.getTopRatedAllProfessionsProfessionals();
      setState(() {
        topRatedProfessionals = data.take(10).toList();
      });
    } catch (e) {
      print('Erreur: $e');
      if (!mounted) return;
    }
  }

  @override
  void initState() {
    super.initState();
    print('profil actuel ${widget.profile}');
    _scrollController.addListener(_scrollListener);
    _loadInfos();
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
    final actualProfil = widget.profile;
    if (actualProfil.isEmpty)
      {
        return Center(child: CircularProgressIndicator());
      }
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
                    GestureDetector(
                      child: Card(
                        color: ColorsData.purple260,
                        surfaceTintColor: ColorsData.purple260,
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
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MenuCirculaireWidget(
                              userId: actualProfil['id'],
                              imageUrl: actualProfil['avatar'] != null && actualProfil['avatar'].toString().isNotEmpty
                                  ? '${widget.baseImageUrl}/${actualProfil['avatar']}'
                                  : actualProfil['profile_photo_url'],
                              typeProfile: actualProfil['typeprofile'],
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: actualProfil != null
                            ? (actualProfil['avatar'] != null
                            ? NetworkImage('${widget.baseImageUrl}/${actualProfil['avatar']}')
                            : NetworkImage(actualProfil['profile_photo_url']))
                            : AssetImage(AssetsData.p) as ImageProvider,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour ${actualProfil['lastName'] ?? ''} ',
                        style: GoogleFonts.commissioner(
                          textStyle: TextStyle(
                            color: ColorsData.purple00A,
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
                          child: TitleWidget(title: 'Métiers par catégories'),
                        ),
                        Container(
                          height: 200,
                          //flex: 0,
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            crossAxisCount: 4,
                            children: List.generate(
                              categories.length > 5 ? 6 : categories.length,
                                  (index) {
                                if (index == 5) {
                                  return WorkCard(
                                    iconPath: AssetsData.plusIcon,
                                    title: 'Plus',
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => AllWorksPage(
                                          clientId: actualProfil['clientId'],
                                          clientName: actualProfil['lastName']+' '+actualProfil['firstName'],
                                        ),
                                      ));
                                    },
                                  );
                                }
                                final category = categories[index];
                                return WorkCard(
                                  iconPath: ('${widget.baseImageUrl}/${category['image']}'),
                                  title: category['label'],
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(
                                        categoryId: category['id'],
                                        name: category['label'],
                                        clientId: actualProfil['clientId'],
                                        clientName: actualProfil['lastName']+' '+actualProfil['firstName'],
                                        imageUrl: ('${widget.baseImageUrl}/${category['image']}'),
                                      ),
                                    ));
                                  },
                                );
                              },
                            ),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllServicesPage(
                                        clientId: actualProfil['clientId'],
                                        clientName: actualProfil['lastName']+' '+actualProfil['firstName'],
                                      )
                                  )
                              );
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
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  final service = services[index];
                                  return ServicePresentationCard(
                                    //iconPath: AssetsData.entretienIcon,
                                    imagePath: ('${widget.baseImageUrl}/${service['image']}'),
                                    serviceName: service['label'] ?? 'Nom inconnu',
                                    clientId: actualProfil['clientId'],
                                    clientName: actualProfil['lastName']+' '+actualProfil['firstName'],
                                    serviceId: service['id'],
                                    //priceRange: '1000FCFA - 3000FCFA', // ou utiliser service['prix'] si dispo
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: TitleWidget(title: 'Les mieux notés'),
                ),
                Container(
                  height: 400,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.all(10),
                              scrollDirection: Axis.horizontal,
                              itemCount: topRatedProfessionals.length,
                              itemBuilder: (context, index) {
                                final professional = topRatedProfessionals[index];
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
                                            backgroundImage: professional['user']['avatar'] != null
                                                ? NetworkImage('${widget.baseImageUrl}/${professional['user']['avatar']}')
                                                : NetworkImage(professional['user']['profile_photo_url']),
                                        ),
                                        ),
                                        SizedBox(height: 6),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            professional['user']['lastName'] + ' ' + professional['user']['firstName'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.karla(
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            professional['profession']['label'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.commissioner(
                                              textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: ColorsData.purple00A,
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                          child: RatingBarIndicator(
                                            rating: professional['average_rating'] ?? 0.0,
                                            itemBuilder: (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        floatingActionButton: ChatButtonWidget(
          currentUserProfileImage: actualProfil['avatar'] != null && actualProfil['avatar'].toString().isNotEmpty
              ? '${widget.baseImageUrl}/${actualProfil['avatar']}'
              : actualProfil['profile_photo_url'],
          currentUserId: actualProfil['id'],
          typeProfile: actualProfil['typeprofile'],
        )
    );
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(
      Duration(seconds: 1),
    );
  }
  @override
  void dispose() {
    _scrollController.dispose();
    //focusNode.dispose();
    super.dispose();
  }
}