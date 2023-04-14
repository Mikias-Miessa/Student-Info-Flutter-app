import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_info/services/api.dart';
import 'login_screen.dart';
import '../services/local_storage_data.dart';
import '../components/navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final storage = FlutterSecureStorage();
final userinfo = LocalStorage(storage: storage);

class ReportCardScreen extends StatefulWidget {
  const ReportCardScreen({super.key});
  static String id = 'ReportCardScreen';
  @override
  State<ReportCardScreen> createState() => _ReportCardScreenState();
}

class _ReportCardScreenState extends State<ReportCardScreen> {
  // List<dynamic>? data;
  bool _saving = false;
  String? FName;
  String? FatherName;
  List Subject = [];
  List Result = [];
  List<dynamic> data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReportCard();
  }

  void getReportCard() async {
    setState(() {
      _saving = true;
    });
    var currentUser = await userinfo.readUserData();
    Uri url = Uri.parse(API.reportCard);
    try {
      http.Response response =
          await http.post(url, body: {'User': currentUser});
      if (response.statusCode == 200 || response.statusCode == 201) {
        data = jsonDecode(response.body);
        print(data);

        for (int j = 0; j < 3; j++) {
          String newSubject = data[0][j]['Subject'];
          String newResult = data[0][j]['Result'];
          Subject.add(newSubject);
          Result.add(newResult);
        }

        for (int i = 0; i < data.length; i++) {}
        setState(() {
          _saving = false;
        });
      }
      setState(() {
        var lodedData = data;

        FName = data[2][0]['F_Name'];
        FatherName = data[2][0]['Father_Name'];
      });
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
        title: Text('Report Card'),
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
            // Text('$data'.toString()),

            Container(
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
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Name',
                          style: TextStyle(
                              color: Color(0xffffa500),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$FName $FatherName',
                          style: TextStyle(
                              color: Color(0xff1f75fe),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
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
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Subject',
                      style: TextStyle(
                          color: Color(0xffffa500),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Text(
                      '1st Semister',
                      style: TextStyle(
                          color: Color(0xffffa500),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Text(
                      '2nd Semester',
                      style: TextStyle(
                          color: Color(0xffffa500),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: Subject.length,
                itemBuilder: (context, index) {
                  return Table(
                    border: TableBorder.all(color: Colors.blue, width: 3),
                    // columnWidths: {
                    //   0: FractionColumnWidth(0.33),
                    //   1: FractionColumnWidth(0.33),
                    //   2: FractionColumnWidth(0.33)
                    // },
                    children: [
                      buildrow(Subject[index], Result[index], 'cell3'),
                      // buildrow(['cell1', 'cell2', 'cell3'])
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  TableRow buildrow(
    String Subject,
    String Result1,
    String Result2,
  ) =>
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Text(
              Subject,
              style: style,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Text(
              Result1,
              style: style,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Text(
              Result2,
              style: style,
            ),
          )
        ],
      );
  final style = TextStyle(
      fontSize: 18, color: Color(0xff1f75fe), fontWeight: FontWeight.w600);
}

class Buildrow extends StatelessWidget {
  String? subject;
  String? result1;
  String? result2;
  Buildrow(
      {required this.subject, required this.result1, required this.result2});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Subject',
            style: TextStyle(
                color: Color(0xffffa500),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          Text(
            '1st Semister',
            style: TextStyle(
                color: Color(0xffffa500),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          Text(
            '2nd Semester',
            style: TextStyle(
                color: Color(0xffffa500),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
