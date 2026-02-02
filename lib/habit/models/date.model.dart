import 'package:intl/intl.dart';

class DateModel {
  String getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);
    return formattedDate;
  }
}
