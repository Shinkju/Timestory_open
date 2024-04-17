import 'package:uuid/uuid.dart';

class Common{
  //UUID 생성
  static String getUuid(){
    var uuid = const Uuid();
    String uniqueId = uuid.v4();
    return uniqueId;
  }
}