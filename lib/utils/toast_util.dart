
import 'package:flutter/material.dart';
import 'package:story_notes/utils/colors.dart';
import 'package:toastification/toastification.dart';

class ToastMessage {
  ToastMessage._();

  static void show(String message) {
    toastification.show(
      title: Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static void error(String message) {
    toastification.show(
      title: Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static void infoShow(String message) {
    toastification.show(
      title: Text(message, selectionColor: AppColors.kCardColor),
      alignment: Alignment.bottomCenter,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  static void infoShowCustom(String message) {
    toastification.showCustom(
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.center,
      builder: (BuildContext context, ToastificationItem holder) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.kWarningToastBgColor,
              border: Border.all(color: AppColors.kWarningToastTextColor)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Center(child: Text(message, style: TextStyle(color: AppColors.kBrown, fontSize: 12))),
        );
      },
    );
  }
}
