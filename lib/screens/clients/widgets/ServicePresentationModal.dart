import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/clients/widgets/WorkerPresentationCardVertical.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/services_provider.dart';
import '../client_forms/new_request_form.dart';

class ServicePresentationModal extends StatefulWidget {
  final String imagePath;
  final String label;
  final String availability;
  final Color availabilityColor;
  final String distance;
  final String unit;
  final double rate;
  final String reviews;
  final String description;
  final int serviceId;
  final int clientId;
  final String? clientName;

  const ServicePresentationModal({
    super.key,
    required this.imagePath,
    required this.label,
    required this.availability,
    required this.availabilityColor,
    required this.distance,
    required this.unit,
    required this.rate,
    required this.reviews,
    required this.description,
    required this.serviceId,
    required this.clientId,
    this.clientName,
  });

  @override
  State<ServicePresentationModal> createState() => _ServicePresentationModalState();
}

class _ServicePresentationModalState extends State<ServicePresentationModal> {
  List<dynamic> professions = [];
  List<dynamic> professionals = [];
  bool _isLoading = true;
  String baseImageUrl = '';
  double currentRating = 0.0;
  bool _isClicked = false;
  LocationData? _currentLocation;
  final Location _location = Location();
  final Set<Marker> _markers = {};

  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      await _loadClientLocation();
      _fetchServiceProfessions();
      //_fetchProfessionalsByService();
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }



  Future<void> _fetchServiceProfessions() async {
    try {
      final serviceProvider = Provider.of<ServicesProvider>(context, listen: false);
      final data = await serviceProvider.getServiceProfessions(widget.serviceId);
      setState(() {
        professions = data;
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /*Future<void> _fetchProfessionalsByService() async {
    try {
      final professionalProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final data = await professionalProvider.getProfessionalsByService(widget.serviceId);
      setState(() {
        professionals = data;
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }*/

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
      final response = await dio.get('${baseUrl}/locations/nearby-by-services', queryParameters: {
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
        'radius': 10,
        'service_id': widget.serviceId,
      });
      setState(() {
        professionals = response.data['professionals'];
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

  void _openFormModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewRequestFormModal(clientId: widget.clientId, clientName: widget.clientName, serviceId: widget.serviceId, serviceLabel: widget.label),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadInfos();
    currentRating = widget.rate;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(43.0),
            topRight: Radius.circular(43.0),
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Container(
                      height: 230,
                      //width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(43.0),
                        image: DecorationImage(
                            image: widget.imagePath != null && widget.imagePath.isNotEmpty
                                ? NetworkImage(widget.imagePath)
                                : AssetImage(AssetsData.menage) as ImageProvider,
                            fit: BoxFit.fill
                        ),
                      ),
                    ),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.label,
                                    //maxLines: 2,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                //Spacer(),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isClicked = !_isClicked;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 8.0),
                                        padding: EdgeInsets.all(10.0),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: ColorsData.purple00C,
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: SvgPicture.asset(
                                          _isClicked ? AssetsData.favFullIcon  :  AssetsData.favIcon,
                                          color:  Colors.white ,
                                          width: 23,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Enregistrer',
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            color: Color(0x55050505),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Description  de la profession',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.description,
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0x55050505),
                                      ),
                                    ),
                                    textAlign: TextAlign.justify,
                                    maxLines: null,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Professions associées à ce service',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              color: Color(0xC3F3F3F3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: professions.map((profession) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: ColorsData.purple260.withOpacity(0.5),
                                      //border: Border.all(color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      profession['label'],
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: ColorsData.purple00C,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Les prestataires disponibles',
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                Container(
                  height: 250,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            professionals.isNotEmpty
                                ? ListView.builder(
                              padding: EdgeInsets.all(10),
                              scrollDirection: Axis.horizontal,
                              itemCount: professionals.length,
                              itemBuilder: (context, index) {
                                final professional = professionals[index];
                                return WorkerPresentationCardVertical(
                                  name: professional['lastName'] + ' ' + professional['firstName'],
                                  rate: (professional['average_rating'] ?? 0).toDouble(),
                                  reviews: professional['review_count'],
                                  availability: professional['availability'],
                                  distance: professional['distance'],
                                  unit: 'l',
                                  imagePath: professional['avatar'] != null
                                      ? baseImageUrl + '/' + professional['avatar']
                                      : professional['profile_photo_url'],
                                  profession: professional['profession_name'],
                                  serviceId: widget.serviceId,
                                  clientId: widget.clientId,
                                  clientName: widget.clientName,
                                  serviceLabel: widget.label,
                                  professionalId: professional['professional_id'],
                                );
                              },
                            )
                                : Center(
                              child: Text(
                                "Aucun professionnel trouvé",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: ColorsData.purple00C,
                                      borderRadius:
                                      BorderRadius.circular(20.0)),
                                  child: Text(
                                    'Commander le service',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: ColorsData.white),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _openFormModal(context);
                                  print('bla');
                                },
                              ),*/
                              /*
                              Spacer(),
                              GestureDetector(
                                child: Container(
                                  width: 46,
                                  height: 46,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: ColorsData.purple00C,
                                      borderRadius: BorderRadius.circular(30.0)
                                  ),
                                  child: SvgPicture.asset(
                                    AssetsData.userIcon,
                                    color: ColorsData.white,
                                    width: 25,
                                    height: 25,
                                  ),
                               )
                              ),
                              SizedBox(width: 10.0,),
                              GestureDetector(
                                  child: Container(
                                    width: 46,
                                    height: 46,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: ColorsData.purple00C,
                                        borderRadius: BorderRadius.circular(30.0)
                                    ),
                                    child: SvgPicture.asset(
                                      AssetsData.shareIcon,
                                      color: ColorsData.white,
                                      width: 25,
                                      height: 25,
                                    ),
                                  )
                              )
*/
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}

