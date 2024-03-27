import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/model/schedule_memo_model.dart';

class ScheduleService{

  //스케줄일정 목록
  static Future<List<ScheduleMemoModel>> getScheduleMemosById(String year, String month, String day) async{
    final prefs = await SharedPreferences.getInstance();
    final List<String>? scheduleInfo = prefs.getStringList('scheduleInfo');

    List<ScheduleMemoModel> memosInstance = [];
    if(scheduleInfo != null){
        for(String jsonStr in scheduleInfo){
          final Map<String, dynamic> scheduleMap = jsonDecode(jsonStr);
          final eYear = scheduleMap['year'];
          final eMonth = scheduleMap['month'];
          final eDay = scheduleMap['day'];
          if(eYear == year && eMonth == month && eDay == day){
            memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
          }
        }
        return memosInstance;
    }
    throw Error();
  }
}