import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/text_style.dart';
import 'package:date_calculator/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

/// Event class to represent an event
class Event {
  final String holidayBn;
  final String holidayEn;

  const Event(this.holidayBn, this.holidayEn);
}

// Example data
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);

// Sample events
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
)..addAll({
    DateTime(2025, 2, 15): [Event('শবে বরাত', 'Shab e-Barat')],
    DateTime(2025, 2, 21): [
      Event('আন্তর্জাতিক মাতৃভাষা দিবস', 'International Mother Language Day')
    ],
    DateTime(2025, 3, 26): [Event('স্বাধীনতা দিবস', 'Independence Day')],
    DateTime(2025, 3, 28): [Event('শবে কদর', 'Shab e-Qadr')],
    DateTime(2025, 3, 29): [Event('ঈদুল ফিতরের ছুটি', 'Eid ul-Fitr Holiday')],
    DateTime(2025, 3, 30): [Event('ঈদুল ফিতরের ছুটি', 'Eid ul-Fitr Holiday')],
    DateTime(2025, 3, 31): [Event('ঈদুল ফিতরের ছুটি', 'Eid ul-Fitr Holiday')],
    DateTime(2025, 4, 1): [Event('ঈদুল ফিতরের ছুটি', 'Eid ul-Fitr Holiday')],
    DateTime(2025, 4, 2): [Event('ঈদুল ফিতরের ছুটি', 'Eid ul-Fitr Holiday')],
    DateTime(2025, 4, 14): [Event('পহেলা বৈশাখ', 'Pahela Baishakh')],
    DateTime(2025, 5, 1): [Event('মে দিবস', 'May Day')],
    DateTime(2025, 5, 11): [Event('বুদ্ধ পূর্ণিমা', 'Buddha Purnima')],
    DateTime(2025, 6, 5): [Event('ঈদুল আযহার ছুটি', 'Eid al-Adha Holiday')],
    DateTime(2025, 6, 7): [Event('ঈদুল আযহার ছুটি', 'Eid al-Adha Holiday')],
    DateTime(2025, 6, 8): [Event('ঈদুল আযহার ছুটি', 'Eid al-Adha Holiday')],
    DateTime(2025, 6, 9): [Event('ঈদুল আযহার ছুটি', 'Eid al-Adha Holiday')],
    DateTime(2025, 6, 10): [Event('ঈদুল আযহার ছুটি', 'Eid al-Adha Holiday')],
    DateTime(2025, 7, 6): [Event('আশুরা', 'Ashura')],
    DateTime(2025, 8, 16): [Event('জন্মাষ্টমী', 'Janmashtami')],
    DateTime(2025, 9, 5): [Event('ঈদে মিলাদুন্নবী', 'Eid e-Milad-un Nabi')],
    DateTime(2025, 10, 1): [Event('দুর্গাপূজা', 'Durga Puja')],
    DateTime(2025, 10, 2): [Event('দুর্গাপূজা', 'Durga Puja')],
    DateTime(2025, 12, 16): [Event('বিজয় দিবস', 'Victory Day')],
    DateTime(2025, 12, 25): [Event('বড়দিন', 'Christmas Day')],
  });

/// Helper to get the range of days
List<DateTime> daysInRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  for (int i = 0; start.add(Duration(days: i)).isBefore(end); i++) {
    days.add(start.add(Duration(days: i)));
  }
  days.add(end);
  return days;
}

String formatDateTime(DateTime dateTime) {
  return DateFormat("dd/MM/yyyy").format(dateTime);
}

/// Main widget
class HolidayCalender extends StatefulWidget {
  const HolidayCalender({super.key});

  @override
  State<HolidayCalender> createState() => _HolidayCalenderState();
}

