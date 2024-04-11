import 'package:flutter/material.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/days_info_model.dart';
import 'package:timestory/service/days_service.dart';

class DaysCard extends StatefulWidget{
  const DaysCard({super.key});
  
  @override
  State<DaysCard> createState() => _DaysCardState();
}

class _DaysCardState extends State<DaysCard>{
  late Future<List<DaysModel>> days;
  int daysCardCount = 0;

  @override
  void initState(){
    super.initState();
    days = DaysService.getDaysInfoByAll();
    days.then((value){
      setState(() {
        daysCardCount = value.length;
      });
    }).catchError((error){
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DaysModel>>(
      future: days, 
     builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            children: [
              const SizedBox(height: 8,),
              for(var dday in snapshot.data ?? [])
                Dday(
                  daysInfo: dday,
                  uuid: dday.uuid,
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
class Dday extends StatefulWidget{
  final DaysModel daysInfo;
  final String uuid;

  const Dday({
    super.key,
    required this.daysInfo,
    required this.uuid,
  });

  @override
  State<Dday> createState() => _DdayState();
}

class _DdayState extends State<Dday>{
  int dDayCount = 0;
  String? txt;

  @override
  void initState(){
    super.initState();
    calculateDDay();
  }

  void calculateDDay(){
    DateTime currentDate = DateTime.now();
    DateTime standardDate = DateTime.parse(widget.daysInfo.standardDate);

    if(widget.daysInfo.calculation == '1'){
      dDayCount = standardDate.difference(currentDate).inDays;
      if(dDayCount < 0){
        txt = 'D+${dDayCount.abs()}';
      }else if(dDayCount > 0){
        txt = 'D-$dDayCount';
      }else{
        txt = 'D-Day';
      }
    }else{
      dDayCount = currentDate.difference(standardDate).inDays + 1;
      txt = '$dDayCount일';
    }

    setState(() {
      dDayCount = dDayCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ //수정페이지
        
      },
      child: Container(
        margin: const EdgeInsets.all(8.0,),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0,),
          border: Border.all(color: DEFAULT_COLOR),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                IconData(int.parse(widget.daysInfo.icon), fontFamily: 'MaterialIcons'),
                size: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txt.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.daysInfo.title,
                      style: const TextStyle(
                        fontFamily: "Lato",
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.daysInfo.standardDate,
                      style: const TextStyle(
                        fontFamily: "Lato",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}