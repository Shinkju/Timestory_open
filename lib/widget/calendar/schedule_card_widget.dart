import 'package:flutter/material.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:timestory/service/schedule_service.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_modify_widget.dart';
import 'package:timestory/widget/calendar/daybar_widget.dart';

class ScheduleCard extends StatefulWidget{
  final String year, month, day;
  final DateTime selectedDate;

  const ScheduleCard({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.selectedDate,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late Future<List<ScheduleMemoModel>> memos;
  int scheduleCardMemoCount = 0;

  @override
  void initState(){
    super.initState();
    fetchMemos();
  }

  void fetchMemos(){
    memos = ScheduleService.getScheduleMemosById(widget.year, widget.month, widget.day);
    memos.then((value){
      setState(() {
        scheduleCardMemoCount = value.length;
      });
    }).catchError((error){
      print(error);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScheduleMemoModel>>(
      future: memos,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            children: [
              TodayBanner(
                selectedDate: widget.selectedDate, 
                count: scheduleCardMemoCount,
              ),
              const SizedBox(height: 8,),
              for(var memo in snapshot.data ?? [])
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

//내용 위젯
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
      onTap: (){ //수정페이지
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          isScrollControlled: true, //키보드가림 해결
          builder: (_) => ScheduleModifySheet(
            memoInfo: widget.memoInfo,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
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
                  fontSize: 13.5,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.edit_document,
                color: DEFAULT_COLOR,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
