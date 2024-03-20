import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timestory/screens/login_screen.dart';
import 'package:timestory/widget/bottom_sheet_widget.dart';
import 'package:timestory/widget/schedule_widget.dart';
import 'package:timestory/styles/colors.dart';
import 'package:timestory/widget/today_widget.dart';

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
        backgroundColor: DEFAULT_COLOR,
        title: const Center(
          child: Text(
            "Timestory Diary",
            style: TextStyle(
              fontSize: 30,
              fontFamily: "Lato",
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
               //await GoogleSignIn().signOut();
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }, 
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            ),
            const SizedBox(height: 8,),
            //선택일정 + 개수 배너
            TodayBanner(
              selectedDate: selectedDate, 
              count: 0
            ),
            const SizedBox(height: 8,),
            //일정카드
            ScheduleCard(
              year: selectedDate.year.toString(), 
              month: selectedDate.month.toString(), 
              day: selectedDate.day.toString(), 
            ),
          ],
        ),
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