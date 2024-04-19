class ScheduleMemoModel{
  final String sYear, sMonth, sDay, eYear, eMonth, eDay, uuid, content;

  ScheduleMemoModel({
    required this.sYear,
    required this.sMonth,
    required this.sDay,
    required this.eYear,
    required this.eMonth,
    required this.eDay,
    required this.uuid,
    required this.content,
  });

  factory ScheduleMemoModel.fromJson(Map<String, dynamic> json){ 
    return ScheduleMemoModel(
      sYear: json['sYear'],
      sMonth: json['sMonth'],
      sDay: json['sDay'],
      eYear: json['eYear'],
      eMonth: json['eMonth'],
      eDay: json['eDay'],
      uuid: json['uuid'],
      content: json['content'],
    );
  }

  Map<String,dynamic> scheduleToJson(){
    return{
      'sYear': sYear,
      'sMonth': sMonth,
      'sDay': sDay,
      'eYear': eYear,
      'eMonth': eMonth,
      'eDay': eDay,
      'uuid': uuid,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'ScheduleMemoModel{sYear: $sYear, sMonth: $sMonth, sDay: $sDay, eYear: $eYear, eMonth: $eMonth, eDay: $eDay, uuid: $uuid, content: $content}';
  }
}