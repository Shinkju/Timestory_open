import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timestory/screens/login_screen.dart';
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
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ],
    );
  }
}
