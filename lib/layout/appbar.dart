import 'package:flutter/material.dart';
import 'package:timestory/styles/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DEFAULT_COLOR,
      title: const Center(
        child: Text(
          "Timestory Diary",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Lato",
          ),
        ),
      ),
    );
  }
}
