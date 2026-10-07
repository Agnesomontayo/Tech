import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/details/appointment_tracking_page.dart';
import 'package:tech/screens/clients/details/favorite_detail_page.dart';
import 'package:tech/screens/clients/widgets/ServicePresentationCard.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../../clients/widgets/menuCirculaireWidget.dart';
import '../details/appointment_page.dart';
import '../widgets/PageHeaderWidget.dart';
import '../widgets/chat_button_widget.dart';
import 'client_chat_page.dart';

class FavoritePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String baseImageUrl;
  const FavoritePage({
    super.key,
    required this.profile,
    required this.baseImageUrl,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final actualProfil = widget.profile;
    return actualProfil == null
        ? Center(child: CircularProgressIndicator())
        :DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: ColorsData.purple00A.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TabBar(
                      labelStyle: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: ColorsData.white,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: ColorsData.purple00A
                      ),
                      //labelColor: Colors.white,
                      tabs: [
                        Tab(text: 'Rendez-vous',),
                        Tab(text: 'Favoris',)
                      ]
                  ),
                )
            ),
            title:   PageHeaderWidget(
              userId: actualProfil['id'],
              imageUrl: actualProfil['avatar'] != null && actualProfil['avatar'].toString().isNotEmpty
                  ? '${widget.baseImageUrl}/${actualProfil['avatar']}'
                  : actualProfil['profile_photo_url'],
              typeProfile: actualProfil['typeprofile'],
            ),
          ),
          body: TabBarView(
              children: [
                AppointmentPage(
                  clientId: actualProfil['clientId'],
                  currentUserId: actualProfil['id'],
                ),
                FavoriteDetailPage(
                  profile: actualProfil,
                  baseImageUrl: widget.baseImageUrl,
                )
              ]
          ),
          floatingActionButton: ChatButtonWidget(
            currentUserProfileImage: actualProfil['avatar'] != null && actualProfil['avatar'].toString().isNotEmpty
                ? '${widget.baseImageUrl}/${actualProfil['avatar']}'
                : actualProfil['profile_photo_url'],
            currentUserId: actualProfil['id'],
            typeProfile: actualProfil['typeprofile'],
          ),
        )
    );
  }

  }
