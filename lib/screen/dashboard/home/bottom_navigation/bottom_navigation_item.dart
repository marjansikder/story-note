import 'package:flutter/widgets.dart';

class BottomNavBarItem {
  final NavigationLabel label;
  final Widget icon;
  final bool? onlineConsultationEnabled;

  BottomNavBarItem({
    required this.label,
    required this.icon,
    this.onlineConsultationEnabled,
  });
}

enum NavigationLabel {
  notes('Notes'),
  holidayCalender('Holiday'),
  calender('Calender'),
  age('Age'),
  map('Map'),
  profile('Profile');

  final String _item;

  const NavigationLabel(this._item);

  String get name => _item;
}
