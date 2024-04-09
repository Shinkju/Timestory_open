import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/common.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/schedule_memo_model.dart';

class ScheduleBottomSheet extends StatefulWidget{
  final String year, month, day;

  const ScheduleBottomSheet({
    super.key,
    required this.year,
    required this.month,
    required this.day,    
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet>{
  late SharedPreferences prefs;
  String _content = '';

  @override
  void initState(){
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  //Save
  void onSaveProssed() async {
    if(_content.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? existingData = prefs.getStringList('scheduleInfo');
      List<ScheduleMemoModel> dataList = [];

      //이미데이터가 있다면 불러옴
      if(existingData != null){
        dataList = existingData.map((jsonString) => ScheduleMemoModel.fromJson(json.decode(jsonString))).toList();
      }

      //새로운 데이터 저장
      dataList.add(ScheduleMemoModel(
        year: widget.year,
        month: widget.month,
        day: widget.day,
        uuid: Common.getUuid(),
        content: _content,
      ));
      
      //저장
      await prefs.setStringList('scheduleInfo', dataList.map((map) => jsonEncode(map.scheduleToJson())).toList());

      final List<String>? test = prefs.getStringList('scheduleInfo');
      print('올바르게 저장됐는지 : $test');

      Fluttertoast.showToast(msg: "일정이 추가되었습니다.");

      setState(() {}); //화면갱신
      Navigator.pop(context); // 바텀시트 닫기
    }else{
      Fluttertoast.showToast(msg: "내용을 입력하세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height *(3/4),
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
                child: Text(
                  "${widget.year}년 ${widget.month}월 ${widget.day}일",
                  style: const TextStyle(
                    backgroundColor: Colors.white,
                    fontFamily: "Lato",
                    color: DEFAULT_COLOR,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: DEFAULT_COLOR, width: 2.0,),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _content = value;
                      });
                    },
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '내용',
                    ),
                  ),
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

//실제 입력 필드
class CustomTextField extends StatefulWidget{
  final String label;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.onChanged,
  });

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