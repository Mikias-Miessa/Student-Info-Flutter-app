import 'package:flutter/material.dart';
import 'package:student_info/screens/exam_result_screen.dart';
// import '../components/navigation_drawer.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import '../services/api.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/local_storage_data.dart';
import '../components/navigation.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shimmer/shimmer.dart';

final storage = FlutterSecureStorage();
final userinfo = LocalStorage(storage: storage);

class DashboardScreen extends StatefulWidget {
  static String id = 'DashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? firstName;
  String? fatherName;
  String? gFatherName;
  String? grade;
  String? section;
  String? age;
  String? status;
  bool _saving = false;
  @override
  void initState() {
    super.initState();

    getStudentInfo();
  }

  void getStudentInfo() async {
    setState(() {
      _saving = true;
    });
    var currentUser = await userinfo.readUserData();
    http.Response response =
        await http.post(Uri.parse(API.studentInfo), body: {'user': currentUser}
            // headers: {'Content-Type': 'application/json'},
            );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _saving = false;
      });
      try {
        List<dynamic> data = jsonDecode(response.body);
        print(data);
        setState(() {
          firstName = data[0]['F_Name'];
          fatherName = data[0]['Father_Name'];
          gFatherName = data[0]['Gfather_Name'];
          grade = data[0]['Grade'];
          section = data[0]['Section'];
          age = data[0]['Age'];
          status = data[0]['Status'];
          if (status == '') {
            status = 'Active';
          } else {
            status = 'Terminated';
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawer(),
      // backgroundColor: Colors.orange,
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Your Dashboard'),
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
      body: Column(
        children: [
          Flexible(
            child: Container(
              // color: Colors.orange,
              height: 200,
              child: Image.asset('images/Welcome.png'),
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
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          // top: 50,
                          right: 40,
                          left: 40,
                        ),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                  bottomLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(7)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.grey,
                                  // spreadRadius: 3,
                                  offset: Offset(2, 2),
                                )
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 30,
                                ),
                                child: Icon(
                                  Icons.account_circle_outlined,
                                  color: Color(0xffffa500),
                                  size: 30,
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Student Name',
                                    style: TextStyle(
                                        color: Color(0xffffa500),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (_saving)
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set your desired border radius here
                                        child: Container(
                                          width: 150,
                                          height: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      '$firstName $fatherName $gFatherName',
                                      style: TextStyle(
                                          color: Color(0xff1f75fe),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          // top: 50,
                          right: 40,
                          left: 40,
                        ),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7),
                                  bottomLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(7)),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  blurStyle: BlurStyle.outer,
                                  color: Colors.grey,
                                  // spreadRadius: 3,
                                  offset: Offset(2, 2),
                                )
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 30,
                                ),
                                child: Icon(
                                  Icons.class_outlined,
                                  color: Color(0xffffa500),
                                  size: 30,
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grade & Section',
                                    style: TextStyle(
                                        color: Color(0xffffa500),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  if (_saving)
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set your desired border radius here
                                        child: Container(
                                          width: 150,
                                          height: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      '$grade $section',
                                      style: TextStyle(
                                          color: Color(0xff1f75fe),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 48,
                            width: 146,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                    bottomRight: Radius.circular(7)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    blurStyle: BlurStyle.outer,
                                    color: Colors.grey,
                                    // spreadRadius: 3,
                                    offset: Offset(2, 2),
                                  )
                                ]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 30,
                                  ),
                                  child: Icon(
                                    Icons.edit_calendar_outlined,
                                    color: Color(0xffffa500),
                                    size: 30,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Age',
                                      style: TextStyle(
                                          color: Color(0xffffa500),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    if (_saving)
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set your desired border radius here
                                          child: Container(
                                            width: 30,
                                            height: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else
                                      Text(
                                        '$age',
                                        style: TextStyle(
                                            color: Color(0xff1f75fe),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 146,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                    bottomRight: Radius.circular(7)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    blurStyle: BlurStyle.outer,
                                    color: Colors.grey,
                                    // spreadRadius: 3,
                                    offset: Offset(2, 2),
                                  )
                                ]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: Color(0xffffa500),
                                    size: 30,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                          color: Color(0xffffa500),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    if (_saving)
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set your desired border radius here
                                          child: Container(
                                            width: 30,
                                            height: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    else
                                      Text(
                                        '$status',
                                        style: TextStyle(
                                            color: Color(0xff1f75fe),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Text(
                          'Made by Visionaries ICT Solutions PLC',
                          style: TextStyle(
                            color: Color(0xff1f75fe),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
