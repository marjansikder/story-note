import 'package:date_calculator/utils/value_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final tabControllerProvider = StateProvider.autoDispose((ref) => 0);

ValueChangeNotifier<int> pageSelectNotifier = ValueChangeNotifier(0);
