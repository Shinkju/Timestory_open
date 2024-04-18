import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:timestory/service/schedule_service.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_modify_widget.dart';
import 'package:timestory/widget/calendar/daybar_widget.dart';

class ScheduleCard extends StatefulWidget{
  final String year, month, day;
  final DateTime selectedDate;
  final VoidCallback onUpdateMarker;

  const ScheduleCard({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.selectedDate,
    required this.onUpdateMarker,
  });

  @override
  State<ScheduleCard> createState() => ScheduleCardState();
}

class ScheduleCardState extends State<ScheduleCard> {
  late Future<List<ScheduleMemoModel>> memos;
  int scheduleCardMemoCount = 0;

  @override
  void initState(){
    super.initState();
    fetchMemos();
  }

  void refreshData() {
    setState(() {
        memos = ScheduleService.getScheduleMemosById(widget.year, widget.month, widget.day);
        memos.then((value) {
            setState(() {
                scheduleCardMemoCount = value.length;
            });
        }).catchError((error) {
            print('refreshData: 에러 발생 - $error');
        });
    });
    widget.onUpdateMarker();//calendar marker
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
          return SingleChildScrollView(
            child: Column(
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
                    onModify: refreshData,
                  ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

//내용 위젯
class Memo extends StatefulWidget {
  final ScheduleMemoModel memoInfo;
  final String uuid;
  final VoidCallback onModify;

  const Memo({
    super.key,
    required this.memoInfo,
    required this.uuid,
    required this.onModify,
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
          isScrollControlled: true,
          builder: (_) => ScheduleModifySheet(
            memoInfo: widget.memoInfo,
            onClose: widget.onModify,
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
              Expanded(
                child: Text(
                  widget.memoInfo.content,
                  style: const TextStyle(
                    color: DEFAULT_COLOR,
                    fontSize: 13.5,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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