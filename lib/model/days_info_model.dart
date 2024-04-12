
class DaysModel{
  final String uuid, title, standardDate, calculation;

  DaysModel({
    required this.uuid,
    required this.title,
    required this.standardDate,
    required this.calculation,
  });

  factory DaysModel.fromJson(Map<String, dynamic> json){
    return DaysModel(
      uuid: json['uuid'], 
      title: json['title'], 
      standardDate: json['standardDate'], 
      calculation: json['calculation'], 
    );
  }

  Map<String, dynamic> daysToJson(){
    return{
      'uuid': uuid,
      'title': title,
      'standardDate': standardDate,
      'calculation': calculation,
    };
  }

  @override
  String toString(){
    return 'DaysModel{uuid: $uuid, title: $title, standardDate: $standardDate, calculation: $calculation}';
  }
}