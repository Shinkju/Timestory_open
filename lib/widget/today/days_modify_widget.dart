import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dpt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/common/imageIcon.dart';
import 'package:timestory/model/days_info_model.dart';

class DaysModifySheet extends StatefulWidget {
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

class _DaysModifySheetState extends State<DaysModifySheet> {
  late SharedPreferences prefs;
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late String? _selectedImage;
  late String _calculator;

  final GlobalKey targetButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.daysInfo.title);
    _selectedDate =
        DateFormat('yyyy-MM-dd').parse(widget.daysInfo.standardDate);
    _selectedImage = imageHandler(widget.daysInfo.icon);
    _calculator = widget.daysInfo.calculation;
    initPrefs();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _toggleCalculator() {
    setState(() {
      if (_calculator == "0") {
        _calculator = "1";
      } else {
        _calculator = "0";
      }
    });
  }

  String? imageHandler(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'assets/images/icon/calendarIcon.png';
    }
    return imagePath;
  }

  bool isFileExists(String filePath) {
    return File(filePath).existsSync();
  }

  void _selectDate() {
    dpt.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000, 1, 1),
      maxTime: DateTime(2100, 12, 31),
      currentTime: _selectedDate,
      locale: dpt.LocaleType.ko,
      onConfirm: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      theme: const dpt.DatePickerTheme(backgroundColor: Colors.white),
    );
  }

  //update
  void onSaveProssed(BuildContext context) async {
    String title = _titleController.text.trim();
    if (title.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonDataList = prefs.getStringList('daysInfo');

      if (jsonDataList != null) {
        List<DaysModel> dataList = jsonDataList
            .map((jsonData) => DaysModel.fromJson(json.decode(jsonData)))
            .toList();
        for (int i = 0; i < dataList.length; i++) {
          if (dataList[i].uuid == widget.daysInfo.uuid) {
            String iDate = DateFormat("yyyy-MM-dd").format(_selectedDate);

            dataList[i] = DaysModel(
              uuid: widget.daysInfo.uuid,
              title: title,
              standardDate: iDate,
              calculation: _calculator,
              icon: _selectedImage ?? '',
            );
            break;
          }
        }

        await prefs.setStringList("daysInfo",
            dataList.map((map) => jsonEncode(map.daysToJson())).toList());
        Fluttertoast.showToast(msg: "디데이가 수정되었습니다.");

        widget.onClose();
        Navigator.pop(context);
      } else {
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
  void onDeleteProssed(BuildContext context) async {
    List<String>? jsonDataList = prefs.getStringList('daysInfo');

    if (jsonDataList != null) {
      List<DaysModel> dataList = jsonDataList
          .map((jsonData) => DaysModel.fromJson(json.decode(jsonData)))
          .toList();
      dataList.removeWhere((dday) => dday.uuid == widget.daysInfo.uuid);

      await prefs.setStringList("daysInfo",
          dataList.map((map) => jsonEncode(map.daysToJson())).toList());
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
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              color: DEFAULT_COLOR,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onSaveProssed(context),
                        child: const Text(
                          "수정",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Lato",
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: DEFAULT_COLOR,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "D-DAY",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: _toggleCalculator,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: DEFAULT_COLOR,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _calculator == "0" ? "날짜수" : "디데이",
                              style: const TextStyle(
                                color: DEFAULT_COLOR,
                                fontFamily: "Lato",
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.change_circle,
                              color: DEFAULT_COLOR,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "계산방법",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontFamily: "Lato",
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 0,
                      bottom: bottomInsert,
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: _titleController.text.isNotEmpty
                                      ? ''
                                      : '디데이제목을 입력하세요',
                                  labelStyle: const TextStyle(
                                    fontFamily: "Lato",
                                    color: Colors.grey,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              key: targetButtonKey,
                              onPressed: () {
                                final RenderBox buttonBox = targetButtonKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Offset buttonOffset =
                                    buttonBox.localToGlobal(Offset.zero);
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
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedImage = value;
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 1,
                                padding: const EdgeInsets.all(18),
                              ),
                              child: Image.asset(
                                _selectedImage!,
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(
                              width: 0.1,
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: DEFAULT_COLOR,
                              size: 23,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "날짜",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: "Lato",
                              ),
                            ),
                            TextButton(
                              onPressed: _selectDate,
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: "Lato",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  TextButton(
                    onPressed: () => onDeleteProssed(context),
                    child: const Text(
                      "삭제",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Lato",
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
