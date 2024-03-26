class ScheduleMemoModel{
  final String year, month, day, uuid, content;

  ScheduleMemoModel({
    required this.year,
    required this.month,
    required this.day,
    required this.uuid,
    required this.content,
  });

  factory ScheduleMemoModel.fromJson(Map<String, dynamic> json){  //factory: 클래스의 생성자 정의(복잡로직 필요, 캐시된 객체 반환, 객체생성 방법 중 이를 선택하는 로직이 필요)시 사용
    return ScheduleMemoModel(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      uuid: json['uuid'],
      content: json['content'],
    );
  }

  Map<String,dynamic> schduleToJson(){
    return{
      'year': year,
      'month': month,
      'day': day,
      'uuid': uuid,
      'content': content,
    };
  }
}