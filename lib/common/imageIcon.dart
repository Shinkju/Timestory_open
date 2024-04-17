import 'package:flutter/material.dart';

List<PopupMenuItem<String>> buildPopupMenuItems(BuildContext context) {
  return [
    PopupMenuItem<String>(
      value: 'assets/images/icon/calendarIcon.png',
      child: Container(
        width: 40,
        alignment: Alignment.center,
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon/calendarIcon.png',
              width: 30,
              height: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ),
    PopupMenuItem<String>(
      value: 'assets/images/icon/heartIcon.png',
      child: Container(
        width: 40,
        alignment: Alignment.center,
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon/heartIcon.png',
              width: 30,
              height: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ),
    PopupMenuItem<String>(
      value: 'assets/images/icon/flowerIcon.png',
      child: Container(
        width: 40,
        alignment: Alignment.center,
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon/flowerIcon.png',
              width: 30,
              height: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ),
    PopupMenuItem<String>(
      value: 'assets/images/icon/starsIcon.png',
      child: Container(
        width: 40,
        alignment: Alignment.center,
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon/starsIcon.png',
              width: 30,
              height: 40,
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ),
  ];
}
