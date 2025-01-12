import 'package:date_calculator/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

String mi_sans_font = 'MiSans';
String arial_font = 'arial';

TextStyle getTextStyle1(double sized, FontWeight? weight, Color? color) {
  return GoogleFonts.hindSiliguri(
    fontSize: sized,
    fontWeight: weight ?? FontWeight.normal,
    color: color ?? Colors.black,
  );
}

TextStyle getTextStyleBarlow(double sized, FontWeight? weight, Color? color) {
  return GoogleFonts.barlow(
    fontSize: sized,
    fontWeight: weight ?? FontWeight.normal,
    color: color ?? Colors.black,
  );
}

TextStyle getTextStyleNotoSans(double sized, FontWeight? weight, Color? color) {
  return GoogleFonts.firaSans(
    fontSize: sized,
    fontWeight: weight ?? FontWeight.normal,
    color: color ?? Colors.black,
  );
}

TextStyle getTextStyle2(double sized, FontWeight? weight, Color? color) {
  return GoogleFonts.notoSans(
    fontSize: sized,
    fontWeight: weight ?? FontWeight.normal,
    color: color ?? Colors.black,
  );
}

TextStyle getTextStyleTab(double sized, FontWeight? weight) {
  return GoogleFonts.notoSans(
    fontSize: sized,
    fontWeight: weight ?? FontWeight.normal,
  );
}

TextStyle getTextStyle(double sized, FontWeight? weight, Color? color) {
  return TextStyle(
    fontSize: sized,
    fontWeight: weight ?? FontWeight.normal,
    color: color ?? Colors.black,
    height: 1.5,
    fontFamily: mi_sans_font
  );
}

TextStyle getCustomTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  double height = 1.5,
  String fontFamily = 'MiSans',
  FontStyle fontStyle = FontStyle.normal,
  TextDecoration decoration = TextDecoration.none,
  double? letterSpacing,
  double? wordSpacing,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    fontFamily: fontFamily.isNotEmpty ? fontFamily : mi_sans_font,
    fontStyle: fontStyle,
    decoration: decoration,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
  );
}

BoxDecoration getBoxDecorations(Color color, double radius) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ),
  );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

class Dimen {
  Dimen._();

  static const double dateTextSize = 24;
  static const double dayTextSize = 11;
  static const double monthTextSize = 11;
}

void showCustomDialogBox(BuildContext context, String title, String errors,
    String? leftButtonText, String? rightButtonText,
    {required VoidCallback onConfirm, required VoidCallback onCancel}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext cxt) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Material(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: getTextStyle2(
                        20, FontWeight.bold, AppColors.tabSelectedColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    errors,
                    style: getTextStyle2(14, FontWeight.normal, Colors.black),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onCancel,
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.kConfirm,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              height: 50,
                              child: Center(
                                  child: Text(
                                leftButtonText ?? 'Back',
                                style: getTextStyle2(
                                    14, FontWeight.bold, Colors.white),
                              ))),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: onConfirm,
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.kRedAlert,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              height: 50,
                              child: Center(
                                  child: Text(
                                rightButtonText ?? 'Okay',
                                style: getTextStyle2(
                                    14, FontWeight.bold, Colors.white),
                              ))),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
