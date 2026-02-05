import 'package:intl/intl.dart';
class DateModel {
  String getFormattedDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, d MMMM').format(now);
  }

  // DAynamic lis for  week days
  List<DateTime> getWeekDays() {
    DateTime now = DateTime.now();
    //   Creating list 3 days Befor and After the slecte days
    return List.generate(7, (index) => now.subtract(Duration(days: 3 - index)));
  }

  String getMonthName(DateTime date) {
    return DateFormat('MMM').format(date);
  }
}