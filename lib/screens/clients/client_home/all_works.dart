import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech/screens/clients/details/work_details.dart';
import '../../../../core/const/assets.dart';
import 'package:tech/screens/clients/widgets/CustumAppBar.dart';
import 'package:tech/screens/clients/widgets/WorkCardWidget.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/professionCategory_provider.dart';

class AllWorksPage extends StatefulWidget {
  final int clientId;
  final String clientName;
  const AllWorksPage({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  State<AllWorksPage> createState() => _AllWorksPageState();
}

class _AllWorksPageState extends State<AllWorksPage> {
  List<dynamic> categories = [];
  bool _isLoading = true;
  String baseImageUrl = '';
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
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 2.0,
        ),
        body: Stack(
          children: [
            Image.asset(
              AssetsData.workers,
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Positioned(
              child: CustumAppBar(title: 'Tous les métiers'),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            width: 150,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          SizedBox(height: 40),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            crossAxisCount: 4,
                            children: List.generate(
                                categories.length,
                                (index) {
                                  final category = categories[index];
                                  return WorkCard(
                                      iconPath: ('${baseImageUrl}/${category['image']}'),
                                      title: category['label'],
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                          builder: (context) =>
                                              WorkDetailPage(
                                                categoryId: category['id'],
                                                name: category['label'],
                                                clientId: widget.clientId,
                                                clientName: widget.clientName,
                                                imageUrl: ('${baseImageUrl}/${category['image']}'),
                                              ),
                                        ));
                                      }
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        )
    );
  }
}
