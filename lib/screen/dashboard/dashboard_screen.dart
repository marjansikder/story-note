import 'package:date_calculator/screen/age_calculator/age_calculator_screen.dart';
import 'package:date_calculator/screen/calender/calendar_screen.dart';
import 'package:date_calculator/screen/notes/notes_list_screen.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/default_provider.dart';
import '../calender/holiday_calendar_screen.dart';
import 'home/bottom_navigation/bottom_navigation.dart';
import 'home/bottom_navigation/bottom_navigation_item.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const route = '/dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentIndex = 0;
  final _pageController = PageController();
  DateTime currentBackPressTime = DateTime.now();

  @override
  void initState() {
    pageSelectNotifier.addListener(() {
      if (!mounted) return;
      setState(() => _currentIndex = pageSelectNotifier.value);
      _goToSelectedPage(_currentIndex);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _goToSelectedPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) >
        const Duration(milliseconds: 1500)) {
      currentBackPressTime = now;
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const [
            NotesListScreen(),
            HolidayCalender(),
            //CalenderScreen(),
            AgeCalculatorScreen()
          ],
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _goToSelectedPage,
          items: _buildBottomNavigationItems(),
        ),
      ),
    );
  }

  List<BottomNavBarItem> _buildBottomNavigationItems() {
    return [
      BottomNavBarItem(
        label: NavigationLabel.notes,
        //icon: Icon(Icons.event_note_sharp, size: 26, color: AppColors.bottomNavBarIconColor),
        icon: Image.asset("assets/icons/note_list.png", width: 22 , color: AppColors.bottomNavBarIconColor),
      ),
      BottomNavBarItem(
        label: NavigationLabel.holidayCalender,
        //icon: Icon(Icons.calendar_month_outlined, size: 26, color: AppColors.bottomNavBarIconColor),
        icon: Image.asset("assets/icons/Holiday.png", width: 22, color: AppColors.bottomNavBarIconColor),
      ),
/*      BottomNavBarItem(
        label: NavigationLabel.calender,
        icon: const Icon(Icons.calendar_month_sharp,
            size: 22, color: Colors.white),
      ),*/
      BottomNavBarItem(
        label: NavigationLabel.age,
        //icon: Icon(Icons.calculate_outlined, size: 26, color: AppColors.bottomNavBarIconColor),
        icon: Image.asset("assets/icons/age_calculator.png", width: 22, color: AppColors.bottomNavBarIconColor),
      ),
    ];
  }
}

class DefaultProvider with ChangeNotifier {
  int _selectedIndex = 0;
  bool _isObscure = true;

  int get selectedIndex => _selectedIndex;

  bool get isObscure => _isObscure;

  void toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void setSelectedIndex(int newValue) {
    _selectedIndex = newValue;
    notifyListeners();
  }
}
