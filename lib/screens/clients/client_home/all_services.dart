import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/const/assets.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/services_provider.dart';
import '../../clients/widgets/CustumAppBar.dart';
import '../../clients/widgets/ServicePresentationListItem.dart';
import '../../clients/widgets/WorkCardWidget.dart';
import '../details/work_details.dart';
import 'package:provider/provider.dart';

class AllServicesPage extends StatefulWidget {
  const AllServicesPage({super.key});

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  List<dynamic> services = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  @override
  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchServices();
    } catch (error) {
      print('Erreur de chargement du profil : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchServices() async {
    try {
      final serviceProvider = Provider.of<ServicesProvider>(context, listen: false);
      final data = await serviceProvider.getManyServices();
      setState(() {
        services = data;
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
                                  final service = services[index];
                              return ServicePresentationListItem(
                                serviceName: service['label'],
                                rate: 4.5,
                                availability: 'Disponible',
                                availabilityColor: Colors.green,
                                distance: '500',
                                unit: 'm',
                                reviews: '250',
                                imagePath: ('${baseImageUrl}/${service['image']}'),
                                iconPath: AssetsData.menuisierIcon,
                                workIcon: AssetsData.menuisierIcon,
                                work: 'Menuiserie',
                                priceRange: '1000FCFA-3000FCFA',
                                description: service['description'],
                                serviceId: service['id'],
                              );
                            },
                            childCount: services.length,
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
