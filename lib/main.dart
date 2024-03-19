import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timestory/firebase_options.dart';
import 'package:timestory/screens/calendar_screen.dart';
import 'package:timestory/screens/login_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget{
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      home: const Root(),
    );
  }
}

class Root extends StatelessWidget{
  const Root({super.key});
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }else if(snapshot.hasData){
          return const CalendarSreen();
        }else{
          return const LoginScreen();
        }
      })
    );
  }
}