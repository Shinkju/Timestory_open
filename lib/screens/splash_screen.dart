import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timestory/main.dart';
import 'package:timestory/styles/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1600), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Root()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/loadingLogo.png',
                width: MediaQuery.of(context).size.width * 0.616666,
                height: MediaQuery.of(context).size.height * 0.0959375,
              ),
              const SizedBox(height: 2.0,),
              const Text(
                'Timestory',
                style: TextStyle(
                  color: DEFAULT_COLOR,
                  fontFamily: "Lato",
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20.0,),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
