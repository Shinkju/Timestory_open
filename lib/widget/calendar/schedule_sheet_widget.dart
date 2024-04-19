import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/common.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dpt;

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
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState(){
    super.initState();

    String formatDate = '${widget.year}-${widget.month.padLeft(2,'0')}-${widget.day.padLeft(2,'0')}';
    startDate = DateTime.parse(formatDate);
    endDate = DateTime.parse(formatDate);

    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _selectedStartDate(){
    dpt.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000,1,1),
      maxTime: DateTime(2100,12,31),
      currentTime: startDate,
      locale: dpt.LocaleType.ko,
      onConfirm: (date){
        setState(() {
          startDate = date;
        });
      },
      theme: const dpt.DatePickerTheme(backgroundColor: Colors.white),
    );
  }
  
  void _selectedEndDate(){
    dpt.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000,1,1),
      maxTime: DateTime(2100,12,31),
      currentTime: endDate,
      locale: dpt.LocaleType.ko,
      onConfirm: (date) {
        setState(() {
          endDate = date;
        });
      },
      theme: const dpt.DatePickerTheme(backgroundColor: Colors.white),
    );
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
        sYear: startDate.year.toString(),
        sMonth: startDate.month.toString(),
        sDay: startDate.day.toString(),
        eYear: endDate.year.toString(),
        eMonth: endDate.month.toString(),
        eDay: endDate.day.toString(),
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
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              color: DEFAULT_COLOR,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onSaveProssed(context), 
                        child: const Text(
                          "저장",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Lato",
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: DEFAULT_COLOR,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Calender",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 65,),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "시작일",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 60,),
                      TextButton(
                        onPressed: _selectedStartDate, 
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(startDate),
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: "Lato",
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 0,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "종료일",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 60,),
                      TextButton(
                        onPressed: _selectedEndDate, 
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(endDate),
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: "Lato",
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 0,
                bottom: bottomInsert,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _content = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: _content.isNotEmpty
                          ? ''
                          : '내용',
                      labelStyle: const TextStyle(
                        fontFamily: "Lato",
                        color: Colors.grey,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100,),
          ],
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