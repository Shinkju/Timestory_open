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
        final sMonth = scheduleMap['sMonth'];
        final sDay = scheduleMap['sDay'];
        //종료일
        final eYear = scheduleMap['eYear'];
        final eMonth = scheduleMap['eMonth'];
        final eDay = scheduleMap['eDay'];
        if(sYear == year && sMonth == month && sDay == day){
          memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
        }
        if(eYear == year && eMonth == month && eDay == day){
          memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
        }

        DateTime dateToCheck = DateTime.parse('$year-$month-$day');
        DateTime startDate = DateTime.parse('$sYear-$sMonth-$sDay');
        DateTime endDate = DateTime.parse('$eYear-$eMonth-$eDay');

        if(dateToCheck.isAfter(startDate.subtract(Duration(days: 1))) && dateToCheck.isBefore(endDate.add(Duration(days: 1)))){ //시작일과 종료일 사이
          memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
        }
      }
      return memosInstance;
    }
    return [];
  }

  //marker
  static Future<List<ScheduleMemoModel>> getScheduleMemosByAll(String year, String month) async{
    final prefs = await SharedPreferences.getInstance();
    final List<String>? scheduleInfo = prefs.getStringList('scheduleInfo');

    List<ScheduleMemoModel> memosInstance = [];
    if(scheduleInfo != null){
      for(String jsonStr in scheduleInfo){
        final Map<String, dynamic> scheduleMap = jsonDecode(jsonStr);
        /*final eYear = scheduleMap['year'];
        final eMonth = scheduleMap['month'];
        if(eYear == year && eMonth == month){
          memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
        }*/

        final sYear = scheduleMap['sYear'];
        final sMonth = scheduleMap['sMonth'];
        final sDay = scheduleMap['sDay'];
        final eYear = scheduleMap['eYear'];
        final eMonth = scheduleMap['eMonth'];
        final eDay = scheduleMap['eDay'];

        final startDate = DateTime.parse('$sYear-$sMonth-$sDay');
        final endDate = DateTime.parse('$eYear-$eMonth-$eDay');

        //검사기간 설정
        final startOfMonth = DateTime.parse('$year-$month-01');
        final endOfMonth = DateTime(
          int.parse(year),
          int.parse(month) + 1,
          0,
        );

        bool isWithinMonth = (startDate.isAfter(startOfMonth) || startDate.isAtSameMomentAs(startOfMonth)) &&
                              (endDate.isBefore(endOfMonth) || endDate.isAtSameMomentAs(endOfMonth));
        if(isWithinMonth){
          memosInstance.add(ScheduleMemoModel.fromJson(scheduleMap));
        }
      }
      return memosInstance;
    }
    return [];
  }
  
}