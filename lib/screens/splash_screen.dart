import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timestory/styles/colors.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initApp(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){  //loading
          //초기화중일때 로딩
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/loadingLogo.png',
                    width: MediaQuery.of(context).size.width * 0.616666,
                    height: MediaQuery.of(context).size.height * 0.0959375,
                  ),
                  const SizedBox(height: 2.0,),
                  const Text(
                    "Timestory",
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
          );
        } else if(snapshot.hasError){  //error
          return Scaffold(
            body: Center(
              child: Text('Error : ${snapshot.error}'),
            ),
          );
        }else{  //success init
          final bool isLoggedIn = snapshot.data as bool;
          final nextRoute = isLoggedIn ? '/' : '/login';

          WidgetsBinding.instance?.addPostFrameCallback((_) { 
            Navigator.pushReplacementNamed(context, nextRoute);
          });

          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/loadingLogo.png',
                    width: MediaQuery.of(context).size.width * 0.616666,
                    height: MediaQuery.of(context).size.height * 0.0959375,
                  ),
                  const SizedBox(height: 2.0,),
                  const Text(
                    "Timestory",
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
          );
        }
      }
    );
  }

  Future<bool> _initApp() async{
    const storage = FlutterSecureStorage();
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');

    if(email != null && password != null){
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      }on FirebaseAuthException catch(e){
        print('Auto login failed: ${e.message}');
      }
    }
    return false;
  }
}