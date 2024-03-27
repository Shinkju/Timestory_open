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
    return FutureBuilder<List<ScheduleMemoModel>>(
      future: memos,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            children: [
              for(var memo in snapshot.data!)
                Memo(
                  memoInfo: memo,
                  uuid: memo.uuid,
                ),
            ],
          );
        }
        return Container(); //데이터가 없는경우
      },
    );
  }
}

//내용 보여주는 위젯
class Memo extends StatefulWidget {
  final ScheduleMemoModel memoInfo;
  final String uuid;

  const Memo({
    super.key,
    required this.memoInfo,
    required this.uuid,
  });

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  //prefs받아오기
  @override
  void initState(){
    super.initState();
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap, // 수정 페이지로 이동
      child: Container(
        margin: const EdgeInsets.all(3.0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: DEFAULT_COLOR),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.memoInfo.content,
                style: const TextStyle(
                  color: DEFAULT_COLOR,
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

  // 클릭 시 수정페이지 이동
  onButtonTap() async {}
}
