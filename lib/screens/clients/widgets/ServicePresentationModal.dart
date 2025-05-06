import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/core/providers/professionnal_provider.dart';
import 'package:tech/screens/clients/widgets/WorkerPresentationCardVertical.dart';
import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/apiHelpers.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/services_provider.dart';

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

  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchServiceProfessions();
      _fetchProfessionalsByService();
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

  Future<void> _fetchProfessionalsByService() async {
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
                                  name: professional['user']['lastName'] + ' ' + professional['user']['firstName'],
                                  rate: 2.5,
                                  reviews: '',
                                  availability: 'dispo',
                                  distance: '255',
                                  unit: 'l',
                                  availabilityColor: Colors.green,
                                  imagePath: professional['user']['avatar'] != null
                                      ? baseImageUrl + '/' + professional['user']['avatar']
                                      : professional['user']['profile_photo_url'],
                                  profession: professional['profession']['label'],
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
                              GestureDetector(
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
                              ),
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

