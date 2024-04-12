import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/today/days_calculator.dart';
import 'package:timestory/widget/today/days_card_widget.dart';

class TheDaysCard extends StatefulWidget{
  const TheDaysCard({super.key});
  
  @override
  State<TheDaysCard> createState() => _TheDaysCardState();
}

class _TheDaysCardState extends State<TheDaysCard>{
  late SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          SizedBox(height: 8.0,),
          DdayCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DEFAULT_COLOR,
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const DaysCalculator()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}