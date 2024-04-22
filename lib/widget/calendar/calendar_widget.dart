import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timestory/widget/calendar/schedule_card_widget.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_sheet_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  Map<DateTime, List<Event>> events = {};
  bool check = false;
  double _translateY = 0.0;
  bool hasEvents = false;

  final GlobalKey<ScheduleCardState> scheduleCardKey =
      GlobalKey<ScheduleCardState>();

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
    updateEventMarkers();
  }

  //데이터로드
  void refreshScheduleCard() async {
    check = true;
    if (check) {
      if (scheduleCardKey.currentState != null) {
        scheduleCardKey.currentState!.refreshData();
      }
    }
    updateEventMarkers();
  }

  //일 선택
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;

      bool hasEvents = events.containsKey(DateTime(selectedDate.year, selectedDate.month, selectedDate.day));
      _translateY = hasEvents ? -0.06 * MediaQuery.of(context).size.height : 0.0;
    });
  }

  //월 선택
  void onPageChanged(DateTime focusedDate) {
    DateTime today = DateTime.now();
    int day = 1;
    setState(() {
      if(focusedDate.year == today.year && focusedDate.month == today.month){
        day = today.day;
      }
      selectedDate = DateTime(focusedDate.year, focusedDate.month, day);
    });
    updateEventMarkers();
  }

  void updateEventMarkers() async {
    Map<DateTime, List<Event>> loadedEvents =
        await loadScheduleFromPreferences();
    setState(() {
      events = loadedEvents;
    });
    check = false;
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);
    return events[dayWithoutTime] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024, 1, 1), //시작날
            lastDay: DateTime(3000, 1, 1), //마지막날
            focusedDay: selectedDate, //포거스날짜
            locale: 'ko_KR',
            daysOfWeekHeight: 55,
            onDaySelected: onDaySelected,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            //상단 스타일
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, //크기 옵션
              titleCentered: true, //정렬
              leftChevronVisible: true,
              rightChevronVisible: true,
              titleTextStyle: TextStyle(
                fontFamily: "Lato",
                fontSize: 22,
                color: DEFAULT_COLOR,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultDecoration: BoxDecoration(
                //기본 날짜
                borderRadius: BorderRadius.circular(6.0),
                color: LIGHT_GREY_COLOR,
              ),
              weekendDecoration: BoxDecoration(
                //주말 날짜
                borderRadius: BorderRadius.circular(6.0),
                color: LIGHT_GREY_COLOR,
              ),
              selectedDecoration: BoxDecoration(
                //선택된 날짜
                borderRadius: null,
                border: Border.all(
                  color: DEFAULT_COLOR,
                  width: 1.0,
                ),
              ),
              todayDecoration: BoxDecoration(
                //오늘 날짜
                borderRadius: BorderRadius.circular(6.0),
                color: DARK_GREY_COLOR,
              ),
              defaultTextStyle: TextStyle(
                //기본 글꼴
                fontFamily: "Lato",
                color: DARK_GREY_COLOR,
              ),
              weekendTextStyle: TextStyle(
                //주말 글꼴
                fontFamily: "Lato",
                color: DARK_GREY_COLOR,
              ),
              selectedTextStyle: const TextStyle(
                //선택된 날짜 글꼴
                fontFamily: "Lato",
                color: DEFAULT_COLOR,
              ),
              todayTextStyle: TextStyle(
                //오늘 날짜 글꼴
                fontFamily: "Lato",
                color: LIGHT_GREY_COLOR,
              ),
              markerSize: 7,
              markersMaxCount: 5,
              markerDecoration: const BoxDecoration(
                color: DEFAULT_COLOR,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, date) {
                //요일칸 제어
                switch (date.weekday) {
                  case 1:
                    return const Center(
                      child: Text(
                        '월',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  case 2:
                    return const Center(
                      child: Text(
                        '화',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  case 3:
                    return const Center(
                      child: Text(
                        '수',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  case 4:
                    return const Center(
                      child: Text(
                        '목',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  case 5:
                    return const Center(
                      child: Text(
                        '금',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  case 6:
                    return const Center(
                      child: Text(
                        '토',
                        style: TextStyle(
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  case 7:
                    return const Center(
                      child: Text(
                        '일',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Lato",
                        ),
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
            onPageChanged: onPageChanged, //월 변경
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, _translateY),
              child: SingleChildScrollView(
                clipBehavior: Clip.antiAlias,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DEFAULT_COLOR,
        onPressed: () {
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
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class Event {
  String title;
  Event(this.title);
}

Future<Map<DateTime, List<Event>>> loadScheduleFromPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? jsonDataList = prefs.getStringList('scheduleInfo');
  Map<DateTime, List<Event>> monthlyEvents = {};

  if (jsonDataList != null) {
    for (String jsonData in jsonDataList) {
      try {
        Map<String, dynamic> scheduleMap = json.decode(jsonData);
        final sYear = scheduleMap['sYear'];
        final sMonth = scheduleMap['sMonth'];
        final sDay = scheduleMap['sDay'];
        final eYear = scheduleMap['eYear'];
        final eMonth = scheduleMap['eMonth'];
        final eDay = scheduleMap['eDay'];
        DateTime startDate = DateTime.parse('$sYear-$sMonth-$sDay');
        DateTime endDate = DateTime.parse('$eYear-$eMonth-$eDay');
        String title = scheduleMap['title'].toString();

        for(DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))){
          DateTime dateOnly = DateTime(date.year, date.month, date.day);
          if (!monthlyEvents.containsKey(dateOnly)) {
            monthlyEvents[dateOnly] = [];
          }
          monthlyEvents[dateOnly]!.add(Event(title));
        }
      } catch (e) {
        print('ERROR!! : $e');
      }
    }
  }
  return monthlyEvents;
}
