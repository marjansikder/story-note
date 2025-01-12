import 'package:date_calculator/utils/age_util.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:date_calculator/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AgeCalculatorScreen extends ConsumerStatefulWidget {
  const AgeCalculatorScreen({super.key});
  static const route = '/age-calculator';

  @override
  ConsumerState<AgeCalculatorScreen> createState() =>
      _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends ConsumerState<AgeCalculatorScreen> {
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();
  DateTime selectedFromDate = DateTime.now();
  String? daysDuration;
  String? monthsDuration;
  String? yearsDuration;

  AgeDuration? ageDuration;

  @override
  Widget build(BuildContext context) {
    String selectedFromDate =
        DateFormat("dd/MM/yyyy").format(_fromDate ?? DateTime.now());
    String selectedToDate =
        DateFormat("dd/MM/yyyy").format(_toDate ?? DateTime.now());

    return Scaffold(
      //backgroundColor: AppColors.kNewBackground.withOpacity(.1),
      backgroundColor: Color(0xFFFFFBED).withOpacity(.5),
      appBar: CustomAppBarWithShadow(title: 'Age Calculator'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Pick From Date', style: FontUtil.blackW500S12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            AppColors.kDatePickerButtonColor.withOpacity(.7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                      ),
                      icon: Image.asset("assets/icons/ic_pick_date.png",
                          width: 14, color: AppColors.kBrown.withOpacity(.6)),
                      label: Text(
                        selectedFromDate,
                        style:
                            TextStyle(color: AppColors.kBrown.withOpacity(.6)),
                      ),
                      onPressed: () => selectFromDate(context),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Pick To Date', style: FontUtil.blackW500S12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            AppColors.kDatePickerButtonColor.withOpacity(.7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                      ),
                      icon: Image.asset("assets/icons/ic_pick_date.png",
                          width: 14, color: AppColors.kBrown.withOpacity(.6)),
                      label: Text(
                        selectedToDate,
                        style:
                            TextStyle(color: AppColors.kBrown.withOpacity(.6)),
                      ),
                      onPressed: () => selectToDate(context),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            const Text('Calculated Result : ', style: FontUtil.blackW400S16),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 120,
                    width: double.infinity * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.kWarningToastBgColor.withOpacity(.7),
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(ageDuration?.years.toString() ?? '0',
                            style: FontUtil.greenW600S22),
                        subtitle: Text(
                          'Years',
                          style: FontUtil.grey800W400S16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    width: double.infinity * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.kWarningToastBgColor.withOpacity(.7),
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(ageDuration?.months.toString() ?? '0',
                            style: FontUtil.greenW600S22),
                        subtitle: Text(
                          'Months',
                          style: FontUtil.grey800W400S16,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    width: double.infinity * .15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.kWarningToastBgColor.withOpacity(.7),
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(ageDuration?.days.toString() ?? '0',
                            style: FontUtil.greenW600S22),
                        subtitle: Text(
                          'Days',
                          style: FontUtil.grey800W400S16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),

            ///Column button
            /*            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.appBarColor.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                icon: Icon(Icons.output, color: AppColors.kWhiteColor),
                label: Text('Calculate Duration', style: FontUtil.whiteW400S16),
                onPressed: () {
                  AgeDuration value = AgeUtil.dateDifference(
                      fromDate: _fromDate!, toDate: _toDate!);
                  setState(() {
                    ageDuration = value;
                  });
                  print('>>>>><<<<<$value');
                  print(AgeDuration);
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.kBlankMsgBackground,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                icon: Icon(Icons.restart_alt, color: AppColors.kNewText),
                label: Text('Reset all', style: FontUtil.blackW400S16),
                onPressed: () {
                  setState(() {
                    _fromDate = DateTime.now();
                    _toDate = DateTime.now();
                    ageDuration?.days = 0;
                    ageDuration?.months = 0;
                    ageDuration?.years = 0;
                  });
                },
              ),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .42,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                          AppColors.kWarningToastBgColor.withOpacity(.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: Image.asset("assets/icons/ic_refresh.png",
                        height: 14, color: AppColors.kBlackColor),
                    label: Text('Reset all', style: FontUtil.blackW400S15),
                    onPressed: () {
                      setState(() {
                        _fromDate = DateTime.now();
                        _toDate = DateTime.now();
                        ageDuration?.days = 0;
                        ageDuration?.months = 0;
                        ageDuration?.years = 0;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .42,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                          AppColors.kDatePickerButtonColor.withOpacity(.7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    icon: Icon(Icons.output, color: AppColors.kBrown, size: 18),
                    label: Text('Calculate',
                        style: TextStyle(
                            color: AppColors.kBrown,
                            fontWeight: FontWeight.w400,
                            fontSize: 15)),
                    onPressed: () {
                      AgeDuration value = AgeUtil.dateDifference(
                          fromDate: _fromDate!, toDate: _toDate!);
                      setState(() {
                        ageDuration = value;
                      });
                      print('>>>>><<<<<$value');
                      print(AgeDuration);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      keyboardType: TextInputType.text,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920, 1),
      lastDate: DateTime(2101),
      cancelText: 'Close',
      confirmText: 'Select',
      fieldHintText: 'Month/Day/Year',
      fieldLabelText: 'BirthDate',
      errorInvalidText: 'Please enter a valid date',
      errorFormatText: 'Correct format is Month/Day/Year',
    );
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      keyboardType: TextInputType.text,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      cancelText: 'Close',
      confirmText: 'Select',
      fieldHintText: 'Month/Day/Year',
      fieldLabelText: 'Date',
      errorInvalidText: 'Please enter a valid date',
      errorFormatText: 'Correct format is Month/Day/Year',
    );
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }
}
