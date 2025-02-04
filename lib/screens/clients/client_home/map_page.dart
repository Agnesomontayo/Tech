import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/widgets/PageHeaderWidget.dart';

import '../../clients/widgets/RoundedWorkCard.dart';
import '../../clients/widgets/WorkerPresentationCard.dart';
import '../../clients/widgets/menuCirculaireWidget.dart';
import '../../clients/widgets/titleWidget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                children: [
                  PageHeaderWidget()
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
                itemCount: 20,
                itemBuilder: (context, index) {
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
                            work: 'Menuisier',
                            workIcon: AssetsData.menuisierIcon,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext contex){
                                  return DraggableScrollableSheet(
                                    initialChildSize: 0.7,
                                    minChildSize: 0.2,
                                    maxChildSize: 0.9,
                                    builder: (BuildContext context, ScrollController scrollController) {
                                      return Container(
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
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 100.0),
        child: FloatingActionButton(
            backgroundColor: ColorsData.purple00A,
            shape: CircleBorder(),
            onPressed: () => {},
            child: SvgPicture.asset(
                AssetsData.chatIcon
            )
        ),
      ),
    );
  }
}
