import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DDayBottomSheet extends StatefulWidget{
  const DDayBottomSheet({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _DDayBottomSheetState();
}

class _DDayBottomSheetState extends State<DDayBottomSheet>{
  late TextEditingController _titleController;
  late DateTime _selectedDate;

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose(){  //controller 객체가 제거될 때 변수에 할당 된 메모리를 해제하기 위해
    _titleController.dispose();
    super.dispose();
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
            const SizedBox(height: 10.0,),
            TextButton(
              onPressed: (){
                _selectDate();
              },
              child: Text(
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                style: const TextStyle(fontSize: 18,),
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveDDay();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  //date 조회
  Future<void> _selectDate() async{
    final DateTime? pickedDate = await showDatePicker(
      context: context, 
      firstDate: DateTime(2020), 
      lastDate: DateTime(2100)
    );
    if(pickedDate != null && pickedDate != _selectedDate){
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  //위젯 저장
  void _saveDDay() async{
    String title = _titleController.text.trim();
    if(title.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> ddayList = prefs.getStringList('dday_list') ?? [];
      Map<String, dynamic> newDDay = {
        'title': title,
        'ddayDate': DateFormat('yyyy-MM-dd').format(_selectedDate),
      };
      ddayList.add(jsonEncode(newDDay));
      await prefs.setStringList('dday_list', ddayList);

      Fluttertoast.showToast(msg: '저장되었습니다.');

      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title cannot be empty'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

}
