import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../../core/helpers/utils.dart';

class WorkerPresentationModal extends StatefulWidget {
  final String imagePath;
  final String name;
  final String availability;

  //final Color availabilityColor;
  final String distance;
  final String unit;
  final double rate;
  final String reviews;
  final String biography;
  final String profession;

  const WorkerPresentationModal({
    super.key,
    required this.imagePath,
    required this.name,
    required this.availability,
    // required this.availabilityColor,
    required this.distance,
    required this.unit,
    required this.rate,
    required this.reviews,
    required this.biography,
    required this.profession,
  });

  @override
  State<WorkerPresentationModal> createState() =>
      _WorkerPresentationModalState();
}

class _WorkerPresentationModalState extends State<WorkerPresentationModal> {
  double currentRating = 0.0;
  bool _isClicked = false;
  List<dynamic> clients = [];


  @override
  void initState() {
    super.initState();
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
                            image: widget.imagePath != null &&
                                    widget.imagePath.isNotEmpty
                                ? NetworkImage(widget.imagePath)
                                : AssetImage(AssetsData.menage)
                                    as ImageProvider,
                            fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 0.0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: widget.availability == 'available'
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                      widget.availability == 'available'
                                          ? 'Disponibble'
                                          : 'Indisponible',
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: ColorsData.white),
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                  AssetsData.locationOnIcon,
                                  color: Color(0xFFFB0049),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('A ${widget.distance} ${widget.unit}',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: ColorsData.grey),
                                    )),
                                   /* RatingBar.builder(
                                      initialRating: widget.rate,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 18,
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          currentRating = rating;
                                        });
                                      },
                                    ),*/
                                /* SizedBox(width: 10),
                                    Text(
                                      currentRating.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 14),
                                    ),*/
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                Text(
                                    widget.rate.toString(),
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    )
                                ),

                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(' ${widget.reviews} avis',
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: ColorsData.purple00C),
                                        )),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  capitalizeEachWord(widget.name),
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          ColorsData.purple260.withOpacity(0.5),
                                      //border: Border.all(color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      capitalizeFirstLetter(widget.profession),
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: ColorsData.purple00C,
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isClicked =
                                            !_isClicked; // Inverse l'état à chaque clic
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: ColorsData.purple00C,
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: SvgPicture.asset(
                                        _isClicked
                                            ? AssetsData.favFullIcon
                                            : AssetsData.favIcon,
                                        color: Colors.white,
                                        width: 23,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Enregistrer',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                          color: Color(0xAAA69898),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Présentation du prestataire',
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
                                   widget.biography,
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xAA908A8A),
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
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Quelques clients',
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
                              height: 150,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        clients.isNotEmpty ?
                                        ListView.builder(
                                          padding: EdgeInsets.all(10),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: clients.length,
                                          itemBuilder: (context, index) {
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
                                                        backgroundImage:
                                                            AssetImage(
                                                                AssetsData
                                                                    .best),
                                                      )),
                                                  Text(
                                                    'Marie S. $index',
                                                    style: GoogleFonts.karla(
                                                      textStyle: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            );
                                          },
                                        ) : Center(
                                          child: Text(
                                            "Aucun client trouvé 😢",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
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
                                    'Commander un service',
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
