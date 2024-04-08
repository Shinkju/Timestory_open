import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final storage = const FlutterSecureStorage();
  int scheduleCardMemoCount = 0; //스케줄 메모수

  //초기 선택날짜 - 금일
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) async{ //선택날짜 변경적용
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  void onPageChanged(DateTime focusedDate){ //월(페이지) 변경 적용
    setState(() {
      selectedDate = DateTime(focusedDate.year, focusedDate.month, 1);
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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024,1,1), //달력의 시작 날짜
            lastDay: DateTime(3000,1,1),  //달력의 마지막 날짜
            focusedDay: selectedDate,   //현재달력 포거스날짜
            locale: 'ko_KR',
            daysOfWeekHeight: 30,
            //날짜가 선택됐을 때
            onDaySelected: onDaySelected,
            //선택날짜 분기로직
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            //최상단 스타일
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, //달력 크기선택 옵션
              titleCentered: true,  //제목 중앙정렬
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
            ),
            onPageChanged: onPageChanged, //월 변경 콜백
          ),
          const SizedBox(height: 8,),
          ScheduleCard(
            key: UniqueKey(), //계속 바뀐값을 전달하기 위해 사용
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
              builder: (_) => ScheduleBottomSheet(year: selectedDate.year.toString(), month: selectedDate.month.toString(), day: selectedDate.day.toString()),
              isScrollControlled: true, //키보드가림 해결
            );
          },
          child: const Icon(Icons.add,),
        ),
    );
  }
}