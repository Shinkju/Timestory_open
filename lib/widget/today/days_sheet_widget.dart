import 'package:flutter/material.dart';

class DDayBottomSheet extends StatefulWidget{
  const DDayBottomSheet({super.key});
  
  @override
  State<StatefulWidget> createState() => _DDayBottomSheetState();
}

class _DDayBottomSheetState extends State<DDayBottomSheet>{
  late TextEditingController _titleController;
  late DateTime _selectedDate;

  @override
  void initState(){
    super.initState();
    _titleController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose(){
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 20.0,),
            Text('Select D-Day Date : '),
            SizedBox(height: 10.0,),
            TextButton(
              onPressed: () {
                //_selectedDate(context);
              }, 
              child: Text(
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                style: TextStyle(fontSize: 18,),
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveDDay();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  /*Future<void> _selectedDate(BuildContext context) async{
    final DateTime? pickedDate = await showDatePicker(
      context: context, 
      firstDate: DateTime(2020), 
      lastDate: DateTime(2100)
    );
    if(pickedDate != null && pickedDate != _selectedDate){
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }*/

  void _saveDDay() async{
   
  }

}