import 'package:date_calculator/utils/colors.dart';
import 'package:date_calculator/utils/font_util.dart';
import 'package:date_calculator/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'date_calculator.dart';

class CalenderScreen extends ConsumerStatefulWidget {
  const CalenderScreen({super.key});

  static const route = '/calender';

  @override
  ConsumerState<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends ConsumerState<CalenderScreen> {
  TextEditingController daysController = TextEditingController();
  TextEditingController monthsController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  DateTime? jumpDateValue;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime? _pickedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != _pickedDate) {
      setState(() {
        _pickedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();
    String date = DateFormat("dd/MM/yyyy hh:mm:ss").format(currentDate);
    String resultedDate = DateFormat("dd/MM/yyyy hh:mm").format(jumpDateValue ?? DateTime.now());
    String selectedDateFromPicker = DateFormat("dd/MM/yyyy").format(_pickedDate ?? DateTime.now());
    return Scaffold(
      backgroundColor: Color(0xFFFFFBED).withOpacity(.5),
      appBar: CustomAppBarWithShadow(title: 'Calendar'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.kBlankMsgBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Icon(Icons.calendar_month_sharp,
                      color: AppColors.kNewText),
                  label: Text(
                      _pickedDate == null
                          ? 'Pick date'
                          : selectedDateFromPicker,
                      style: FontUtil.blackW400S16),
                  onPressed: () {
                    _pickDate(context);
                  },
                ),
              ),
            ),
            TableCalendar(
              firstDay: DateTime.utc(1920, 10, 16),
              lastDay: DateTime.utc(3000, 3, 14),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              focusedDay: jumpDateValue ?? DateTime.now(),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(jumpDateValue, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  jumpDateValue = selectedDay;
                  _pickedDate = focusedDay; // update `_focusedDay` here as well
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  //_pickedDate = focusedDay;
                  jumpDateValue = focusedDay;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                height: 25,
                width: double.infinity * .5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.kWarningToastBgColor,
                ),
                child: Center(
                    child: Text('Resulted Date : $resultedDate',
                        style: FontUtil.primaryBold14)),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.kNewText,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Icon(Icons.add_box_rounded,
                      color: AppColors.kWhiteColor),
                  label: const Text('Input Duration',
                      style: FontUtil.whiteW400S16),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        builder: (_) => FractionallySizedBox(
                            heightFactor: 0.65,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    /*  Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: AllColors.kBlankMsgBackground, borderRadius: BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                        child: Center(
                                          child: Text('Enter Day, Month, Year Range', style: FontUtil.blackW400S16),
                                        ),
                                      ),
                                    ),*/
                                    const SizedBox(height: 10),
                                    Container(
                                      width: double.infinity * .3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.kBlankMsgBackground,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            NumberInputField('◾ Total Days',
                                                daysController, 4, '0'),
                                            NumberInputField('◾ Total Months',
                                                monthsController, 4, '0'),
                                            NumberInputField('◾ Total Year',
                                                yearController, 2, '0'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                AppColors.kBlankMsgBackground,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                          ),
                                          icon: const Icon(Icons.restart_alt,
                                              color: AppColors.kNewText),
                                          label: const Text(
                                            '    Reset all       ',
                                            style: TextStyle(
                                                color: AppColors.kPrimaryColor),
                                          ),
                                          onPressed: () {
                                            daysController.clear();
                                            monthsController.clear();
                                            yearController.clear();
                                            setState(() {
                                              jumpDateValue = DateTime.now();
                                              _pickedDate = null;
                                            });
                                          },
                                        ),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                AppColors.kSkyButtonButton,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_circle_right_outlined,
                                            color: AppColors.kWhiteColor,
                                            size: 20,
                                          ),
                                          label: const Text('Jump to Calender',
                                              style: FontUtil.whiteW400S16),
                                          onPressed: () {
                                            DateTime value =
                                                DateCalculatorUtils.add(
                                                    date: _pickedDate ??
                                                        DateTime.now(),
                                                    count: DateCalculator(
                                                        days:
                                                            int.tryParse(
                                                                daysController
                                                                    .text),
                                                        months: int.tryParse(
                                                            monthsController
                                                                .text),
                                                        years: int.tryParse(
                                                            yearController
                                                                .text)));
                                            setState(
                                                () => jumpDateValue = value);
                                            print('>>>>><<<<<$jumpDateValue');
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ))));
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.kBlankMsgBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon:
                      const Icon(Icons.restart_alt, color: AppColors.kNewText),
                  label: const Text('Reset all', style: FontUtil.blackW400S16),
                  onPressed: () {
                    setState(() {
                      _pickedDate = null;
                      jumpDateValue = DateTime.now();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberInputField extends StatelessWidget {
  String label;
  int? maxLength;
  String? hinText;
  TextEditingController? inputController;

  NumberInputField(
      this.label, this.inputController, this.maxLength, this.hinText,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                child: Text(label, style: FontUtil.blackW400S16),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 60,
              height: 40,
              child: TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                maxLength: maxLength,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: hinText,
                  hintStyle: const TextStyle(
                      color: AppColors.kIconGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(
                      top: 0, bottom: 8, right: 8, left: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConvertButton extends StatefulWidget {
  final int? day;
  final int? month;
  final int? year;

  const ConvertButton({
    super.key,
    this.day,
    this.month,
    this.year,
  });

  @override
  State<ConvertButton> createState() => _ConvertButtonState();
}

class _ConvertButtonState extends State<ConvertButton> {
  var dateValue = DateTime(2007);
  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();

    return ElevatedButton(
      onPressed: () {
        DateTime value = DateCalculatorUtils.add(
            date: currentDate,
            count: DateCalculator(
                days: widget.day, months: widget.month, years: widget.year));
        print('Convert button pressed');
        setState(() {
          dateValue = value;
        });
        print('Output............ $dateValue');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Button text color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Rounded corners
        ),
        elevation: 1, // Shadow elevation
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text('Convert'),
      ),
    );
  }
}
