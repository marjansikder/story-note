import 'package:date_calculator/utils/age_util.dart';
import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:date_calculator/utils/text_style.dart';
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

  Widget _buildResultBox(String value, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.kWarningToastBgColor.withOpacity(.7),
            borderRadius: BorderRadius.circular(5),
          ),
          width: MediaQuery.of(context).size.width * .26,
          height: MediaQuery.of(context).size.height * .1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Center(
              child: Text(
                value,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.brown,
          ),
        ),
      ],
    );
  }

  Widget _buildDateColumn(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required String date,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.kWarningToastBgColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/ic_pick_date.png",
              scale: 16,
              color: AppColors.kBrown.withOpacity(.4),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: getCustomTextStyle(fontSize: 12, color: AppColors.kTextGreyColor),
                ),
                Text(
                  date,
                  style: getCustomTextStyle(
                    color: AppColors.kBrown.withOpacity(.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedFromDate =
        DateFormat("dd/MM/yyyy").format(_fromDate ?? DateTime.now());
    String selectedToDate =
        DateFormat("dd/MM/yyyy").format(_toDate ?? DateTime.now());
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFFFFBED).withOpacity(.5),
      appBar: CustomAppBarWithShadow(title: 'Age Calculator'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateColumn(
                      onPressed: () => selectFromDate(context),
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Pick from date',
                      date: selectedFromDate,
                    ),
                    _buildDateColumn(
                      onPressed: () => selectToDate(context),
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Pick to date',
                      date: selectedToDate,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .05,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.kWarningToastBgColor.withOpacity(.7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/ic_result.png",
                                height: 15,
                                color: AppColors.kBrown.withOpacity(.6)),
                            const SizedBox(width: 5),
                            Text('Calculated Result : ',
                                style: getCustomTextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: AppColors.kBrown)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 4),
                        _buildResultBox(
                            ageDuration?.years.toString() ?? '0', 'Years'),
                        _buildResultBox(
                            ageDuration?.months.toString() ?? '0', 'Months'),
                        _buildResultBox(
                            ageDuration?.days.toString() ?? '0', 'Days'),
                        SizedBox(width: 4),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
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
            ),
            SizedBox(
              height: 30,
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
