import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dpt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/common/common.dart';
import 'package:timestory/common/imageIcon.dart';
import 'package:timestory/model/days_info_model.dart';

class DDayBottomSheet extends StatefulWidget{
  final String calculor;
  final VoidCallback onInsert;

  const DDayBottomSheet({
    super.key,
    required this.calculor,
    required this.onInsert,
  });
  
  @override
  State<StatefulWidget> createState() => _DDayBottomSheetState();
}

class _DDayBottomSheetState extends State<DDayBottomSheet>{
  late SharedPreferences prefs;
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late String? _selectedImage;

  final GlobalKey targetButtonKey = GlobalKey();

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedImage = 'assets/images/icon/calendarIcon.png';
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

  Future<void> _selectDate() async{
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

  //save
  void onSaveProssed(BuildContext context) async{
    String title = _titleController.text.trim();
    if(title.isNotEmpty){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? existingData = prefs.getStringList('daysInfo');
      List<DaysModel> dataList = [];

      if(existingData != null){
        dataList = existingData.map((jsonString) => DaysModel.fromJson(json.decode(jsonString))).toList();
      }

      String iDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

      dataList.add(DaysModel(
        uuid: Common.getUuid(), 
        title: title, 
        standardDate: iDate, 
        calculation: widget.calculor,
        icon: _selectedImage ?? '',
      ));

      List<String> newDataList = dataList.map((day) => json.encode(day.daysToJson())).toList();
      await prefs.setStringList('daysInfo', newDataList);

      Fluttertoast.showToast(msg: '저장되었습니다.');

      widget.onInsert();
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

  @override
  Widget build(BuildContext context) {
    final bottomInsert = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16,),
              color: DEFAULT_COLOR,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                        icon: const Icon(Icons.close, color: Colors.white,),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "D-DAY",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => onSaveProssed(context),
                        child: const Text(
                          "저장",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Lato",
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 16,
                bottom: bottomInsert,
              ),
              color: Colors.white,
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
                          labelText: '디데이 제목을 입력하세요.',
                          labelStyle: TextStyle(
                            fontFamily: "Lato",
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
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
                        _selectedImage ?? 'assets/images/icon/calendarIcon.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text('날짜'),
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
                        child: const Text('저장'),
                    ),
                ),
            ],
          ),
            ),
          ],
        ),
      ),
    );

    /*return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
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
                          labelText: '디데이 제목을 입력하세요.',
                          labelStyle: TextStyle(
                            fontFamily: "Lato",
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
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
                        _selectedImage ?? 'assets/images/icon/calendarIcon.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text('날짜'),
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
                        child: const Text('저장'),
                    ),
                ),
            ],
          ),
        ),
      ),
    );*/
  }
}
