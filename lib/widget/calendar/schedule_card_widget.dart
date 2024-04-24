import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timestory/model/schedule_memo_model.dart';
import 'package:timestory/service/schedule_service.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/calendar/schedule_modify_widget.dart';
import 'package:timestory/widget/calendar/daybar_widget.dart';

class ScheduleCard extends StatefulWidget{
  final String year, month, day;
  final DateTime selectedDate;
  final VoidCallback onUpdateMarker;
  final List<Event>? selectedEvents;

  const ScheduleCard({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.selectedDate,
    required this.onUpdateMarker,
    required this.selectedEvents,
  });

  @override
  State<ScheduleCard> createState() => ScheduleCardState();
}

class ScheduleCardState extends State<ScheduleCard> {
  late Future<List<ScheduleMemoModel>> memos;
  int scheduleCardMemoCount = 0;
  bool holidayCheck = false;

  @override
  void initState(){
    super.initState();
    fetchMemos();
    if(widget.selectedEvents != null&& widget.selectedEvents![0].title != 'null'){
      holidayCheck = true;
    }
  }
  void refreshData() async {
    if(mounted){
      setState(() {
        memos = ScheduleService.getScheduleMemosById(widget.year, widget.month, widget.day);
        memos.then((value) {
            setState(() {
                scheduleCardMemoCount = value.length;
                if(widget.selectedEvents != null && widget.selectedEvents![0].title != 'null'){
                  scheduleCardMemoCount += 1;
                }
            });
        }).catchError((error) {
            print('refreshData: 에러 발생 - $error');
        });
      });
      widget.onUpdateMarker();//calendar marker
    }
  }

  void fetchMemos(){
    memos = ScheduleService.getScheduleMemosById(widget.year, widget.month, widget.day);
    memos.then((value){
      setState(() {
        if (holidayCheck){
          scheduleCardMemoCount = 1;
        }
        scheduleCardMemoCount += value.length;
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
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }else if(snapshot.hasData){
          return Column(
            children: [
              TodayBanner(
                selectedDate: widget.selectedDate, 
                count: scheduleCardMemoCount,
              ),
              const SizedBox(height: 8.0,),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        if(holidayCheck)
                          HolidayMemo(
                            events : widget.selectedEvents!,
                            selectedDate: widget.selectedDate,
                          ),
                        for(var memo in snapshot.data ?? [])
                          Memo(
                            memoInfo: memo,
                            uuid: memo.uuid,
                            onModify: refreshData,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
        margin: const EdgeInsets.only(
          left: 8,
          top: 4,
          right: 8,
          bottom: 4,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: DEFAULT_COLOR, width: 1.5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.memoInfo.content,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      "${widget.memoInfo.sYear}-${widget.memoInfo.sMonth}-${widget.memoInfo.sDay} ~ ${widget.memoInfo.eYear}-${widget.memoInfo.eMonth}-${widget.memoInfo.eDay}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: "Lato",
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
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

//공휴일 위젯
class HolidayMemo extends StatefulWidget{
  final List<Event> events;
  final DateTime selectedDate;

  const HolidayMemo({
    super.key,
    required this.events,
    required this.selectedDate,
  });
  
  @override
  State<HolidayMemo> createState() => _HolidayMemoState();
}

class _HolidayMemoState extends State<HolidayMemo>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        top: 4,
        right: 8,
        bottom: 4,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: DEFAULT_COLOR, width: 1.5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.events[0].title}(공휴일)",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2,'0')}-${widget.selectedDate.day.toString().padLeft(2,'0')}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: "Lato",
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}