import 'package:flutter/material.dart';
import 'package:student_info/screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/exam_result_screen.dart';
import 'screens/report_card_screen.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        DashboardScreen.id: (context) => DashboardScreen(),
        ExamResult.id: (context) => ExamResult(),
        ReportCardScreen.id: (context) => ReportCardScreen(),
      },
    );
  }
}
