import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime today = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  void _rangeSelectedDate(
      DateTime? startRange, DateTime? endRange, DateTime? focus) {
    setState(() {
      focus = null;
      startDate = startRange;
      endDate = endRange;
    });
  }

  void _selectedDate(DateTime? day, DateTime? focus) {
    setState(() {
      today = day!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return content();
  }

  Widget content() {
    return Column(
      children: [
        TableCalendar(
          locale: 'en_US',
          rowHeight: 43,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: today,
          onDaySelected: _selectedDate,
          onRangeSelected: _rangeSelectedDate,
          selectedDayPredicate: (day) => isSameDay(day, today),
          rangeStartDay: startDate,
          rangeEndDay: endDate,
          rangeSelectionMode: RangeSelectionMode.toggledOn,
        ),
      ],
    );
  }
}
