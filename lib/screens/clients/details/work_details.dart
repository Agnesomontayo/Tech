import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';
import 'package:tech/screens/clients/widgets/WorkerPresentationCard.dart';
import 'package:provider/provider.dart';
import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';

class WorkDetailPage extends StatefulWidget {
  final int categoryId;
  final String name;
  final String imageUrl;
  const WorkDetailPage({
    super.key,
    required this.categoryId,
    required this.name,
    required this.imageUrl,
  });

  @override
  State<WorkDetailPage> createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  List<dynamic> professionals = [];
  String baseImageUrl = '';
  bool _isLoading = true;

  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchProfessionalsByCategory();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur de chargement des infos : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _fetchProfessionalsByCategory() async {
    try {
      final professionalsProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final responseData = await professionalsProvider.getProfessionalsByCategory(widget.categoryId);

      setState(() {
        professionals = responseData;
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2.0,
      ),
      body: Stack(
        children: [
          widget.imageUrl != null
          ?Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
          )
          : Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              AssetsData.carpenter,
              fit: BoxFit.cover,
              // width: double.infinity,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.75,
            maxChildSize: 0.75,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
                        color: ColorsData.white,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: ColorsData.purple00A,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 60),
                          Expanded(child: TitleWidget(title: widget.name)),
                        ],
                      ),
                    ),
                    Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final professional = professionals[index];
                                  return WorkerPresentationCard(
                                    name: professional['user']['lastName'] + ' ' + professional['user']['firstName'],
                                    rate: 4.5,
                                    availability: professional['availability'],
                                    distance: '500',
                                    unit: 'm',
                                    reviews: '250',
                                    imagePath: professional['user']['avatar'] != null
                                        ? baseImageUrl + '/' + professional['user']['avatar']
                                        : professional['user']['profile_photo_url'],
                                    biography: professional['biography'] != null ?professional['biography'] : 'Rien sur ce profil',
                                    profession: professional['profession']['label'],
                                  );
                                },
                                childCount: professionals.length,
                              ),
                            ),
                          ],
                        ),
                    ),
                    SizedBox(height: 50,)
                  ],
                )
              );
            },
          ),
          Positioned(
            bottom: 70.0,
            right: 16.0,
            child: FloatingActionButton(
              backgroundColor: ColorsData.purple00A,
              shape: CircleBorder(),
                heroTag: 'FAB_Location',
              onPressed: () {
                // Action for the second FAB
              },
              child: SvgPicture.asset(
                  AssetsData.locationIcon
              )
            ),
          ),
        ],
      ),
        floatingActionButton: Container(
          margin: EdgeInsets.symmetric(vertical: 90.0),
          child: FloatingActionButton(
              backgroundColor: ColorsData.purple00A,
              shape: CircleBorder(),
              heroTag: 'FAB_chat',
              onPressed: () => {},
              child: SvgPicture.asset(
                  AssetsData.chatIcon
              )
          ),
        )
    );
  }
}