class _HolidayCalenderState extends State<HolidayCalender> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<bool> _showResetButtonNotifier =
      ValueNotifier<bool>(false);

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _showResetButtonNotifier.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _showResetButtonNotifier.value = true;
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(selectedDay);
  }

  void _resetToCurrentDay() {
    setState(() {
      _showResetButtonNotifier.value = false;
      _selectedDay = DateTime.now();
      _focusedDay = DateTime.now();
      _selectedEvents.value = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    String resultedDate =
        DateFormat("dd/MM/yyyy").format(_selectedDay ?? DateTime.now());
    final currentDate = DateTime.now();
    return Scaffold(
        //backgroundColor: AppColors.kWhiteColor,
        backgroundColor: AppColors.kBgColor.withOpacity(.3),
        appBar: CustomAppBarWithShadow(title: 'Holiday ${_focusedDay.year}'),
        body: Column(children: [
          const SizedBox(height: 4),
          TableCalendar<Event>(
            locale: 'en_US',
            headerStyle: HeaderStyle(
                headerMargin:
                    EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 8),
                headerPadding: EdgeInsets.only(left: 8, right: 8),
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle:
                    TextStyle(fontSize: 16, color: AppColors.kBrown),
                decoration: BoxDecoration(
                  color: AppColors.kWarningToastBgColor.withOpacity(.7),
                  borderRadius: BorderRadius.circular(5),
                )),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            pageAnimationCurve: Curves.easeInOutCubic,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            weekendDays: [DateTime.friday, DateTime.saturday],
            daysOfWeekHeight: 40,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.kBrown),
              weekendStyle: TextStyle(color: Colors.red),
            ),
            holidayPredicate: (day) {
              return day.weekday == DateTime.friday ||
                  day.weekday == DateTime.saturday;
            },
            calendarStyle: CalendarStyle(
                markerSize: 0,
                outsideDaysVisible: false,
                canMarkersOverflow: false,
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: AppColors.kPending.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                )),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty && day != _selectedDay) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      padding: day.day < 10
                          ? const EdgeInsets.all(16.0)
                          : const EdgeInsets.all(12.0),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return null;
              },
              selectedBuilder: (context, day, focusedDay) {
                return Center(
                  child: Container(
                    decoration: _selectedDay == day
                        ? BoxDecoration(
                            //color: AppColors.kPending.withOpacity(0.4),
                            border: Border.all(color: AppColors.kPending),
                            shape: BoxShape.circle,
                          )
                        : BoxDecoration(
                            color: AppColors.kPending,
                            shape: BoxShape.circle,
                          ),
                    padding: day.day < 10
                        ? const EdgeInsets.all(16.0)
                        : const EdgeInsets.all(12.0),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                          color: _selectedDay == day
                              ? AppColors.kPending
                              : AppColors.kWhiteColor),
                    ),
                  ),
                );
              },
              holidayBuilder: (context, day, focusedDay) {
                if (day.weekday == DateTime.friday ||
                    day.weekday == DateTime.saturday) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: day.day < 10
                          ? EdgeInsets.all(16.0)
                          : EdgeInsets.all(12.0),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return null; // Default rendering for other days
              },
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _showResetButtonNotifier.value = true;
              });
            },
          ),
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Container(
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.kWarningToastBgColor.withOpacity(.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/Holiday.png", height: 12, color: AppColors.kBrown.withOpacity(.6)),
                  const SizedBox(width: 5),
                  Text(resultedDate,
                      style: getCustomTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.kBrown)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.kWarningToastBgColor.withOpacity(.7),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value[index].holidayEn,
                                style: getTextStyle(
                                    16, FontWeight.normal, Colors.black)),
                            Text(value[index].holidayBn,
                                style: getTextStyle(
                                    14, FontWeight.normal, AppColors.kBrown)),
                            SizedBox(height: 6)
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12.0),
          ValueListenableBuilder<bool>(
            valueListenable: _showResetButtonNotifier,
            builder: (context, showResetButton, _) {
              return showResetButton
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: _resetToCurrentDay,
                            child: Container(
                              width: 70,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.kWarningToastBgColor,
                              ),
                              child: const Center(
                                child: Text(
                                  'Today',
                                  style: TextStyle(
                                      color: AppColors.kBrown, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink();
            },
          ),
        ]));
  }
}
