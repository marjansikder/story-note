import 'package:date_calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart';

enum ToastType {
  NORMAL,
  SUCCESS,
  ERROR,
  WARNING,
}

class Toast {
  final fToast = FToast();

  static final Toast _instance = Toast._internal();

  factory Toast() => _instance;

  Toast._internal() {
    fToast.init(navigatorKey.currentContext!);
  }

  static showToast(String message) {
    Toast()._showToast(message);
  }

  static showSuccessToast(String message) {
    Toast()._showSuccessToast(message);
  }

  static showWaringToast(String message) {
    Toast()._showWaringToast(message);
  }

  static showErrorToast(String message) {
    Toast()._showErrorToast(message);
  }

  void _showToast(String message) {
    fToast.showToast(
      child: _makeToast(message, ToastType.NORMAL),
      gravity: ToastGravity.CENTER,
    );
  }

  void _showSuccessToast(String message) {
    fToast.showToast(
        child: _makeToast(message, ToastType.SUCCESS),
        gravity: ToastGravity.CENTER,
        toastDuration: Duration(milliseconds: 800));
  }

  void _showWaringToast(String message) {
    fToast.showToast(
      child: _makeToast(message, ToastType.WARNING),
      gravity: ToastGravity.CENTER,
    );
  }

  void _showErrorToast(String message) {
    fToast.showToast(
        child: _makeToast(message, ToastType.ERROR),
        gravity: ToastGravity.CENTER,
        toastDuration: Duration(milliseconds: 1000));
  }
}

Widget _makeToast(String message, ToastType type) {
  return _buildToast(message, type, 14);
}

Widget _buildToast(String message, ToastType type, double fontSize) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: _getBackgroundColor(type),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            message,
            style: TextStyle(
                color: _getTextColor(type),
                fontSize: fontSize,
                fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ),
  );
}

Color _getTextColor(ToastType type) {
  switch (type) {
    case ToastType.NORMAL:
      return AppColors.kNormalToastTextColor;
    case ToastType.SUCCESS:
      return AppColors.kNormalToastTextColor;
    case ToastType.ERROR:
      return AppColors.kNormalToastTextColor;
    case ToastType.WARNING:
      return AppColors.kWarningToastTextColor;
  }
}

Color _getBackgroundColor(ToastType type) {
  switch (type) {
    case ToastType.NORMAL:
      return AppColors.kNormalToastBgColor.withOpacity(.9);
    case ToastType.SUCCESS:
      return AppColors.kGreenAlert.withOpacity(.9);
    case ToastType.ERROR:
      return AppColors.kRedAlert.withOpacity(.9);
    case ToastType.WARNING:
      return AppColors.kWarningToastBgColor;
  }
}
