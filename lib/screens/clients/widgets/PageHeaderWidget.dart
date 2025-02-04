import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../client_home/search_page.dart';
import 'menuCirculaireWidget.dart';

class PageHeaderWidget extends StatefulWidget {
  const PageHeaderWidget({super.key});

  @override
  State<PageHeaderWidget> createState() => _PageHeaderWidgetState();
}

class _PageHeaderWidgetState extends State<PageHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Card(
            color: ColorsData.purple267,
            surfaceTintColor: ColorsData.purple267,
            shadowColor: ColorsData.grey,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 10 ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SvgPicture.asset(
              AssetsData.menuIcon,
              fit: BoxFit.scaleDown,
              width: 38, // Largeur souhaitée
              height: 37,
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MenuCirculaireWidget();
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              child: Card(
                color: ColorsData.purple267,
                surfaceTintColor: ColorsData.purple267,
                shadowColor: ColorsData.grey,
                margin: EdgeInsetsDirectional.symmetric(
                    horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  AssetsData.searchIcon,
                  fit: BoxFit.scaleDown,
                  width: 38,
                  height: 37,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
