import 'package:flutter/foundation.dart';

class ValueChangeNotifier<T> extends ChangeNotifier {
  ValueChangeNotifier(this._value);

  T get value => _value;
  T _value;
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
