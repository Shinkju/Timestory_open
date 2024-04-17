import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/today/days_card_widget.dart';
import 'package:timestory/widget/today/days_custom_floating_button.dart';
import 'package:timestory/widget/today/days_sheet_widget.dart';

class TheDaysCard extends StatefulWidget{
  const TheDaysCard({super.key});
  
  @override
  State<TheDaysCard> createState() => _TheDaysCardState();
}

class _TheDaysCardState extends State<TheDaysCard>{
  late SharedPreferences prefs;
  bool extended = false;

  final GlobalKey targetButtonKey = GlobalKey();
  final GlobalKey<DaysCardState> daysKey = GlobalKey<DaysCardState>();

  @override
  void initState(){
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  void refreshDdayCard(){
    setState(() {
      if (daysKey.currentState != null) {
        daysKey.currentState!.refreshData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 8.0,),
          Expanded(
            child: DdayCard(key: daysKey,),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: CustomFloatingActionButton(
        menuItems: [
          PopupMenuItem(
            value: "0",
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: DEFAULT_COLOR,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "날짜수",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            value: "1",
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: DEFAULT_COLOR,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "디데이",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        onMenuItemSelected: (value){
          showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              builder: (_) => DDayBottomSheet(calculor: value == "0" ? "0" : "1", onInsert: refreshDdayCard),
          );
        },
      ),
    );
  }
}