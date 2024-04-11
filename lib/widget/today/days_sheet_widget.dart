import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/common.dart';
import 'package:timestory/model/days_info_model.dart';

class DDayBottomSheet extends StatefulWidget{
  final String calculor;
  const DDayBottomSheet({
    super.key,
    required this.calculor,
  });
  
  @override
  State<StatefulWidget> createState() => _DDayBottomSheetState();
}

class _DDayBottomSheetState extends State<DDayBottomSheet>{
  late SharedPreferences prefs;
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  IconData? _selectedIcon;

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedIcon = Icons.event;
    initPrefs();
  }

  @override
  void dispose(){
    _titleController.dispose();
    super.dispose();
  }

  void initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  //save
  void _saveDDay() async{
    String title = _titleController.text.trim();
    if(title.isNotEmpty && _selectedIcon != null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? existingData = prefs.getStringList('daysInfo');
      List<DaysModel> dataList = [];

      //이미데이터가 있다면 불러옴
      if(existingData != null){
        dataList = existingData.map((jsonString) => DaysModel.fromJson(json.decode(jsonString))).toList();
      }

      String? _i_date;
      if(widget.calculor == '1'){
        _i_date = DateFormat('yyyy-MM-dd').format(_selectedDate);
      }else{

      }

      //새로운 데이터 저장
      dataList.add(DaysModel(
        uuid: Common.getUuid(), 
        title: title, 
        standardDate: _i_date!, 
        calculation: widget.calculor, 
        icon: _selectedIcon.toString(),
      ));

      List<String> newDataList = dataList.map((day) => json.encode(day.daysToJson())).toList();
      await prefs.setStringList('daysInfo', newDataList);


      Fluttertoast.showToast(msg: '저장되었습니다.');
      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목 또는 아이콘을 선택해야 합니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 20.0,),
            const Text('Select D-Day Date : '),
            const SizedBox(height: 5.0,),
            TextButton(
              onPressed: _selectDate,
              child: Text(
                DateFormat('yyyy-MM-dd').format(_selectedDate),
                style: const TextStyle(fontSize: 18,),
              )
            ),
            const SizedBox(height: 20.0,),
            const Text('Select Icon: '),
            PopupMenuButton<IconData>(
              onSelected: (icon){
                setState(() {
                  _selectedIcon = icon;
                });
              },
              itemBuilder: (context){
                return [
                  const PopupMenuItem(
                    value: Icons.domain_verification_outlined,
                    child: Icon(Icons.domain_verification_outlined),
                  ),
                  const PopupMenuItem(
                    value: Icons.wysiwyg_rounded,
                    child: Icon(Icons.wysiwyg_rounded),
                  ),
                  const PopupMenuItem(
                    value: Icons.access_alarm,
                    child: Icon(Icons.access_alarm),
                  ),
                  const PopupMenuItem(
                    value: Icons.check,
                    child: Icon(Icons.check),
                  ),
                  const PopupMenuItem(
                    value: Icons.yard_rounded,
                    child: Icon(Icons.yard_rounded),
                  ),
                  const PopupMenuItem(
                    value: Icons.wallet_travel_outlined,
                    child: Icon(Icons.wallet_travel_outlined),
                  ),
                ];
              },
              child: Icon(
                _selectedIcon ?? Icons.domain_verification_outlined,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveDDay,
        child: const Icon(Icons.save),
      ),
    );
  }

  //date 조회
  Future<void> _selectDate() async{
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020), 
      lastDate: DateTime(2100)
    );
    if(pickedDate != null && pickedDate != _selectedDate){
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

}
