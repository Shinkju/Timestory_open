class ScheduleMemoModel{
  final String year, month, day, uuid, content;

  ScheduleMemoModel({
    required this.year,
    required this.month,
    required this.day,
    required this.uuid,
    required this.content,
  });

  factory ScheduleMemoModel.fromJson(Map<String, dynamic> json){ 
    return ScheduleMemoModel(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      uuid: json['uuid'],
      content: json['content'],
    );
  }

  Map<String,dynamic> scheduleToJson(){
    return{
      'year': year,
      'month': month,
      'day': day,
      'uuid': uuid,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'ScheduleMemoModel{year: $year, month: $month, day: $day, uuid: $uuid, content: $content}';
  }
}