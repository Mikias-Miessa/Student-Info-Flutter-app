import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student_info/services/api.dart';
import 'login_screen.dart';
import '../services/local_storage_data.dart';
import '../components/navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/card.dart';
import '../components/result_table_row.dart';

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
  String? fname;
  String? fatherName;
  String? academicYear;
  String totalFirst = '0';
  String averageFirst = '0';
  String rankFirst = '0';
  String totalSecond = '0';
  String averageSecond = '0';
  String rankSecond = '0';
  List subject1st = [];
  List result1st = [];

  // List Subject2nd = [];
  List result2nd = [];
  List<dynamic> data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReportCard();
    getCurrentUser();
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

        // for first semester
        int length1st = data[0].length;
        for (int j = 0; j < length1st; j++) {
          String newSubject = data[0][j]['Subject'];
          String newResult = data[0][j]['Result'];
          subject1st.add(newSubject);
          result1st.add(newResult);
        }

        // for second semester
        int length2nd = data[1].length;
        for (int j = 0; j < length2nd; j++) {
          // String newSubject = data[1][j]['Subject'];
          String newResult = data[1][j]['Result'];
          // Subject2nd.add(newSubject);
          result2nd.add(newResult);
        }
        setState(() {
          _saving = false;
          totalFirst = data[2][0]['Total'];
          averageFirst = data[2][0]['Average'];
          rankFirst = data[2][0]['Rank'];
          totalSecond = data[3][0]['Total'];
          averageSecond = data[3][0]['Average'];
          rankSecond = data[3][0]['Rank'];
        });
      }
    } catch (e) {
      setState(() {
        _saving = false;
      });
      print(e);
    }
  }

  void getCurrentUser() async {
    setState(() {
      _saving = true;
    });
    var user = await userinfo.readUserData();
    Uri url = Uri.parse(API.studentInfo);
    try {
      http.Response response = await http.post(url, body: {'user': user});
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          List<dynamic> data = jsonDecode(response.body);
          print(data);
          setState(() {
            _saving = false;
            fname = data[0]['F_Name'];
            fatherName = data[0]['Father_Name'];
            academicYear = data[0]['Regfor'];
          });
        } catch (e) {
          _saving = false;
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      // backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text('Report Card'),
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
        child: ListView(
          children: [
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          '$fname $fatherName',
                          style: TextStyle(
                              color: Color(0xff1f75fe),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Academic Year',
                          style: TextStyle(
                              color: Color(0xffffa500),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '$academicYear',
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
            ThreeInputCard(
                text1: 'Subject', text2: '1st Semester', text3: '2nd Semester'),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: subject1st.length,
                itemBuilder: (context, index) {
                  return Table(
                    border: TableBorder.all(color: Colors.blue, width: 3),
                    children: [
                      buildrow(
                          subject1st[index],
                          result1st[index],
                          result2nd.length >= result1st.length
                              ? result2nd[index]
                              : ""),
                    ],
                  );
                }),
            ResultTable(
              style: style,
              cell1: 'Total',
              cell2: '$totalFirst',
              cell3: '$totalSecond',
            ),
            ResultTable(
              style: style,
              cell1: 'Average',
              cell2: '$averageFirst',
              cell3: '$averageSecond',
            ),
            ResultTable(
              style: style,
              cell1: 'Rank',
              cell2: '$rankFirst',
              cell3: '$rankSecond',
            ),
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



// class Buildrow extends StatelessWidget {
//   String? subject;
//   String? result1;
//   String? result2;
//   Buildrow(
//       {required this.subject, required this.result1, required this.result2});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             'Subject',
//             style: TextStyle(
//                 color: Color(0xffffa500),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600),
//           ),
//           Text(
//             '1st Semister',
//             style: TextStyle(
//                 color: Color(0xffffa500),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600),
//           ),
//           Text(
//             '2nd Semester',
//             style: TextStyle(
//                 color: Color(0xffffa500),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }
