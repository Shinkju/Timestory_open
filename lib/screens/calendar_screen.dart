import 'package:flutter/material.dart';
import 'package:timestory/layout/appbar.dart';
import 'package:timestory/widget/calendar/calendar_widget.dart';

class CalendarScreen extends StatelessWidget{
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: CalendarWidget(),
    );
  }
}