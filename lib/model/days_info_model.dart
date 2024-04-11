class DaysModel{
  final String uuid, title, standardDate, calculation, icon;

  DaysModel({
    required this.uuid,
    required this.title,
    required this.standardDate,
    required this.calculation,
    required this.icon,
  });

  factory DaysModel.fromJson(Map<String, dynamic> json){
    return DaysModel(
      uuid: json['uuid'], 
      title: json['title'], 
      standardDate: json['standardDate'], 
      calculation: json['calculation'], 
      icon: json['icon'],
    );
  }

  Map<String, dynamic> daysToJson(){
    return{
      'uuid': uuid,
      'title': title,
      'standardDate': standardDate,
      'calculation': calculation,
      'icon': icon,
    };
  }

  @override
  String toString(){
    return 'DaysModel{uuid: $uuid, title: $title, standardDate: $standardDate, calculation: $calculation, icon: $icon}';
  }
}