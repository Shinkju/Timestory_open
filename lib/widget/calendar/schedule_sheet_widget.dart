import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/common.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/schedule_memo_model.dart';

class ScheduleBottomSheet extends StatefulWidget{
  final String year, month, day;
  final VoidCallback onClose;

  const ScheduleBottomSheet({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.onClose,    
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
  void onSaveProssed(BuildContext context) async {
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
      Fluttertoast.showToast(msg: "추가되었습니다.");

      widget.onClose();
      Navigator.pop(context);
    }else{
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('내용을 입력하세요.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height *(4/5),
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
                  onPressed: () => onSaveProssed(context),
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
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

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
            cursorColor: Colors.grey,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
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
}