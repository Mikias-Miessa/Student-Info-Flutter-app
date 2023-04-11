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
    http.Response response = await http.post(url, body: {'User': currentUser});
    if (response.statusCode == 200 || response.statusCode == 201) {
      data = jsonDecode(response.body);
      setState(() {
        _saving = false;
      });
    }
    setState(() {
      var lodedData = data;
    });
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
            Text('$data'.toString()),
          ],
        ),
      ),
    );
  }
}
