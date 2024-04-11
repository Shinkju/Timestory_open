import 'package:flutter/material.dart';
import 'package:timestory/common/colors.dart';
import 'package:timestory/widget/today/days_sheet_widget.dart';

class DaysCalculator extends StatelessWidget{
  const DaysCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), 
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: (){
                  //1
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true, 
                    builder: (_) => const DDayBottomSheet(calculor: "1"),
                    isScrollControlled: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DEFAULT_COLOR,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8,),
                ),
                child: const Text(
                  "디데이",
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  //0
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true, 
                    builder: (_) => const DDayBottomSheet(calculor: "0"),
                    isScrollControlled: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DEFAULT_COLOR,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8,),
                ),
                child: const Text(
                  "날짜수",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}