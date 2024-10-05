import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/widgets/titleWidget.dart';
import 'package:tech/screens/widgets/WorkerPresentationCard.dart';

import '../../../core/const/assets.dart';

class WorkDetailPage extends StatefulWidget {
  const WorkDetailPage({super.key});

  @override
  State<WorkDetailPage> createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2.0,
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            AssetsData.carpenter,
            fit: BoxFit.cover,
           // width: double.infinity,
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
                          Expanded(child: TitleWidget(title: 'Menuiserie')),
                        ],
                      ),
                    ),
                    Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return WorkerPresentationCard(
                                    name: 'Abraham Monie $index',
                                    rate: 4.5,
                                    availability: 'Disponible',
                                    availabilityColor: Colors.green,
                                    distance: '500',
                                    unit: 'm',
                                    reviews: '250',
                                    imagePath: AssetsData.best,
                                    description: 'lhfzmoaijgapzhgpoakezngioznggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg',
                                  );
                                },
                                childCount: 20,
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
