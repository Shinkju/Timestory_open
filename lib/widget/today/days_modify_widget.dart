import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dpt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/common/imageIcon.dart';
import 'package:timestory/model/days_info_model.dart';

class DaysModifySheet extends StatefulWidget{
  final DaysModel daysInfo;
  final VoidCallback onClose;

  const DaysModifySheet({
    super.key,
    required this.daysInfo,
    required this.onClose,
  });
  
  @override
  State<DaysModifySheet> createState() => _DaysModifySheetState();
}

class _DaysModifySheetState extends State<DaysModifySheet>{
  late SharedPreferences prefs;
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late String? _selectedImage;

  final GlobalKey targetButtonKey = GlobalKey();

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController(text: widget.daysInfo.title);
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.daysInfo.standardDate);
    _selectedImage = imageHandler(widget.daysInfo.icon);
    initPrefs();
  }

  @override
  void dispose(){
    _titleController.dispose();
    super.dispose();
  }

  void initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }

  String? imageHandler(String? imagePath){
    if(imagePath == null || imagePath.isEmpty){
      return 'assets/images/icon/calendarIcon.png';
    }
    return imagePath;
  }

  bool isFileExists(String filePath) {
    return File(filePath).existsSync();
  }

  void _selectDate(){
    dpt.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000, 1, 1),
      maxTime: DateTime(2100, 12, 31),
      currentTime: _selectedDate,
      locale: dpt.LocaleType.ko,
      onConfirm: (date){
        setState(() {
          _selectedDate = date;
        });
      },
      theme: const dpt.DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  //update
  void onSaveProssed(BuildContext context) async{
    String title = _titleController.text.trim();
    if(title.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonDataList = prefs.getStringList('daysInfo');

      if(jsonDataList != null){
        List<DaysModel> dataList = jsonDataList.map((jsonData) => DaysModel.fromJson(json.decode(jsonData))).toList();
        for(int i=0; i<dataList.length; i++){
          if(dataList[i].uuid == widget.daysInfo.uuid){
            String iDate = DateFormat("yyyy-MM-dd").format(_selectedDate);

            dataList[i] = DaysModel(
              uuid: widget.daysInfo.uuid, 
              title: title, 
              standardDate: iDate, 
              calculation: widget.daysInfo.calculation, 
              icon: _selectedImage ?? '',
            );
            break;
          }
        }

        await prefs.setStringList("daysInfo", dataList.map((map) => jsonEncode(map.daysToJson())).toList());
        Fluttertoast.showToast(msg: "디데이가 수정되었습니다.");
      
        widget.onClose();
        Navigator.pop(context);

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('제목을 입력하세요.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  //delete
  void onDeleteProssed(BuildContext context) async{
    List<String>? jsonDataList = prefs.getStringList('daysInfo');

    if(jsonDataList != null){
      List<DaysModel> dataList = jsonDataList.map((jsonData) => DaysModel.fromJson(json.decode(jsonData))).toList();
      dataList.removeWhere((dday) => dday.uuid == widget.daysInfo.uuid);

      await prefs.setStringList("daysInfo", dataList.map((map) => jsonEncode(map.daysToJson())).toList());
      Fluttertoast.showToast(msg: "디데이가 삭제되었습니다.");

      widget.onClose();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * (4/5),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: bottomInsert,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '디데이 제목을 입력하세요.'
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                  ElevatedButton(
                    key: targetButtonKey,
                    onPressed: () {
                      final RenderBox buttonBox = targetButtonKey.currentContext?.findRenderObject() as RenderBox;
                      final Offset buttonOffset = buttonBox.localToGlobal(Offset.zero);
                      final Size buttonSize = buttonBox.size;
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          buttonOffset.dx,
                          buttonOffset.dy + buttonSize.height,
                          buttonOffset.dx + buttonSize.width,
                          buttonOffset.dy + buttonSize.height + 10,
                        ),
                        items: buildPopupMenuItems(context),
                      ).then((value){
                        if(value != null){
                          setState(() {
                            _selectedImage = value;
                          });
                        }
                      });
                    }, child: Image.asset(
                      _selectedImage!,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0,),
              const Text("날짜"),
              const SizedBox(width: 6.0),
              TextButton(
                onPressed: _selectDate, 
                child: Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onSaveProssed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DEFAULT_COLOR,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "수정",
                    style: TextStyle(
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50.0,),
              TextButton(
                onPressed: () => onDeleteProssed(context), 
                child: const Text(
                  "삭제",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Lato",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}