import 'dart:math';

import 'package:intl/intl.dart';

class DateCalculator {
  int? days;
  int? months;
  int? years;

  DateCalculator({this.days, this.months, this.years});

  @override
  String toString() {
    var newDate = 'Day $days Month $months Year $years';
    print('Input Day/Month/Year : $newDate');
    return newDate;
  }
}

class DateCalculatorUtils {
  static bool isLeapYear(int year) {
    if (year % 4 == 0 || year % 100 == 0 && year % 400 == 0) {
      return true;
    } else {
      return false;
    }
  }

  static int daysInMonth(int year, int month) {
    List<int> daysOfTheMonth = [
      31,
      isLeapYear(year) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysOfTheMonth[month - 1];
  }

  static _addMonths(DateTime dateTime, int months) {
    final modMonths = months % 12;
    final addedYear = ((months - modMonths) ~/ 12);
    //final addedYear = (modMonths ~/ 12);
    var newYear = dateTime.year + addedYear;
    var newMonth = dateTime.month + modMonths;
    if (newMonth > 12) {
      newYear++;
      newMonth = newMonth - 12;
    }
    final newDay = min(dateTime.day, daysInMonth(newYear, newMonth));
    return dateTime.copyWith(year: newYear, month: newMonth, day: newDay);
  }

  /// add method
  static DateTime add({
    required DateTime date,
    required DateCalculator count,
  }) {
    var newDateTime = date.add(Duration(days: count.days ?? 0));
    newDateTime = _addMonths(newDateTime, count.months ?? 0);
    newDateTime = _addMonths(newDateTime, (count.years ?? 0) * 12);

    String addedDate = DateFormat("dd/MM/yyyy hh:mm:ss").format(newDateTime);
    print('Date..... : $addedDate');
    return newDateTime;
  }
}
