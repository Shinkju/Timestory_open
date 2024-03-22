import 'package:flutter/material.dart';
import 'package:timestory/layout/appbar.dart';
import 'package:timestory/widget/today/days_widget.dart';

class TheDayBeforeScreen extends StatelessWidget{
  const TheDayBeforeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: TheDaysCard(),
    );
  }
}