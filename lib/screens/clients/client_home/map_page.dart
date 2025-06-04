import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/widgets/PageHeaderWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/professionCategory_provider.dart';
import '../../../core/providers/professionnal_provider.dart';
import '../../clients/widgets/RoundedWorkCard.dart';
import '../../clients/widgets/WorkerPresentationCard.dart';
import '../../clients/widgets/menuCirculaireWidget.dart';
import '../../clients/widgets/titleWidget.dart';
import '../details/map_modal_draggable_bottom_sheet.dart';
import '../widgets/chat_button_widget.dart';
import 'client_chat_page.dart';

class MapPage extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String baseImageUrl;
  const MapPage({
    super.key,
    required this.profile,
    required this.baseImageUrl,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<dynamic> categories = [];
  List<dynamic> professionals = [];
  bool _isLoading = true;

  Future<void> _loadInfos() async {
    try {
      _fetchCategories();
    } catch (error) {
      print('Erreur de chargement des infos : $error');
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
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInfos();
  }

  @override
  Widget build(BuildContext context) {
    final actualProfil = widget.profile;
    return actualProfil == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      body:  Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                children: [
                  PageHeaderWidget(
                    userId: actualProfil['id'],
                    imageUrl: actualProfil['avatar'] != null && actualProfil['avatar'].toString().isNotEmpty
                        ? '${widget.baseImageUrl}/${actualProfil['avatar']}'
                        : actualProfil['profile_photo_url'],
                  )
                ],
              )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 100),
              height: 60,
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: ColorsData.purple266,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: GestureDetector(
                          child: RoundedWorkCard(
                            work: category['label'],
                            workIcon: ('${widget.baseImageUrl}/${category['image']}'),
                          ),
                          onTap: () {
                            final categoryId = category['id'];
                            final categoryName = category['label'];
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context){
                                  return MapModalDraggableBottomSheet(
                                    categoryId: categoryId,
                                    categoryName: categoryName,
                                    clientName: actualProfil['name'],
                                    clientId: actualProfil['id'],
                                  );
                                }
                            );
                          }
                      )
                  );
                },
              ),

            ),
          )
        ],
      ),
      floatingActionButton: ChatButtonWidget(
        currentUserProfileImage: actualProfil['avatar'] != null && actualProfil['avatar'].toString().isNotEmpty
            ? '${widget.baseImageUrl}/${actualProfil['avatar']}'
            : actualProfil['profile_photo_url'],
        currentUserId: actualProfil['id'],
      ),
    );
  }
}
