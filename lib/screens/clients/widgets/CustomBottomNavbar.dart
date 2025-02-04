import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech/core/const/assets.dart';
import 'dart:ui';

import 'package:tech/core/const/colors.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(AssetsData.homeIcon, 0),
                  _buildNavItem(AssetsData.mapIcon, 1),
                  _buildNavItem(AssetsData.favIcon, 2),
                  _buildNavItem(AssetsData.userIcon, 3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(String iconData, int index) {
    bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        alignment: Alignment.center,
        width: 35,
        height: 35,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Permet le dépassement du cercle
          children: [
            if (isSelected)
              Positioned(
                left: 2,
                bottom: -5, // Déplacez le cercle un peu plus bas
                child: Container(
                  width: 22,
                  height: 19,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFAEAE).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            SvgPicture.asset(
              iconData,
              color: isSelected ? ColorsData.purple00A : ColorsData.grey,
              width: 25,
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
