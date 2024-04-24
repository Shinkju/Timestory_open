import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:timestory/service/schedule_service.dart';
import 'package:timestory/widget/calendar/schedule_card_widget.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_sheet_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late List<Holiday> holidays;
  late Map<DateTime, List<Event>>  holidayDateStyleMap;
  Map<DateTime, List<Event>> userEvents = {};
  bool check = false;

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
    holidayDateStyleMap = {};
    _getHolidays().then((value){
      holidays = value;
      setHolidayStyles();
    });
  }

  //marker 업데이트
  void updateEventMarkers() async {
    Map<DateTime, List<Event>> loadedEvents =
        await ScheduleService.loadScheduleFromPreferences();
    setState(() {
      userEvents = loadedEvents;
    });
    check = false;

    List<Holiday> newHolidays = await _getHolidays();
    setState(() {
      holidays = newHolidays;
      setHolidayStyles();
    });
  }

  //마커 로드데이터
  List<Event> _getEventsForDay(DateTime day) {
    DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);
    List<Event> holidayEvents = [];

    if (holidayDateStyleMap != null && holidayDateStyleMap.containsKey(dayWithoutTime)) {
      final holidayName = holidayDateStyleMap[dayWithoutTime];
      holidayEvents.add(Event(holidayName.toString()));
    }
    return [...holidayEvents];
  }

  //휴일 목록
  Future<List<Holiday>> _getHolidays() async{
    return await ScheduleService.fetchHolidays(selectedDate.year.toString(), selectedDate.month.toString().padLeft(2, '0'),);
  }

  //휴일 스타일 매핑
  void setHolidayStyles(){
    holidayDateStyleMap = {};
    for(var holiday in holidays){
      String holidayLocdate = holiday.locdate;

      DateTime holidayDate = DateTime(
        int.parse(holidayLocdate.substring(0, 4)),
        int.parse(holidayLocdate.substring(4, 6)),
        int.parse(holidayLocdate.substring(6, 8)),
      );

      holidayDateStyleMap[holidayDate] = [Event(holiday.dateName)];
    }
  }

  //일정 로드
  void refreshScheduleCard() async {
    check = true;
    if (check) {
      if (scheduleCardKey.currentState != null) {
        scheduleCardKey.currentState!.refreshData();
      }
    }
    updateEventMarkers();
  }

  //모달에 전달할 공휴일
  Future<Map<DateTime, List<Event>>> _getModalHolidayEvents(DateTime selectedDate) async{
    List<Holiday> holidayEvents = await _getHolidays();
    Map<DateTime, List<Event>> combinedEvents = {};

    for(var holiday in holidayEvents){
      String holidayLocdate = holiday.locdate;

      DateTime holidayDate = DateTime(
        int.parse(holidayLocdate.substring(0, 4)),
        int.parse(holidayLocdate.substring(4, 6)),
        int.parse(holidayLocdate.substring(6, 8)),
      );

      if(!combinedEvents.containsKey(holidayDate)){
        combinedEvents[holidayDate] = [Event(holiday.dateName)];
      } else {
        combinedEvents[holidayDate]!.add(Event(holiday.dateName));
      }
    }
    return combinedEvents;
  }

  //일정 모달창
  void _showEventPopup(BuildContext context, DateTime selectedDate) async{
    Map<DateTime, List<Event>> combinedEvents = await _getModalHolidayEvents(selectedDate);
    final List<Event>? selectedEvents = combinedEvents[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)];
    final List<Event>? eventsForDate = userEvents[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)];

    if(selectedEvents != null || eventsForDate != null){
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        builder: (_) => SingleChildScrollView(
          child: Container(
            height: 250,
            color: Colors.white,
            child: ScheduleCard(
              key: GlobalKey<ScheduleCardState>(),
              year: selectedDate.year.toString(),
              month: selectedDate.month.toString(),
              day: selectedDate.day.toString(),
              selectedDate: selectedDate,
              onUpdateMarker: updateEventMarkers,
              selectedEvents: selectedEvents,
            ),
          ),
        ),
      );
    }
  }

  //일 선택
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
    _showEventPopup(context, selectedDate);
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
            rowHeight: 60,
            onDaySelected: onDaySelected,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            //상단 스타일
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true, //정렬
              leftChevronVisible: true,
              rightChevronVisible: true,
              titleTextStyle: TextStyle(
                fontFamily: "Lato",
                fontSize: 23,
                color: DEFAULT_COLOR,
              ),
            ),
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0,),
              cellAlignment : Alignment.center,
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
              markersAutoAligned: true,
              canMarkersOverflow: false,
              markersAlignment: Alignment.bottomCenter,
              markerMargin : const EdgeInsets.symmetric(horizontal: 0.4),
              markerDecoration: const BoxDecoration( //마커
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
                          fontSize: 18,
                        ),
                      ),
                    );
                  case 2:
                    return const Center(
                      child: Text(
                        '화',
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 18,
                        ),
                      ),
                    );
                  case 3:
                    return const Center(
                      child: Text(
                        '수',
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 18,
                        ),
                      ),
                    );
                  case 4:
                    return const Center(
                      child: Text(
                        '목',
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 18,
                        ),
                      ),
                    );
                  case 5:
                    return const Center(
                      child: Text(
                        '금',
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 18,
                        ),
                      ),
                    );
                  case 6:
                    return const Center(
                      child: Text(
                        '토',
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 18,
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
                          fontSize: 18,
                        ),
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              },
              markerBuilder: (BuildContext context, DateTime date, List<dynamic> holidays){
                final children = <Widget>[];
                final List<Event> eventsForDate = userEvents[DateTime(date.year, date.month, date.day)] ?? [];

                if(holidays.isNotEmpty){ //공휴일
                    children.add(
                    Positioned(
                      top: 5,
                      child: Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width / 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0,),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }
                
                if(eventsForDate.isNotEmpty){ //이벤트
                  for (var i = 0; i < eventsForDate.length; i++) {
                    children.add(
                      Positioned(
                        top: 43,
                        left: (i+1) * 8.0,
                        child: Container(
                          height: 7,
                          width: 7,
                          margin: const EdgeInsets.symmetric(vertical: 4.0,),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: DEFAULT_COLOR,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return children.isEmpty ? null : Stack(children:children);
              },
            ),
            onPageChanged: onPageChanged, //월 변경
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