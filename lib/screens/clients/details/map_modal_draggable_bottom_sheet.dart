import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/helpers/utils.dart';
import '../../../core/providers/professionnal_provider.dart';
import '../widgets/WorkerPresentationCard.dart';
import '../widgets/titleWidget.dart';
import 'package:provider/provider.dart';

class MapModalDraggableBottomSheet extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String clientName;
  final int clientId;

  const MapModalDraggableBottomSheet({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.clientName,
    required this.clientId,
  });

  @override
  State<MapModalDraggableBottomSheet> createState() => _MapModalDraggableBottomSheetState();
}

class _MapModalDraggableBottomSheetState extends State<MapModalDraggableBottomSheet> {
  List<dynamic> professionals = [];
  bool _isLoading = true;
  String baseImageUrl = '';
  LocationData? _currentLocation;
  final Location _location = Location();
  final Set<Marker> _markers = {};

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




  Future<void> _loadInfos() async {
    try {
      await _loadClientLocation();
     // _fetchProfessionals();
    } catch (error) {
      print('Erreur de chargement des infos : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadClientLocation() async {
    final permission = await _location.requestPermission();
    if (permission != PermissionStatus.granted) return;

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    final loc = await _location.getLocation();
    setState(() => _currentLocation = loc);

    await _fetchNearbyProfessionals();
  }

  Future<void> _fetchNearbyProfessionals() async {
    if (_currentLocation == null) return;

    final dio = Dio();
    try {
      String baseUrl = await ApiHelper.getApiUrl();
      final response = await dio.get('${baseUrl}/locations/nearby-by-categories', queryParameters: {
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
        'radius': 10,
        'category_id': widget.categoryId,
      });
      setState(() {
        professionals = response.data;
        _isLoading = false;
      });
      
      print('professionels avec notes ${professionals}');

    } catch (e) {
      print("Erreur API: $e");
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
                              name: professional['lastName'] + ' ' + professional['firstName'],
                              rate: professional['average_rating'],
                              availability: professional['availability'],
                              distance: professional['distance'],
                              unit: 'm',
                              reviews: professional['review_count'],
                              imagePath: professional['avatar'] != null
                                  ? baseImageUrl + '/' + professional['avatar']
                                  : professional['profile_photo_url'],
                              biography: professional['biography'] != null ?professional['biography'] : 'Rien sur ce profil',
                              profession: professional['profession_name'],
                              clientId: widget.clientId,
                              clientName: widget.clientName,
                              professionalId: professional['professional_id'],
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
