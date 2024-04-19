import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dpt;

class ScheduleModifySheet extends StatefulWidget{
  final ScheduleMemoModel memoInfo;
  final VoidCallback onClose;

  const ScheduleModifySheet({
    super.key,
    required this.memoInfo,
    required this.onClose,
  });

  @override
  State<ScheduleModifySheet> createState() => _ScheduleModifySheetState();
}

class _ScheduleModifySheetState extends State<ScheduleModifySheet>{
  late SharedPreferences prefs;
  late TextEditingController _contentController;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState(){
    super.initState();
    _contentController = TextEditingController(text: widget.memoInfo.content);
    startDate = DateTime.parse('${widget.memoInfo.sYear}-${widget.memoInfo.sMonth}-${widget.memoInfo.sDay}');
    endDate = DateTime.parse('${widget.memoInfo.eYear}-${widget.memoInfo.eMonth}-${widget.memoInfo.eDay}');
    initPrefs();
  }

  @override
  void dispose(){
    _contentController.dispose();
    super.dispose();
  }

  void initPrefs() async{
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

  //update
  void onSaveProssed(BuildContext context) async{
    String? _content = _contentController.text;
    if(_content.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonDataList = prefs.getStringList('scheduleInfo');

      if(jsonDataList != null){
        List<ScheduleMemoModel> dataList = jsonDataList.map((jsonData) => ScheduleMemoModel.fromJson(json.decode(jsonData))).toList();
        for(int i=0; i<dataList.length; i++){
          if(dataList[i].uuid == widget.memoInfo.uuid){
            dataList[i] = ScheduleMemoModel(
              sYear: startDate.year.toString(),
              sMonth: startDate.month.toString(),
              sDay: startDate.day.toString(),
              eYear: endDate.year.toString(),
              eMonth: endDate.month.toString(), 
              eDay: endDate.day.toString(),
              uuid: widget.memoInfo.uuid, 
              content: _content,
            );
            break;
          }
        }

        await prefs.setStringList("scheduleInfo", dataList.map((map) => jsonEncode(map.scheduleToJson())).toList());
        Fluttertoast.showToast(msg: "일정이 수정되었습니다.");

        widget.onClose();
        Navigator.pop(context);
      }
    }else{
      Fluttertoast.showToast(msg: "내용을 입력하세요.");
    }
  }

  //delete
  void onDeletePressed(BuildContext context) async{
    List<String>? jsonDataList = prefs.getStringList('scheduleInfo');

    if(jsonDataList != null){
      List<ScheduleMemoModel> dataList = jsonDataList.map((jsonData) => ScheduleMemoModel.fromJson(json.decode(jsonData))).toList();
      int indexRemove = dataList.indexWhere((memo) => memo.uuid == widget.memoInfo.uuid);

      if(indexRemove != -1){
        dataList.removeAt(indexRemove);

        await prefs.setStringList("scheduleInfo", dataList.map((map) => jsonEncode(map.scheduleToJson())).toList());
        Fluttertoast.showToast(msg: "일정이 삭제되었습니다.");

        widget.onClose();
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: "일정이 없습니다.");
      }
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
                          "수정",
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
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: _contentController.text.isNotEmpty
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
            TextButton(
              onPressed: () => onDeletePressed(context), 
              child: const Text(
                "삭제",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Lato",
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}