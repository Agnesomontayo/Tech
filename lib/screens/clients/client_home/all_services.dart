import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/const/assets.dart';
import '../../clients/widgets/CustumAppBar.dart';
import '../../clients/widgets/ServicePresentationListItem.dart';
import '../../clients/widgets/WorkCardWidget.dart';
import '../details/work_details.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({super.key});

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 2.0,
      ),
      body: Column(
        children: [
           CustumAppBar(title: 'Services'),
                  Expanded(
                    child:  CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return ServicePresentationListItem(
                                serviceName: 'Nettoyage complet $index',
                                rate: 4.5,
                                availability: 'Disponible',
                                availabilityColor: Colors.green,
                                distance: '500',
                                unit: 'm',
                                reviews: '250',
                                imagePath: AssetsData.menage,
                                iconPath: AssetsData.menuisierIcon,
                                workIcon: AssetsData.menuisierIcon,
                                work: 'Menuiserie',
                                priceRange: '1000FCFA-3000FCFA',
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
      ),
    );
  }
}
