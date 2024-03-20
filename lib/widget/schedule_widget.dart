import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleCard extends StatefulWidget{
  final String year, month, day;

  const ScheduleCard({
    Key? key,
    required this.year,
    required this.month,
    required this.day,
  }):super(key: key);

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late SharedPreferences prefs;
  late Future<List<String>> futureScheduleKeys;

  @override
  void initState() {
    super.initState();
    futureScheduleKeys = loadSharedPreferences();
  }

  // SharedPreferences 초기화 및 일정 키 목록 가져오기
  Future<List<String>> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // 기준이 되는 year, month, day 값으로 일치하는 일정 키 목록을 가져옴
    return getScheduleKeysForDate(widget.year, widget.month, widget.day);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: futureScheduleKeys,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final scheduleKeys = snapshot.data!;
          return ListView.builder(
            itemCount: scheduleKeys.length,
            itemBuilder: (context, index) {
              final key = scheduleKeys[index];
              final scheduleData = prefs.getStringList(key) ?? [];
              if (scheduleData.length >= 4) {
                final content = scheduleData[3];
                return ListTile(
                  title: Text(content), // content만을 표시
                );
              } else {
                return const SizedBox(); // 데이터가 올바르게 저장되지 않았을 경우 빈 위젯 반환
              }
            },
          );
        } else {
          return const SizedBox(); // 데이터가 없을 경우 빈 위젯 반환
        }
      },
    );
  }

  // 기준이 되는 year, month, day 값과 일치하는 일정 키 목록을 가져오는 함수
  List<String> getScheduleKeysForDate(String year, String month, String day) {
    final scheduleKeys = prefs.getKeys();
    final List<String> matchedKeys = [];
    for (final key in scheduleKeys) {
      final scheduleData = prefs.getStringList(key) ?? [];
      if (scheduleData.length >= 3 &&
          scheduleData[0] == year &&
          scheduleData[1] == month &&
          scheduleData[2] == day) {
        matchedKeys.add(key);
      }
    }
    return matchedKeys;
  }
}