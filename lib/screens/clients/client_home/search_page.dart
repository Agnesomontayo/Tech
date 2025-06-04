import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech/screens/clients/widgets/titleWidget.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../../clients/widgets/RoundedWorkCard.dart';
import '../../clients/widgets/Search_bar.dart';
import '../../clients/widgets/WorkerPresentationCard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 1.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
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
                ],
              ),
              SearchBarWidget(
                focusNode: focusNode,
                controller: searchController,
              ),
              Container(
                  height: 60,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.all(10),
                              scrollDirection: Axis.horizontal,
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                return RoundedWorkCard(
                                  work: 'Menuisier',
                                  workIcon: AssetsData.menuisierIcon,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: TitleWidget(
                            title: 'Résultats de la recherche',
                          ),
                        )
                      ],
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
                                  distance: '500',
                                  unit: 'm',
                                  reviews: '250',
                                  imagePath: AssetsData.best,
                                  biography:
                                      'lhfzmoaijgapzhgpoakezngioznggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg',
                                  profession: 'profesiion',
                                  clientId: 1,
                                  clientName: 'Abraham Monie',
                                  professionalId: 1,
                                );
                              },
                              childCount: 20,
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height *
                                    0.30), // Ajoute du padding en bas
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
