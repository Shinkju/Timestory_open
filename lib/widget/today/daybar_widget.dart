import 'package:flutter/material.dart';
import 'package:timestory/common/colors.dart';

class TodayBanner extends StatelessWidget{
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    super.key,
    required this.selectedDate,
    required this.count,
  });
  
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: "Lato",
      color: Colors.white,
    );

    return Container(
      color: DEFAULT_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //양끝 배치
          children: [
            Text(
              "${selectedDate.year}.${selectedDate.month}.${selectedDate.day}",
              style: textStyle,
            ),
            Text(
              "$count개",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}