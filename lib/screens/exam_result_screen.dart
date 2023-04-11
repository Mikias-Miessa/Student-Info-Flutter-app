import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import '../components/navigation_drawer.dart';
import '../components/navigation.dart';
import '../components/result_tile.dart';
import '../services/api.dart';
import '../services/local_storage_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final storage = FlutterSecureStorage();
final userinfo = LocalStorage(storage: storage);

class ExamResult extends StatefulWidget {
  static String id = "ExamResult";

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  String? _dropdownValue;
  String? _dropdownValue2;
  String? _dropdownValue3;
  String? _dropdownValue4;
  List? Subject;
  List? Result;
  int? dataLength;
  List<dynamic> data = [];
  bool _saving = false;
  // function that gets results based on the value of dropdown menu items
  void getResult() async {
    try {
      var currentUser = await userinfo.readUserData();
      Uri url = Uri.parse(API.examResult);
      http.Response response = await http.post(url, body: {
        'Subject': _dropdownValue,
        'Type': _dropdownValue2,
        'Period': _dropdownValue3,
        'Year': _dropdownValue4,
        'User': currentUser
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _saving = false;
        });
        data = jsonDecode(response.body);
        dataLength = data.length;
        print('data length:$dataLength');
        print(data);
        Subject = [];
        Result = [];
        setState(() {
          for (int i = 0; i < data.length; i++) {
            String newSubject = data[i]['Subject'];
            String newResult = data[i]['Result'];
            Subject!.add(newSubject);
            Result!.add(newResult);
          }
        });
        print(Subject);
        print(Result);
      }
    } catch (e) {
      setState(() {
        _saving = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      // backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text('Exam Result'),
        backgroundColor: Color(0xffffa500),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // handle the press
              userinfo.deleteToken('User');
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Filter by'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                  // dropdownColor: Colors.blue,

                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  hint: Text(
                    'Subject',
                    style: TextStyle(fontSize: 15),
                  ),
                  items: const [
                    DropdownMenuItem(
                      child: Text('All Subjects'),
                      value: 'Allsubject',
                    ),
                    DropdownMenuItem(
                      child: Text('Amharic'),
                      value: '101',
                    ),
                    DropdownMenuItem(
                      child: Text('English'),
                      value: '102',
                    ),
                    DropdownMenuItem(
                      child: Text('Mathematics'),
                      value: '103',
                    ),
                  ],
                  value: _dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue = value;
                      print(_dropdownValue);
                    });
                  },
                ),
                DropdownButton(
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  hint: Text(
                    'Exam Type',
                    style: TextStyle(fontSize: 15),
                  ),
                  items: const [
                    // DropdownMenuItem(
                    //   child: Text(
                    //     'Choose Subject',
                    //     style: TextStyle(fontSize: 12, color: Colors.grey),
                    //   ),
                    //   value: '',
                    // ),
                    DropdownMenuItem(
                      child: Text('Test 1'),
                      value: 'Test 1',
                    ),
                    DropdownMenuItem(
                      child: Text('Test 2'),
                      value: 'Test 2',
                    ),
                    DropdownMenuItem(
                      child: Text('Mid'),
                      value: 'Mid',
                    ),
                    DropdownMenuItem(
                      child: Text('Final'),
                      value: 'Final',
                    ),
                  ],
                  value: _dropdownValue2,
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue2 = value;
                      print(_dropdownValue2);
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                  // dropdownColor: Colors.blue,
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  hint: Text(
                    'Academic Period',
                    style: TextStyle(fontSize: 15),
                  ),
                  items: const [
                    DropdownMenuItem(
                      child: Text('1st Semester'),
                      value: '1S',
                    ),
                    DropdownMenuItem(
                      child: Text('2nd Semester'),
                      value: '2S',
                    ),
                  ],
                  value: _dropdownValue3,
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue3 = value;
                      print(_dropdownValue3);
                    });
                  },
                ),
                DropdownButton(
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  hint: Text(
                    'Academic Year',
                    style: TextStyle(fontSize: 15),
                  ),
                  items: const [
                    DropdownMenuItem(
                      child: Text('2015'),
                      value: '2023',
                    ),
                    DropdownMenuItem(
                      child: Text('2014'),
                      value: '2014',
                    ),
                    DropdownMenuItem(
                      child: Text('2013'),
                      value: '2013',
                    ),
                    DropdownMenuItem(
                      child: Text('2012'),
                      value: '2012',
                    ),
                  ],
                  value: _dropdownValue4,
                  onChanged: (value) {
                    setState(() {
                      _dropdownValue4 = value;
                      print(_dropdownValue4);
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _saving = true;
                  });
                  getResult();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xff1f75fe),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  child: Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // height: 280,
                decoration: BoxDecoration(
                    color: Color(0xff1f75fe),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(33),
                        topRight: Radius.circular(33)),
                    boxShadow: [
                      BoxShadow(
                        // offset: Offset.infinite,
                        blurRadius: 2,
                        blurStyle: BlurStyle.outer,
                        color: Colors.grey,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    // height: 270,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffffa500), Color(0xffffffff)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: data.length > 0
                        ? ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ResultTile(
                                  Subject: Subject![index],
                                  Result: Result![index]);
                            },
                          )
                        : Center(
                            child: Text(
                              'Filter Your Result',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xff1f75fe),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
