import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:work_schedule/work.dart';
import 'package:work_schedule/http.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  List<Map<String, dynamic>> workList = [{}];
  String selectedItemValue = "กำลังทำ";
  Future<List<Map<String, dynamic>>> getAllWork() async {
    try {
      var response = await http.get(Uri.parse(getAllwork),
          headers: {"Content-Type": "application/json"});
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null && jsonResponse != workList && response.statusCode == 200) {
        if (jsonResponse is List) {
          workList = [{}];
          workList = List<Map<String, dynamic>>.from(jsonResponse);
        } else if (jsonResponse is Map) {
          workList = [{}];
          workList.add(Map<String, dynamic>.from(jsonResponse));
        } else {
          throw ("Invalid response format");
        }

        return workList;
      } else {
        throw ("No data received");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteWork(int index) async {
    try {
      var response = await http.delete(
        Uri.parse(
            '$getAllwork/$index'),
        headers: {
          "Content-Type": "application/json",
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      } else {
        throw ("ลบผิดพลาด");
      }
    } catch (error) {
      print(error);
    }
  }

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
            onPressed: () {
              getAllWork();
            },
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(243, 223, 192, 1),
      body: Center(
        child: ListView.builder(
          itemCount: workList.length,
          itemBuilder: (context, index) {
            // var workItem = workList[index];
            // var aders = workItem['headers'];
            // var itemStartDate = workItem['startDate'];
            // var itemEndDathee = workItem['endDate'];
            // var itemStartTime = workItem['startTime'];
            // var itemEndTime = workItem['endTime'];
            // var selectedItemValue = workItem['status'];

            return Container(
              width: 400,
              height: 230,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Create project flutter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('วันเริ่มต้น: 2023-10-5 05:40 PM')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('วันครบกำหนด: 2023-10-6 09:00 AM')
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              DropdownButton<String>(
                                value: selectedItemValue,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'กำลังทำ',
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('กำลังทำ'),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'แก้ไข',
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('แก้ไข'),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'เสร็จสิ้น',
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('เสร็จสิ้น'),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedItemValue = value!;
                                  });
                                },
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteWork(index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkPage()),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
