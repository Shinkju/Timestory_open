import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timestory/firebase_options.dart';
import 'package:timestory/screens/calendar_screen.dart';
import 'package:timestory/screens/login_screen.dart';
import 'package:timestory/screens/splash_screen.dart';
import 'package:timestory/screens/days_screen.dart';
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
      locale: const Locale('ko', 'KR'),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      initialRoute: '/splash', //첫화면
      routes: {
        '/splash' : (context) => const SplashScreen(),
        '/' : (context) => const CalendarScreen(),
        '/days' : (context) => const TheDayBeforeScreen(),
        'login' : (context) => const LoginScreen(),
      },
    );
  }
}



/*
  **헷갈리는 부분
  StatefulWidget : 상태를 가지고, 그 상태가 변경될 때마다 화면이 다시 그려진다.
  - 사용자 상호작용 또는 외부 이벤트에 반응하여 동적으로 UI를 업데이트 할 때 사용한다.

  StatelessWidget : 상태를 가지지않고, 한번 그려진 후 변경되지 않는다.
  - 주로 정적인 부분이나, 상태가 변하지 않는 UI를 표현할 때 쓴다.
 */