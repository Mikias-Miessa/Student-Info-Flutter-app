import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:student_info/screens/dashboard_screen.dart';
import '../constants.dart';
import '../components/round_button.dart';
import 'package:http/http.dart' as http;
import '../services/api.dart';
import '../services/local_storage_data.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final storage = FlutterSecureStorage();
final userinfo = LocalStorage(storage: storage);

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorMessage = '';
  String? username;
  String? password;
  bool _saving = false;
  void authenticate() async {
    // print(username);
    var url = Uri.parse(API.login);
    try {
      http.Response response = await http
          .post(url, body: {'username': '$username', 'password': '$password'});
      if (response.statusCode == 200 || response.statusCode == 201) {
        String data = jsonDecode(response.body);
        print(data);
        if (data == 'Success') {
          setState(() {
            _saving = false;
            errorMessage = '';
          });
          username = '';
          password = '';
          Navigator.popAndPushNamed(context, DashboardScreen.id);
        } else {
          setState(() {
            _saving = false;
            errorMessage = 'Check your username and password';
          });
          username = '';
          password = '';
        }
      } else {
        setState(() {
          _saving = false;
          errorMessage = 'Something went wrong please try again';
        });
        username = '';
        password = '';
      }
    } catch (e) {
      setState(() {
        _saving = false;
        errorMessage = 'Check your Connection and try restarting the app';
      });
      username = '';
      password = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
          child: ListView(children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Color(0xff1f75fe),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Image.asset('images/Login.png'),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffffa500), Color(0xffffffff)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, left: 40, right: 10, top: 40),
              child: Text(
                'Login',
                style: TextStyle(
                    color: Color(0xff1f75fe),
                    fontSize: 40,
                    fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                onChanged: (value) {
                  username = value;
                },
                decoration:
                    KInputDecoration.copyWith(hintText: 'Enter Your Username'),
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    KInputDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              color: Color(0xff1f75fe),
              buttonText: 'Login',
              onPressed: () {
                setState(() {
                  _saving = true;
                });
                userinfo.writeUserData('$username');
                authenticate();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                      decoration: BoxDecoration(
                          color: errorMessage != ''
                              ? Colors.red[100]
                              : Colors.white),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
