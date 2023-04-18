import 'package:student_info/screens/exam_result_screen.dart';

class API {
  static const hostConnect =
      'https://mikiasmiessa.000webhostapp.com/school_app_api';
  // static const hostConnect = 'http://192.168.1.14/school_app_api';
  static const studentInfo = '$hostConnect/studentInfo.php';
  static const login = '$hostConnect/login.php';
  static const examResult = '$hostConnect/examresult.php';
  static const reportCard = '$hostConnect/reportcard.php';
}
