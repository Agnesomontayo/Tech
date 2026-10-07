import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import 'package:tech/screens/professionnel/details/notification_page.dart';
import 'package:tech/screens/professionnel/details/requests_list_page.dart';
import 'package:tech/screens/professionnel/widgets/menuCirsulaireWidget.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../details/ranking_page.dart';
import '../widgets/RankingProfessionnalCard.dart';
import '../widgets/chat_button_widget.dart';

class RequestPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String baseImageUrl;
  const RequestPage({
    super.key,
    required this.profile,
    required this.baseImageUrl
  });

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    final actualProfil = widget.profile;
    return actualProfil == null
        ? Center(child: CircularProgressIndicator())
        : DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
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
                        Tab(text: 'Notifications',),
                        Tab(text: 'Classement',)
                      ]
                  ),
                )
            ),
            title:  GestureDetector(
              child: Card(
                color: ColorsData.purple267,
                surfaceTintColor: ColorsData.purple267,
                shadowColor: ColorsData.grey,
                // margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 10 ),
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
          ),
          body: TabBarView(
              children: [
                WorkNotificationPage(
                  professionId: actualProfil['professionalId'],
                  currentFrequency: actualProfil['reminder_frequency'] == null ? '2' : actualProfil['reminder_frequency'].toString(),
                  currentAvailability: actualProfil['availability'],
                ),
                RankingPage(
                  professionId: actualProfil['profession_id'],
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
