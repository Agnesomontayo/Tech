import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/const/assets.dart';
import '../../../core/const/colors.dart';
import '../client_home/search_page.dart';
import 'menuCirculaireWidget.dart';

class PageHeaderWidget extends StatefulWidget {
  final int userId;
  final String imageUrl;
  const PageHeaderWidget({
    super.key,
    required this.userId,
    required this.imageUrl,
  });

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
              color: ColorsData.purple00A,
              width: 38, // Largeur souhaitée
              height: 37,
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MenuCirculaireWidget(
                  userId: widget.userId,
                  imageUrl: widget.imageUrl,
                );
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
                color: ColorsData.purple260,
                surfaceTintColor: ColorsData.purple260,
                shadowColor: ColorsData.grey,
                margin: EdgeInsetsDirectional.symmetric(
                    horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  AssetsData.searchIcon,
                  fit: BoxFit.scaleDown,
                  color: ColorsData.purple00A,
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
