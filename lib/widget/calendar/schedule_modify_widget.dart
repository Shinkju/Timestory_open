import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/schedule_memo_model.dart';

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

  @override
  void initState(){
    super.initState();
    _contentController = TextEditingController(text: widget.memoInfo.content);
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

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * (4/5),
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
                    controller: _contentController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => onDeletePressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DEFAULT_COLOR,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ), 
                    child: const Text("삭제"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => onSaveProssed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DEFAULT_COLOR,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ), 
                    child: const Text("수정"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}