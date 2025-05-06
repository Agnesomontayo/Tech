import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech/core/const/assets.dart';
import 'package:tech/core/const/colors.dart';
import 'package:tech/screens/clients/client_home/search_page.dart';
import 'package:tech/screens/clients/widgets/PageHeaderWidget.dart';
import 'package:provider/provider.dart';
import '../../../core/helpers/apiHelpers.dart';
import '../../../core/providers/professionCategory_provider.dart';
import '../../../core/providers/professionnal_provider.dart';
import '../../clients/widgets/RoundedWorkCard.dart';
import '../../clients/widgets/WorkerPresentationCard.dart';
import '../../clients/widgets/menuCirculaireWidget.dart';
import '../../clients/widgets/titleWidget.dart';
import '../details/map_modal_draggable_bottom_sheet.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<dynamic> categories = [];
  List<dynamic> professionals = [];
  bool _isLoading = true;
  String baseImageUrl = '';

  Future<void> _loadInfos() async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      _fetchCategories();
    } catch (error) {
      print('Erreur de chargement des infos : $error');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _fetchCategories() async {
    try {
      final categoriesProvider = Provider.of<ProfessioncategoryProvider>(context, listen: false);
      final responseData = await categoriesProvider.getManyCategories();

      setState(() {
        categories = responseData;
        _isLoading = false;
      });
    } catch (error) {
      print('Erreur: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

 /* Future<void> _fetchProfessionals(categoryId) async {
    try {
      baseImageUrl = await ApiHelper.getApiUrl();
      final professionalsProvider = Provider.of<ProfessionalProvider>(context, listen: false);
      final responseData = await professionalsProvider.getProfessionalsByCategory(categoryId);
      //print('responseData ${responseData}');
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
*/


  @override
  void initState() {
    super.initState();
    _loadInfos();
  }

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
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
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
                            work: category['label'],
                            workIcon: ('${baseImageUrl}/${category['image']}'),
                          ),
                          onTap: () {
                            final categoryId = category['id'];
                            final categoryName = category['label'];
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context){
                                  return MapModalDraggableBottomSheet(
                                    categoryId: categoryId,
                                    categoryName: categoryName,
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
