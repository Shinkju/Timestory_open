import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleCard extends StatefulWidget{
  final String year, month, day;

  const ScheduleCard({
    super.key,
    required this.year,
    required this.month,
    required this.day,
  });

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

  //초기화 및 일정 조회
  Future<List<String>> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('scheduleInfo');
    Map<String, dynamic>? scheduleData = jsonString != null ? jsonDecode(jsonString) : null;
    if(scheduleData != null){
      return getScheduleKeysForDate(widget.year, widget.month, widget.day, scheduleData);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: futureScheduleKeys,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final scheduleKeys = snapshot.data!;
          return Column(
            children: scheduleKeys.map((key) {
              final scheduleData = prefs.getStringList(key);
              if (scheduleData != null) {
                final Map<String, dynamic> data = jsonDecode(scheduleData[0]);
                final content = data['content'] as String;
                return ListTile(
                  title: Text(content),
                );
              } else {
                return const SizedBox(); //데이터가 올바르게 저장되지 않았을 경우 빈 위젯
              }
            }).toList(),
          );
        } else {
          return const SizedBox(); //데이터가 없을 경우 빈 위젯
        }
      },
    );
  }

  // 기준이 되는 year, month, day 값과 일치하는 일정 키 목록을 가져오는 함수
  List<String> getScheduleKeysForDate(String year, String month, String day, Map<String, dynamic> scheduleData){
    final List<String> matchedKeys = [];
    scheduleData.forEach((key, value) {
      if(key.startsWith('$year$month$day')){
        matchedKeys.add(key);
      }
    });
    return matchedKeys;
  }
}