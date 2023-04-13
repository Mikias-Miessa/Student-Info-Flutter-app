import 'dart:convert';

import 'package:http/http.dart';
import 'package:student_info/screens/report_card_screen.dart';

import '../screens/exam_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/local_storage_data.dart';
import '../services/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final storage = FlutterSecureStorage();
final userinfo = LocalStorage(storage: storage);

class NavDrawer extends StatefulWidget {
  const NavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String? currentUser;
  String? user;

  String? firstName;
  String? fatherName;
  late String formattedDate;
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    formattedDate = DateFormat('kk:mm \n EEE d MMM').format(DateTime.now());
  }

  void getCurrentUser() async {
    user = await userinfo.readUserData();
    Uri url = Uri.parse(API.studentInfo);
    try {
      http.Response response = await http.post(url, body: {'user': user});
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          List<dynamic> data = jsonDecode(response.body);
          print(data);
          setState(() {
            firstName = data[0]['F_Name'];
            fatherName = data[0]['Father_Name'];
          });
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(color: Colors.orange.shade400),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 25.0,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20),
                child: Text(
                  'Logged in as : $firstName $fatherName',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              )
            ]),
          ),
          ExpansionTile(
            title: Text(
              'Academy',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff1f75fe),
              ),
            ),
            leading: Icon(
              Icons.school_rounded,
              color: Color(0xff1f75fe),
            ),
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  'Exam Result',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1f75fe),
                  ),
                ),
                leading: const Icon(
                  Icons.fact_check_outlined,
                  color: Color(0xff1f75fe),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, ExamResult.id);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  'Report Card',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1f75fe),
                  ),
                ),
                leading: const Icon(
                  Icons.fact_check_sharp,
                  color: Color(0xff1f75fe),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, ReportCardScreen.id);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  'Open Day Rsult',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1f75fe),
                  ),
                ),
                leading: const Icon(
                  Icons.checklist,
                  color: Color(0xff1f75fe),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ExamResult.id);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Discipline',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff1f75fe),
              ),
            ),
            leading: Icon(
              Icons.rule_folder_rounded,
              color: Color(0xff1f75fe),
            ),
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  'Attendance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1f75fe),
                  ),
                ),
                leading: const Icon(
                  Icons.assignment_turned_in,
                  color: Color(0xff1f75fe),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ExamResult.id);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  'Conduct',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1f75fe),
                  ),
                ),
                leading: const Icon(
                  Icons.assignment_ind,
                  color: Color(0xff1f75fe),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ExamResult.id);
                },
              ),
            ],
          ),
          ListTile(
            title: Text(
              'Message',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff1f75fe),
              ),
            ),
            leading: const Icon(
              Icons.chat,
              color: Color(0xff1f75fe),
            ),
            onTap: () {
              Navigator.pushNamed(context, ExamResult.id);
            },
          ),
        ],
      ),
    );
  }
}
