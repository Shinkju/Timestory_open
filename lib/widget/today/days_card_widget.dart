import 'package:flutter/material.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/model/days_info_model.dart';
import 'package:timestory/service/days_service.dart';
import 'package:timestory/widget/today/days_modify_widget.dart';

class DdayCard extends StatefulWidget {
  const DdayCard({super.key});

  @override
  State<DdayCard> createState() => DaysCardState();
}

class DaysCardState extends State<DdayCard> {
  late Future<List<DaysModel>> days;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    setState(() {
      days = DaysService.getDaysInfoByAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DaysModel>>(
      future: days,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  for (var dday in snapshot.data ?? [])
                    Dday(
                      key: UniqueKey(),
                      daysInfo: dday,
                      uuid: dday.uuid,
                      onModify: refreshData,
                    ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                "디데이 일정이 존재하지 않습니다.",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold,
                  color: DEFAULT_COLOR,
                ),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text(
              "데이터를 불러오는 도중 에러발생",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          );
        }
      },
    );
  }
}

//내용 위젯
class Dday extends StatefulWidget {
  final DaysModel daysInfo;
  final String uuid;
  final VoidCallback onModify;

  const Dday({
    super.key,
    required this.daysInfo,
    required this.uuid,
    required this.onModify,
  });

  @override
  State<Dday> createState() => _DdayState();
}

class _DdayState extends State<Dday> {
  int dDayCount = 0;
  String? txt;

  @override
  void initState() {
    super.initState();
    calculateDDay();
  }

  void calculateDDay() {
    DateTime currentDate = DateTime.now();
    DateTime standardDate = DateTime.parse(widget.daysInfo.standardDate);
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    standardDate = DateTime(standardDate.year, standardDate.month, standardDate.day);

    int updatedDdayCount = 0;
    String updatedTxt;

    if (widget.daysInfo.calculation == '1') {
      updatedDdayCount = standardDate.difference(currentDate).inDays;
      if (updatedDdayCount < 0) {
        updatedTxt = 'D+${updatedDdayCount.abs()}';
      } else if (updatedDdayCount >= 1) {
        updatedTxt = 'D-$updatedDdayCount';
      } else {
        updatedTxt = 'D-Day';
      }
    } else {
      updatedDdayCount = currentDate.difference(standardDate).inDays + 1;
      updatedTxt = '$updatedDdayCount일';
    }

    setState(() {
      dDayCount = updatedDdayCount;
      txt = updatedTxt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //수정페이지
        showModalBottomSheet(
          context: context,
          isDismissible: true,
          isScrollControlled: true,
          builder: (_) => DaysModifySheet(
            daysInfo: widget.daysInfo,
            onClose: widget.onModify,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(
          8.0,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            3.0,
          ),
          border: Border.all(color: DEFAULT_COLOR, width: 2.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    widget.daysInfo.icon,
                    width: 30,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/icon/calendarIcon.png',
                        width: 30,
                        height: 30,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.daysInfo.title,
                      style: const TextStyle(
                        fontFamily: "Lato",
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      widget.daysInfo.standardDate,
                      style: const TextStyle(
                        fontFamily: "Lato",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                txt.toString(),
                style: const TextStyle(
                  color: DEFAULT_COLOR,
                  fontSize: 19,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
