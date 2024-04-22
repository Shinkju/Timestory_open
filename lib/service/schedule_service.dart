import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/model/schedule_memo_model.dart';

class ScheduleService{

  //schedule
  static Future<List<ScheduleMemoModel>> getScheduleMemosById(String year, String month, String day) async{
    final prefs = await SharedPreferences.getInstance();
    final List<String>? scheduleInfo = prefs.getStringList('scheduleInfo');

    List<ScheduleMemoModel> memosInstance = [];
    if(scheduleInfo != null){
      for(String jsonStr in scheduleInfo){
        final Map<String, dynamic> scheduleMap = jsonDecode(jsonStr);
        //시작일
        final sYear = scheduleMap['sYear'];
        final sMonth = scheduleMap['sMonth'].toString().padLeft(2, '0');
        final sDay = scheduleMap['sDay'].toString().padLeft(2, '0');
        final startDate = DateTime.parse('$sYear-$sMonth-$sDay');
        //종료일
        final eYear = scheduleMap['eYear'];
        final eMonth = scheduleMap['eMonth'].toString().padLeft(2, '0');
        final eDay = scheduleMap['eDay'].toString().padLeft(2, '0');
        final endDate = DateTime.parse('$eYear-$eMonth-$eDay');

        final currentDate = DateTime(int.parse(year), int.parse(month.padLeft(2,'0')), int.parse(day.padLeft(2, '0')));
        if(currentDate.isAfter(startDate.subtract(Duration(days: 1))) && currentDate.isBefore(endDate.add(Duration(days: 1)))){
          memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
        }
      }
      return memosInstance;
    }
    return [];
  }
}
