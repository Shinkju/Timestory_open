import 'dart:convert';
import 'package:http/http.dart' as http;
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

  //marker
  static Future<Map<DateTime, List<Event>>> loadScheduleFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonDataList = prefs.getStringList('scheduleInfo');
    Map<DateTime, List<Event>> monthlyEvents = {};

    if (jsonDataList != null) {
      for (String jsonData in jsonDataList) {
        try {
          Map<String, dynamic> scheduleMap = json.decode(jsonData);
          final sYear = scheduleMap['sYear'];
          final sMonth = scheduleMap['sMonth'];
          final sDay = scheduleMap['sDay'];
          final eYear = scheduleMap['eYear'];
          final eMonth = scheduleMap['eMonth'];
          final eDay = scheduleMap['eDay'];
          DateTime startDate = DateTime.parse('$sYear-$sMonth-$sDay');
          DateTime endDate = DateTime.parse('$eYear-$eMonth-$eDay');
          String title = scheduleMap['title'].toString();

          for(DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))){
            DateTime dateOnly = DateTime(date.year, date.month, date.day);
            if (!monthlyEvents.containsKey(dateOnly)) {
              monthlyEvents[dateOnly] = [];
            }
            monthlyEvents[dateOnly]!.add(Event(title));
          }
        } catch (e) {
          print('ERROR!! : $e');
        }
      }
    }
    return monthlyEvents;
  }

  static const String baseUrl = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo";
  static const String api_key_utf8 = "";
  //공휴일(월) api
  static Future<List<Holiday>> fetchHolidays(String year, String month) async{
    final url = await Uri.parse('$baseUrl?serviceKey=$api_key_utf8&solYear=$year&solMonth=$month&_type=json&numOfRows=30');
    final response = await http.get(url);

    List<Holiday> holidayInfo = [];
    if(response.statusCode == 200){
      final Map<String, dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes)); //한글깨짐 처리
      final int totalCount = jsonData['response']['body']['totalCount']; 

      if (totalCount > 0) {
        final dynamic items = jsonData['response']['body']['items']['item'];
        List<dynamic> itemList = items is List ? items : [items];
        List<Holiday> holidayInfo = itemList.map((item) => Holiday.fromJson(item)).toList();
        return holidayInfo;
      }

    }
    return [];
  }
}
