import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/model/days_info_model.dart';

class DaysService{
  static Future<List<DaysModel>> getDaysInfoByAll() async{
    final prefs = await SharedPreferences.getInstance();
    final List<String>? daysInfo = prefs.getStringList('daysInfo');

    List<DaysModel> daysInstance = [];
    if(daysInfo != null){
      for(String jsonStr in daysInfo){
        final Map<String, dynamic> daysMap = jsonDecode(jsonStr);
        final uuid = daysMap['uuid'];
        if(uuid.isNotEmpty){
          daysInstance.add(DaysModel.fromJson(daysMap));
        }
      }
    }
    return daysInstance;
  }
}