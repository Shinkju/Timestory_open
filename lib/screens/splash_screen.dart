import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timestory/main.dart';
import 'package:timestory/styles/colors.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState(){
    super.initState();
    Timer(
      const Duration(seconds: 2), 
        () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Root()),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: DEFAULT_COLOR,
      body: Center(
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/loadingLogo.png'),
              fit: BoxFit.contain, //디바이스에 맞게 조정
            )
          ),
        ),
      ),
    );
  }

}