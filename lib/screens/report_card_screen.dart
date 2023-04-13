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
  List<dynamic>? data;
  bool _saving = false;
  String? Name;
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
        setState(() {
          _saving = false;
        });
      }
      setState(() {
        var lodedData = data;

        Name = data![2][0]['F_Name'];
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
              height: 60,
              child: Center(
                child: Text('$Name'),
              ),
              decoration: BoxDecoration(color: Colors.blue.shade400),
            ),

            Table(
              border: TableBorder.all(color: Colors.blue, width: 3),
              columnWidths: {
                0: FractionColumnWidth(0.5),
                1: FractionColumnWidth(0.25),
                2: FractionColumnWidth(0.25)
              },
              children: [
                buildrow(['cell1', 'cell2', 'cell3'], isHeader: true),
                buildrow(['cell1', 'cell2', 'cell3']),
                buildrow(['cell1', 'cell2', 'cell3'])
              ],
            )
          ],
        ),
      ),
    );
  }

  TableRow buildrow(List<String> cells, {bool isHeader = false}) => TableRow(
          children: cells.map((cell) {
        final style = TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 18);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            cell,
            style: style,
          )),
        );
      }).toList());
}
