import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:work_schedule/dashboard.dart';
import 'package:work_schedule/http.dart';

class WorkPage extends StatefulWidget {
  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  var year = 2010;
  var Null = null;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(year + 30),
    ))!;
    if (picked != Null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(year),
      lastDate: DateTime(year + 30),
    ))!;

    if (picked != Null && picked != endDate && startDate != Null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    ))!;
    if (picked != Null && startDate != Null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    ))!;
    if (picked != Null && endDate != Null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  Future<void> _addWork() async {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      var workData = {
        'headers': nameController.text,
        'description': descriptionController.text,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'startTime': startTime.toString(),
        'endTime': endTime.toString()
      };
      try {
        var response = await http.post(Uri.parse(createWork),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(workData));
        if (response.statusCode == 201) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
          );
        } else {
          print (jsonDecode(response.body));
        }
      } catch (error) {
          print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดตารางงานของคุณ'),
        backgroundColor: Color(0xFFFFCA79),
      ),
      backgroundColor: Color(0xFFFFECCF),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'ชื่องานของคุณ',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'คำอธิบายงาน',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await _selectStartDate(context);
                    await _selectStartTime(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.calendar_today),
                      SizedBox(width: 15),
                      Text(
                        'วันเริ่มต้น: ${startDate?.toString().split(' ')[0] ?? 'เลือก'} ${startTime?.format(context) ?? '00:00'}',
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    fixedSize: Size(300, 30), 
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _selectEndDate(context);
                    await _selectEndTime(context);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      Icon(Icons.calendar_today),
                      SizedBox(width: 15),
                      Text(
                        'วันครบกำหนด: ${endDate?.toString().split(' ')[0] ?? 'เลือก'} ${endTime?.format(context) ?? '00:00'}',
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    fixedSize: Size(300, 30), // ตั้งความกว้างและความสูงคงที่
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _addWork();
                },
                child: Text(
                  'บันทึก',
                  style: TextStyle(
                    color: Colors.black, // สีตัวหนังสือเป็นสีดำ
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFCA79), // สีพื้นหลังเป็นสี 255, 202, 121
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
