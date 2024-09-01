import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech/screens/clients/details/work_details.dart';
import '../../../../core/const/assets.dart';
import 'package:tech/screens/widgets/CustumAppBar.dart';

import 'package:tech/screens/widgets/WorkCardWidget.dart';

class AllWorksPage extends StatefulWidget {
  const AllWorksPage({super.key});

  @override
  State<AllWorksPage> createState() => _AllWorksPageState();
}

class _AllWorksPageState extends State<AllWorksPage> {
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
                            children: <Widget>[
                              WorkCard(
                                iconPath: AssetsData.mecanicienIcon,
                                title: 'Mécanique',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.menuisierIcon,
                                title: 'Menuiserie',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.entretienIcon,
                                title: 'Entretien',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.coutureIcon,
                                title: 'Couture',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.electricienIcon,
                                title: 'Electricité',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.coiffeurIcon,
                                title: 'Coiffure',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.maconIcon,
                                title: 'Maçonnerie',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.coiffeurIcon,
                                title: 'Coiffure',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.maconIcon,
                                title: 'Maçonnerie',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.coiffeurIcon,
                                title: 'Coiffure',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.maconIcon,
                                title: 'Maçonnerie',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.coiffeurIcon,
                                title: 'Coiffure',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.maconIcon,
                                title: 'Maçonnerie',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.coiffeurIcon,
                                title: 'Coiffure',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                              WorkCard(
                                iconPath: AssetsData.maconIcon,
                                title: 'Maçonnerie',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkDetailPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
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
