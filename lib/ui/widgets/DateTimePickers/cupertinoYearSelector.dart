import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class CustomYearPicker extends StatelessWidget {

  final DateTimeNotifier dateTimeNotifier;
  DateTime startYear;
  DateTime lastYear;
  DateTime initialYear;

  CustomYearPicker({Key? key, required this.dateTimeNotifier, required this.startYear, required this.lastYear, required this.initialYear}) : super(key: key);

  static const String date_format = 'yyyy';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DateTimePickerWidget(
        minDateTime: startYear,
        maxDateTime: lastYear,
        initDateTime: initialYear,
        dateFormat: date_format,
        pickerTheme: DateTimePickerTheme(
          showTitle: false,
          title: Container(),
          itemTextStyle: TextStyle(
            fontSize: 24,
          )
        ),
        onChange: (dateTime, selectedIndex) {
          dateTimeNotifier.updateSelectedDateTime = dateTime;
        },
      ),
    );
  }
}