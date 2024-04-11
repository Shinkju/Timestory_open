import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:timestory/screens/calendar_screen.dart';
import 'package:timestory/screens/days_screen.dart';
import 'package:timestory/screens/splash_screen.dart';
void main() {
  runApp(const App());
}

class App extends StatelessWidget {
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
      home: const SplashScreen(),
    );
  }
}

class Root extends StatefulWidget{
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    CalendarScreen(),
    TheDayBeforeScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        enableFeedback: false,
        iconSize: 30.0,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.density_medium_sharp),
            label: 'D-day',
          ),
        ],
      ),
    );
  }
}



/*
  **자주 헷갈리는 부분
  StatefulWidget : 상태를 가지고, 그 상태가 변경될 때마다 화면이 다시 그려진다.
  - 사용자 상호작용 또는 외부 이벤트에 반응하여 동적으로 UI를 업데이트 할 때 사용한다.

  StatelessWidget : 상태를 가지지않고, 한번 그려진 후 변경되지 않는다.
  - 주로 정적인 부분이나, 상태가 변하지 않는 UI를 표현할 때 쓴다.
 */