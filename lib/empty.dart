import 'package:flutter/material.dart';
import 'package:work_schedule/work.dart';

class emptyPage extends StatefulWidget {
  const emptyPage({super.key});

  @override
  State<emptyPage> createState() => _emptyState();
}

class _emptyState extends State<emptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCA79),
        title: Align(
          alignment: Alignment.center,
          child: Text("ตารางงานของฉัน"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            alignment: Alignment.centerRight,
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(
          255, 243, 223, 192), // กำหนดสีพื้นหลังเป็น RGB (255, 202, 121)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'เพิ่มตารางงาน',
              style:
                  TextStyle(color: Colors.grey), // กำหนดสีตัวหนังสือเป็นสีเขียว
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WorkPage()),
          );
        },
        tooltip: 'สร้างตารางงาน', // ข้อความ tooltip
        backgroundColor: Colors.green, // กำหนดสีพื้นหลังของปุ่มเป็นสีเขียว
        foregroundColor: Colors.white, // กำหนดสีของไอคอนเป็นสีขาว
        shape: CircleBorder(), // กำหนดรูปร่างของปุ่มเป็นวงกลม
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
