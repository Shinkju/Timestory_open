import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSreen extends StatefulWidget{
  const CalendarSreen({super.key});

  @override
  State<CalendarSreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarSreen> {
  //초기 선택날짜 - 금일
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: TableCalendar(
        //날짜가 선택됐을 때
        onDaySelected: onDaySelected,
        //특정날짜가 선택된 날짜와 동일한지 duple
        selectedDayPredicate: (day) {
          return isSameDay(selectedDate, day);
        },
        firstDay: DateTime.utc(2024), //달력의 시작 날짜
        lastDay: DateTime.utc(2030),  //달력의 마지막 날짜
        focusedDay: DateTime.now(),   //현재달력 포거스날짜
      ),
    );
  }
}