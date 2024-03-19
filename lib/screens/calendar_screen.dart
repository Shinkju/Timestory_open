import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  void initState(){
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4081),
        title: const Center(
          child: Text(
            "Timestory Diary",
            style: TextStyle(
              fontSize: 30,
              fontFamily: "Lato",
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: TableCalendar(
          //날짜가 선택됐을 때
          onDaySelected: onDaySelected,
          //특정날짜가 선택된 날짜와 동일한지 duple
          selectedDayPredicate: (day) {
            return isSameDay(selectedDate, day);
          },
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) { //dowBuilder: 요일칸 제어
              switch(day.weekday){
                case 1:
                  return const Center(child: Text('월'),);
                case 2:
                  return const Center(child: Text('화'),);
                case 3:
                  return const Center(child: Text('수'),);
                case 4:
                  return const Center(child: Text('목'),);
                case 5:
                  return const Center(child: Text('금'),);
                case 6:
                  return const Center(child: Text('토'),);
                case 7:
                  return const Center(child: Text('일', style: TextStyle(color: Colors.red),),);
                default:
                  return const SizedBox();
              }
            },
            //선택한 날짜 스타일 변경
            selectedBuilder: (context, day, events){
              return Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF4081),
                  border: Border.fromBorderSide(BorderSide(color: Color(0xFFFF4081), width: 1.3)),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: true,
            rightChevronVisible: true
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: TextStyle(color: Colors.grey,),
            weekendTextStyle: TextStyle(color: Colors.grey,),
            todayDecoration: BoxDecoration(
              color: Color.fromARGB(255, 204, 196, 199),
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: Color.fromARGB(255, 204, 196, 199), width: 1.3)),
            ),
            todayTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black38,
            ),
          ),
          firstDay: DateTime(2024), //달력의 시작 날짜
          lastDay: DateTime(2030),  //달력의 마지막 날짜
          focusedDay: DateTime.now(),   //현재달력 포거스날짜
          locale: 'ko_KR',
          daysOfWeekHeight: 30,
        ),
      ),
    );
  }
}