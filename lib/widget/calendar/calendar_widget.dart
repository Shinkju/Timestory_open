import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timestory/widget/calendar/schedule_card_widget.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_sheet_widget.dart';

class CalendarWidget extends StatefulWidget{
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  Map<DateTime, List<Event>> events = {};
  bool check = false;

  final GlobalKey<ScheduleCardState> scheduleCardKey = GlobalKey<ScheduleCardState>();
  
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState(){
    super.initState();
    initializeDateFormatting('ko_KR', null);
    updateEventMarkers();
  }

  //데이터로드
  void refreshScheduleCard() async{
    check = true;
    if(check){
      if(scheduleCardKey.currentState != null){
        scheduleCardKey.currentState!.refreshData();
      }
    }
    updateEventMarkers();
  }

  //일 선택
  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  //월 선택
  void onPageChanged(DateTime focusedDate){
    setState(() {
      selectedDate = DateTime(focusedDate.year, focusedDate.month, 1);
    });
    updateEventMarkers();
  }

  void updateEventMarkers() async{
    Map<DateTime, List<Event>> loadedEvents = await loadScheduleFromPreferences();
    setState(() {
        events = loadedEvents;
    });
    check = false;
  }

  List<Event> _getEventsForDay(DateTime day){
    DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);
    return events[dayWithoutTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024,1,1), //시작날
            lastDay: DateTime(3000,1,1),  //마지막날
            focusedDay: selectedDate,   //포거스날짜
            locale: 'ko_KR',
            daysOfWeekHeight: 30,
            onDaySelected: onDaySelected,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            //상단 스타일
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, //크기 옵션
              titleCentered: true,  //정렬
              leftChevronVisible: true,
              rightChevronVisible: true
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultDecoration: BoxDecoration(  //기본 날짜
                borderRadius: BorderRadius.circular(6.0),
                color: LIGHT_GREY_COLOR,
              ),
              weekendDecoration: BoxDecoration(  //주말 날짜
                borderRadius: BorderRadius.circular(6.0),
                color: LIGHT_GREY_COLOR,
              ),
              selectedDecoration: BoxDecoration(  //선택된 날짜
                borderRadius: null,
                border: Border.all(
                  color: DEFAULT_COLOR,
                  width: 1.0,
                ),
              ),
              todayDecoration: BoxDecoration( //오늘 날짜
                borderRadius: BorderRadius.circular(6.0),
                color: DARK_GREY_COLOR,
              ),
              defaultTextStyle: TextStyle(  //기본 글꼴
                fontFamily: "Lato",
                color: DARK_GREY_COLOR,
              ),
              weekendTextStyle: TextStyle(  //주말 글꼴
                fontFamily: "Lato",
                color: DARK_GREY_COLOR,
              ),
              selectedTextStyle: const TextStyle(  //선택된 날짜 글꼴
                fontFamily: "Lato",
                color: DEFAULT_COLOR,
              ),
              todayTextStyle: TextStyle(  //오늘 날짜 글꼴
                fontFamily: "Lato",
                color: LIGHT_GREY_COLOR,
              ),
              markerSize: 10.0,
              markerDecoration: const BoxDecoration(
                color: DEFAULT_COLOR,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, date) { //요일칸 제어
                switch(date.weekday){
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
            ),
            onPageChanged: onPageChanged, //월 변경
          ),
          const SizedBox(height: 8,),
          Expanded(
            child: SingleChildScrollView(
              child: ScheduleCard(
                key: check ? scheduleCardKey : UniqueKey(),
                year: selectedDate.year.toString(), 
                month: selectedDate.month.toString(), 
                day: selectedDate.day.toString(),
                selectedDate: selectedDate,
                onUpdateMarker: updateEventMarkers,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DEFAULT_COLOR,
        onPressed: (){
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              year: selectedDate.year.toString(), 
              month: selectedDate.month.toString(), 
              day: selectedDate.day.toString(),
              onClose: refreshScheduleCard,
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add,),
      ),
    );
  }
}

class Event {
  String title;

  Event(this.title);
}

Future<Map<DateTime, List<Event>>> loadScheduleFromPreferences() async{
  final prefs = await SharedPreferences.getInstance();
  List<String>? jsonDataList = prefs.getStringList('scheduleInfo');
  Map<DateTime, List<Event>> monthlyEvents = {};

  if(jsonDataList != null){
    for(String jsonData in jsonDataList){
      try{
        Map<String, dynamic> data = json.decode(jsonData);
        int year = int.parse(data['year'].toString());
        int month = int.parse(data['month'].toString());
        int day = int.parse(data['day'].toString());

        DateTime dateKey = DateTime(year, month, day);
        String title = data['title'].toString();

        if(!monthlyEvents.containsKey(dateKey)){
          monthlyEvents[dateKey] = [];
        }
        monthlyEvents[dateKey]!.add(Event(title));
      }catch(e){
        print('ERROR!! : $e');
      }
    }
  }
  return monthlyEvents;
}