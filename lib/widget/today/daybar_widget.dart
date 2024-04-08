import 'package:flutter/material.dart';
import 'package:timestory/common/colors.dart';

class TodayBanner extends StatefulWidget{
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    super.key,
    required this.selectedDate,
    required this.count,
  });

  @override
  State<TodayBanner> createState() => _TodayBannerState();
}

class _TodayBannerState extends State<TodayBanner> {
  late DateTime _selectedDate;
  late int _count;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _count = widget.count;
  }

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
              //"${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일",
              "${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일",
              style: textStyle,
            ),
            Text(
              //"${widget.count}개",
              "$_count개",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }


  @override
  void didUpdateWidget(TodayBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != _selectedDate || widget.count != _count) {
      setState(() {
        _selectedDate = widget.selectedDate;
        _count = widget.count;
      });
    }
  }
  
}