import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/styles/colors.dart';
import 'package:timestory/widget/today/days_sheet_widget.dart';

class TheDaysCard extends StatefulWidget{
  const TheDaysCard({super.key});
  
  @override
  State<TheDaysCard> createState() => _TheDaysCardState();
}


class _TheDaysCardState extends State<TheDaysCard>{
  List<Map<String, dynamic>> ddayList = [];

  @override
  void initState(){
    super.initState();
    loadDDayList();
  }

  Future<void> loadDDayList() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    String? ddayListJson = prefs.getString('dday_list');
    if(ddayListJson != null){
      setState(() {
        ddayList = List<Map<String, dynamic>>.from(jsonDecode(ddayListJson));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: ddayList.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(ddayList[index]['title']),
            subtitle: Text('D-Day: ${ddayList[index]['ddayDate']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DEFAULT_COLOR,
          onPressed: (){
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              builder: (_) => const DDayBottomSheet(),
              isScrollControlled: true, //키보드가림 해결
            );
          },
          child: const Icon(Icons.add,),
      ),
    );
  }
}

/* 필요인자 : 설정날짜, 제목, 디데이 or 날짜수, 아이콘이름  */