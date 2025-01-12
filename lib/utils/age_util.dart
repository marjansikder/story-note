/*
 * https://github.com/JErazo7/age_calculator
 */

import 'dart:math';

class AgeDuration {
  int days;
  int months;
  int years;

  AgeDuration({
    this.days = 0,
    this.months = 0,
    this.years = 0,
  });

  @override
  String toString() {
    var age =
        '${years > 0 ? '${years}y' : ''}${months > 0 ? ' ${months}m' : ''}${days > 0 ? ' ${days}d' : ''}'
            .trim();
    return age.isNotEmpty ? age : 'N/A';
  }
}

/// Age Class
class AgeUtil {
  /// _daysInMonth cost contains days per months; daysInMonth method to be used instead.
  static const List<int> _daysInMonth = [
    31, // Jan
    28, // Feb, it varies from 28 to 29
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31 // Dec
  ];

  /// isLeapYear method
  static bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// daysInMonth method
  static int daysInMonth(int year, int month) =>
      (month == DateTime.february && isLeapYear(year))
          ? 29
          : _daysInMonth[month - 1];

  /// dateDifference method
  static AgeDuration dateDifference({
    required DateTime fromDate,
    required DateTime toDate,
    bool includeToDate = false,
  }) {
    // Check if toDate to be included in the calculation
    DateTime endDate =
        (includeToDate) ? toDate.add(const Duration(days: 1)) : toDate;

    int years = endDate.year - fromDate.year;
    int months = 0;
    int days = 0;

    if (fromDate.month > endDate.month) {
      years--;
      months = (DateTime.monthsPerYear + endDate.month - fromDate.month);

      if (fromDate.day > endDate.day) {
        months--;
        days = daysInMonth(fromDate.year + years,
                ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else if (endDate.month == fromDate.month) {
      if (fromDate.day > endDate.day) {
        years--;
        months = DateTime.monthsPerYear - 1;
        days = daysInMonth(fromDate.year + years,
                ((fromDate.month + months - 1) % DateTime.monthsPerYear) + 1) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    } else {
      months = (endDate.month - fromDate.month);

      if (fromDate.day > endDate.day) {
        months--;
        days = daysInMonth(fromDate.year + years, (fromDate.month + months)) +
            endDate.day -
            fromDate.day;
      } else {
        days = endDate.day - fromDate.day;
      }
    }

    return AgeDuration(days: days, months: months, years: years);
  }

  /// add method
  static DateTime add({
    required DateTime date,
    required AgeDuration duration,
  }) {
    var newDateTime = date.add(Duration(days: duration.days));
    newDateTime = _addMonths(newDateTime, duration.months);
    newDateTime = _addMonths(newDateTime, duration.years * 12);
    return newDateTime;
  }

  /// subtract methods
  static DateTime subtract({
    required DateTime date,
    required AgeDuration duration,
  }) {
    var newDateTime = date.subtract(Duration(days: duration.days));
    newDateTime = _addMonths(newDateTime, -duration.months);
    newDateTime = _addMonths(newDateTime, -duration.years * 12);
    return newDateTime;
  }

  static DateTime _addMonths(DateTime dateTime, int months) {
    final modMonths = months % 12;
    var newYear = dateTime.year + ((months - modMonths) ~/ 12);
    var newMonth = dateTime.month + modMonths;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = min(dateTime.day, daysInMonth(newYear, newMonth));
    return dateTime.copyWith(year: newYear, month: newMonth, day: newDay);
  }
}
