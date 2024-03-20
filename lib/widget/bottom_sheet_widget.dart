import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/screens/calendar_screen.dart';
import 'package:timestory/styles/colors.dart';

class ScheduleBottomSheet extends StatefulWidget{
  final String year, month, day;

  const ScheduleBottomSheet({
    required this.year,
    required this.month,
    required this.day,    
    Key? key,
  }):super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet>{
  late SharedPreferences prefs;
  String _content = '';

  //저장소 관리
  Future initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final scheduleInfo = prefs.getStringList('scheduleInfo');
    //사용자가 아직 등록한 일정이 1개도 없을 경우
    if(scheduleInfo == null){
      await prefs.setStringList('scheduleInfo', []);
    }
  }

  @override
  void initState(){
    super.initState();
    initPrefs();
  }

  //일정을 구분하기 위한 고유키
  String _formatDateTime(DateTime dateTime){
    return "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}";
  }

  //Safe
  void onSaveProssed() async {
    await initPrefs();

    print("SAVED!");

    if(_content.isNotEmpty){
      final key = _formatDateTime(DateTime.now()); //고유키 생성
      final schedule = {
        'year': widget.year,
        'month': widget.month,
        'day': widget.day,
        'content': _content,
      };
      final scheduleInfo = prefs.getStringList('scheduleInfo') ?? []; //없으면 빈배열 생성
      scheduleInfo.add(key);
      prefs.setStringList(key, scheduleInfo);

      //일정 저장
      await prefs.setStringList(key, [
        schedule['year'].toString(),
        schedule['month'].toString(),
        schedule['day'].toString(),
        schedule['content'].toString(),
      ]);

      Fluttertoast.showToast(msg: "일정이 추가되었습니다.");
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const CalendarSreen()),
      );
    }else{
      Fluttertoast.showToast(msg: "내용을 입력하세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2 + bottomInsert,  //화면 반 높이 키보드
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: bottomInsert,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: DEFAULT_COLOR),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${widget.year}년 ${widget.month}월 ${widget.day}일",
                  style: const TextStyle(
                    backgroundColor: Colors.white,
                    fontFamily: "Lato",
                    color: DEFAULT_COLOR,
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),
              Expanded(
                child: CustomTextField(
                  label: '내용',
                  onChanged: (value) {
                    setState(() {
                      _content = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSaveProssed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DEFAULT_COLOR,
                    foregroundColor: Colors.white,
                  ), 
                  child: const Text("저장"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//필드
class CustomTextField extends StatefulWidget{
  final String label;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.onChanged,
  }):super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: DEFAULT_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: 1,
          child: TextFormField(
            cursorColor: Colors.grey,   //커서색상
            maxLines: null,  //컨텐츠필드는 한줄 이상 작성 가능
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none, //기본 테두리
              focusedBorder: OutlineInputBorder( //포커스 스타일
                borderSide: const BorderSide(color: DEFAULT_COLOR, width: 1.3),
                borderRadius: BorderRadius.circular(1.0),
              ),
              filled: true,
              fillColor: Colors.white,  //배경
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
}