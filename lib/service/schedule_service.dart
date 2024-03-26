import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/model/schedule_memo_model.dart';

class ScheduleService{

  //스케줄일정 목록
  static Future<List<ScheduleMemoModel>> getScheduleMemosById(String year, String month, String day) async{
    final prefs = await SharedPreferences.getInstance();
    String? scheduleInfo = prefs.getString('scheduleInfo');

    Map<String, dynamic>? scheduleData = scheduleInfo != null ? jsonDecode(scheduleInfo) : null;   //string형태의 scheduleInfo를 Map으로 변환

    List<ScheduleMemoModel> memosInstance = [];
    if(scheduleData != null){
        scheduleData.forEach((key, value) {
          final eYear = value['year'];
          final eMonth = value['month'];
          final eDay = value['day'];
          if(eYear == year && eMonth == month && eDay == day){
            memosInstance.add(ScheduleMemoModel.fromJson(value));
          }
        });
    }
    return memosInstance;
  }
}