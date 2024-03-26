import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:timestory/service/schedule_service.dart';
import 'package:timestory/common/colors.dart';

class ScheduleCard extends StatefulWidget{
  final String year, month, day;

  const ScheduleCard({
    super.key,
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late SharedPreferences prefs;
  late Future<List<ScheduleMemoModel>> memos;

  @override
  void initState(){
    super.initState();
    memos = ScheduleService.getScheduleMemosById(widget.year, widget.month, widget.day);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: memos,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Column(
                    children: [
                      for(var memo in snapshot.data!)
                        Memo(
                          memoInfo: memo,
                        ),
                    ],
                  );
                }
                return Container(); //데이터가 없는경우
              },
            ),
          ],
        ),
      ),
    );
  }
}

//내용 보여주는 위젯
class Memo extends StatefulWidget{
  final ScheduleMemoModel memoInfo;
  
  const Memo({
    super.key,
    required this.memoInfo,
  });
  
  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo>{
  late SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
  }
  @override
  void didChangeDependencies(){ //의존하는 객체가 변경되었을 때 실행
    super.didChangeDependencies();
  }

  //클릭 시 수정페이지 이동
  onButtonTap() async{

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap, //수정 페이지로 이동
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: DEFAULT_COLOR,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.memoInfo.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: "Lato",
                ),
              ),
              const Icon(
                Icons.edit_document,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}