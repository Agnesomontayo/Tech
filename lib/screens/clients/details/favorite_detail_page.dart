import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/providers/client_provider.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../client_home/client_chat_page.dart';
import '../widgets/PageHeaderWidget.dart';
import '../widgets/ServicePresentationCard.dart';
import '../widgets/titleWidget.dart';
import 'package:provider/provider.dart';


class FavoriteDetailPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String baseImageUrl;
  const FavoriteDetailPage({
    super.key,
    required this.profile,
    required this.baseImageUrl,
  });

  @override
  State<FavoriteDetailPage> createState() => _FavoriteDetailPageState();
}

class _FavoriteDetailPageState extends State<FavoriteDetailPage> {
  //Map<String, dynamic>? actualProfil;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _showLeftButton = false;
  bool _showRightButton = true;
  Map<String, dynamic>? mostRequested;
  List<dynamic> services = [];
  List<dynamic> professionals = [];

  Future<void> fetchMostRequestedProfessionalsAndServices() async {
    try {
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      final data = await clientProvider.getMostRequestedProfessionalsAndServices(widget.profile['clientId']);
      setState(() {
        mostRequested = data;//.take(10).toList();
        services = mostRequested?['most_requested_services'].take(20).toList();
        professionals = mostRequested?['most_requested_professionals'].take(10).toList();
      });
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMostRequestedProfessionalsAndServices();
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
    final actualProfil = widget.profile;
    return actualProfil == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                      itemCount: services.length,
                                      itemBuilder: (context, index) {
                                        final service = services[index];
                                        return ServicePresentationCard(
                                          //iconPath: AssetsData.entretienIcon,
                                          imagePath: ('${widget.baseImageUrl}/${service['service_image']}'),
                                          serviceName: service['service_label'] ?? '',
                                          clientId: actualProfil['clientId'],
                                          clientName: actualProfil['lastName']+' '+actualProfil['firstName'],
                                          serviceId: service['service_id'],
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
                                      itemCount: professionals.length,
                                      itemBuilder: (context, index) {
                                        final professional = professionals[index];
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
                                                        backgroundImage: professional['professional_avatar'] != null
                                                            ? NetworkImage('${widget.baseImageUrl}/${professional['professional_avatar']}')
                                                            : NetworkImage(professional['professional_profile_photo_url']),
                                                      )),
                                                  Text(
                                                      professional['professional_lastName'] + ' ' + professional['professional_firstName'],
                                                    style: GoogleFonts.karla(
                                                      textStyle: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      professional['professiona_profession'],
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
      /*floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 100.0),
        child: FloatingActionButton(
            backgroundColor: ColorsData.purple00A,
            shape: CircleBorder(),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClientChatPage(
                      currentUserProfileImage: actualProfil!['avatar'] != null && actualProfil!['avatar'].toString().isNotEmpty
                          ? '${widget.baseImageUrl}/${actualProfil!['avatar']}'
                          : actualProfil!['profile_photo_url'],
                      currentUserId: actualProfil?['id'],
                      typeProfile: actualProfil?['typeprofile'],
                    )),
              ),
            },
            child: SvgPicture.asset(
                AssetsData.chatIcon
            )
        ),
      ),*/
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    //focusNode.dispose();
    super.dispose();
  }
}
