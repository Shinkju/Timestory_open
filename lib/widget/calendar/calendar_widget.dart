import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:timestory/service/schedule_service.dart';
import 'package:timestory/widget/calendar/schedule_card_widget.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_sheet_widget.dart';

class CalendarWidget extends StatefulWidget{
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final GlobalKey<ScheduleCardState> scheduleCardKey = GlobalKey<ScheduleCardState>();
  bool check = false;

  @override
  void initState(){
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  void refreshScheduleCard(){
    if(scheduleCardKey.currentState != null){
      scheduleCardKey.currentState!.refreshData();
      check = true;
    }
  }

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  //선택일 변경
  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  //월 변경
  void onPageChanged(DateTime focusedDate){
    setState(() {
      selectedDate = DateTime(focusedDate.year, focusedDate.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024,1,1), //시작날짜
            lastDay: DateTime(3000,1,1),  //마지막날짜
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
            ),
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
          ScheduleCard(
            key: !check ? UniqueKey() : scheduleCardKey,
            year: selectedDate.year.toString(), 
            month: selectedDate.month.toString(), 
            day: selectedDate.day.toString(),
            selectedDate: selectedDate,
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