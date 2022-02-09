import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class TitledYearPicker extends StatefulWidget {

  final String title;
  final DateTime? startYear;
  final DateTime? lastYear;
  final int? deltaYear;
  final DateTime? initialYear;
  final Function(DateTime newDateTime) onChanged; 
  final Size Function() getSize;

  final double? fieldWidth;
  final double? fieldHeigh;

  const TitledYearPicker({ Key? key, required this.title, this.startYear, this.lastYear, this.deltaYear, this.initialYear, this.fieldHeigh, this.fieldWidth, required this.onChanged, required this.getSize}) : super(key: key);

  @override
  State<TitledYearPicker> createState() => TitledYearPickerState();
}

class TitledYearPickerState extends State<TitledYearPicker> {

  DateTime getShowDateTime(DateTimeNotifier dateTimeNotifier){
    return dateTimeNotifier.currentSelectedDateTime ?? widget.initialYear ?? DateTime.now();
  }

  DateTimeNotifier? _dateTimeNotifier;

  void changeDateTime(DateTime newDateTime){
    if(_dateTimeNotifier != null){
      _dateTimeNotifier!.updateSelectedDateTime = newDateTime;
    }
  }

  void hanldeYearPickerSize(DateTimeNotifier dateTimeNotifier){
    dateTimeNotifier.updateSize = widget.getSize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ChangeNotifierProvider<DateTimeNotifier>(
        create: (context) => DateTimeNotifier(),
        child: Consumer<DateTimeNotifier>(
          builder: (context, dateTimeNotifier, wg) {
            if(_dateTimeNotifier == null){
              _dateTimeNotifier = dateTimeNotifier;
            }
            return GestureDetector(
              onTap: (){
                hanldeYearPickerSize(dateTimeNotifier);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Select Year",
                        style: TextStyle(
                          color: Color.fromRGBO(65, 105, 225, 1),
                          fontFamily: "SF Pro Medium",
                          // fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        ),
                        content: Container( // Need to use container to add size constraint.
                        width: dateTimeNotifier.currentSize != null ? dateTimeNotifier.currentSize!.width / 1.3 : MediaQuery.of(context).size.width * 0.4,
                        height: dateTimeNotifier.currentSize != null ? dateTimeNotifier.currentSize!.height / 1.3 : MediaQuery.of(context).size.height * 0.8,
                        child: YearPicker(
                          firstDate: widget.startYear ?? DateTime(DateTime.now().year - (widget.deltaYear ?? 20), 1),
                          lastDate: widget.lastYear ?? DateTime(DateTime.now().year + (widget.deltaYear ?? 20), 1),
                          initialDate: widget.initialYear ?? DateTime.now(),
                          selectedDate: getShowDateTime(dateTimeNotifier),
                          currentDate: getShowDateTime(dateTimeNotifier),
                          onChanged: (DateTime dateTime) {
                            dateTimeNotifier.updateSelectedDateTime = dateTime;
                            Navigator.of(context).pop();
                            widget.onChanged(dateTime);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.widget.title,
                    style: TextStyle(
                      color: Color.fromRGBO(75, 87, 123, 1),
                      fontFamily: "SF Pro Medium",
                      fontWeight: FontWeight.w400,
                      fontSize: 18
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 9.5,),
                  Container(
                    width: widget.fieldWidth ?? 100,
                    height: widget.fieldHeigh ?? 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          Text(
                            getShowDateTime(dateTimeNotifier).year.toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(75, 87, 123, 1),
                              fontFamily: "SF Pro Medium",
                              fontWeight: FontWeight.w400,
                              fontSize: 18
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}