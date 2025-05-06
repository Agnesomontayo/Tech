import 'package:flutter/material.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/professionnal_provider.dart';
import '../widgets/WorkerPresentationCard.dart';
import '../widgets/titleWidget.dart';
import 'package:provider/provider.dart';

class MapModalDraggableBottomSheet extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const MapModalDraggableBottomSheet({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<MapModalDraggableBottomSheet> createState() => _MapModalDraggableBottomSheetState();
}

class _MapModalDraggableBottomSheetState extends State<MapModalDraggableBottomSheet> {
  List<dynamic> professionals = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  Future<void> _fetchProfessionals() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      final professionalsProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final responseData = await professionalsProvider.getProfessionalsByCategory(widget.categoryId);
      print('responseData ${responseData}');
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
    _fetchProfessionals();
  }

  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(47.0),
                topRight: Radius.circular(47.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(47.0), topRight: Radius.circular(47.0)),
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
                      Expanded(child: TitleWidget(title: widget.categoryName)),
                    ],
                  ),
                ),
                Expanded(
                  child: professionals.isNotEmpty?
                  CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final professional = professionals[index];
                            return  WorkerPresentationCard(
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
                  )
                  : Center(
                    child: Text(
                    "Aucun professionnel trouvé 😢",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),),
                ),
                SizedBox(height: 50,)
              ],
            )
        );
      },
    );
  }
}
