import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/schedule_memo_model.dart';

class ScheduleModifySheet extends StatefulWidget{
  final ScheduleMemoModel memoInfo;

  const ScheduleModifySheet({
    super.key,
    required this.memoInfo,
  });

  @override
  State<ScheduleModifySheet> createState() => _ScheduleModifySheetState();
}

class _ScheduleModifySheetState extends State<ScheduleModifySheet>{
  late SharedPreferences prefs;
  String _content = '';

  @override
  void initState(){
    super.initState();
    initPrefs();
  }

  void initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  //update
  void onSaveProssed() async{
    if(_content.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonDataList = prefs.getStringList('scheduleInfo');

      if(jsonDataList != null){
        //기존 일정에서 수정할 일정 찾기
        List<ScheduleMemoModel> dataList = jsonDataList.map((jsonData) => ScheduleMemoModel.fromJson(json.decode(jsonData))).toList();
        for(int i=0; i<dataList.length; i++){
          if(dataList[i].uuid == widget.memoInfo.uuid){
            dataList[i] = ScheduleMemoModel(
              year: widget.memoInfo.year, 
              month: widget.memoInfo.month, 
              day: widget.memoInfo.day, 
              uuid: widget.memoInfo.uuid, 
              content: _content,
            );
            break;
          }
        }

        await prefs.setStringList("scheduleInfo", dataList.map((map) => jsonEncode(map.scheduleToJson())).toList());
        Fluttertoast.showToast(msg: "일정이 수정되었습니다.");
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: "내용을 입력하세요.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * (3/4),
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
                  "${widget.memoInfo.year}년 ${widget.memoInfo.month}월 ${widget.memoInfo.day}일",
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
                    onChanged: (value){
                      setState(() {
                        if(value.isEmpty){
                          _content = widget.memoInfo.content;
                        }else{
                          _content = value;
                        }
                      });
                    },
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
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
                  child: const Text("수정"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}