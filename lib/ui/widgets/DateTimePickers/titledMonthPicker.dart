import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/cupertinoYearSelector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class TitledMonthPicker extends StatefulWidget {

  final String title;
  final DateTime? startYear;
  final DateTime? lastYear;
  final int? deltaYear;
  final DateTime? initialYear;
  final Function(DateTime newDateTime) onChanged; 
  final Size Function() getSize;

  final double? fieldWidth;
  final double? fieldHeigh;

  const TitledMonthPicker({ Key? key, required this.title, this.startYear, this.lastYear, this.deltaYear, this.initialYear, this.fieldHeigh, this.fieldWidth, required this.onChanged, required this.getSize}) : super(key: key);

  @override
  State<TitledMonthPicker> createState() => TitledMonthPickerState();
}

class TitledMonthPickerState extends State<TitledMonthPicker> {

  DateTime getShowDateTime(){
    return _dateTimeNotifier!.currentSelectedDateTime ?? widget.initialYear ?? DateTime.now();
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

  void _onDialogDissmised(){
    if(!_dateTimeNotifier!.getIsConfirmed){
      _dateTimeNotifier!.updateSelectedDateTime = widget.initialYear ?? DateTime.now();
    }
    _dateTimeNotifier!.updateIsConfirmed = false;
  }

  String _getMonthName(int monthIndex){

    String _monthName = "";

    switch (monthIndex) {
      case 1:
        _monthName = "Yanvar";
        break;
      case 2:
        _monthName = "Fevral";
        break;
      case 3:
        _monthName = "Mart";
        break;
      case 4:
        _monthName = "Aprel";
        break;
      case 5:
        _monthName = "May";
        break;
      case 6:
        _monthName = "Iyun";
        break;
      case 7:
        _monthName = "Iyul";
        break;
      case 8:
        _monthName = "Avgust";
        break;
      case 9:
        _monthName = "Sentyabr";
        break;
      case 10:
        _monthName = "Oktyabr";
        break;
      case 11:
        _monthName = "Noyabr";
        break;
      case 12:
        _monthName = "Dekabr";
        break;
      default:
      _monthName = "?";
    }


    return _monthName;
  }

  Widget MonthButton(int monthIndex){

    String _monthName = _getMonthName(monthIndex);
    bool isSameYear = widget.startYear!.year == widget.lastYear!.year;
    bool isInMonthRange = widget.startYear!.month <= monthIndex;
    bool isOutOfDate = (getShowDateTime().year == DateTime.now().year && monthIndex <= DateTime.now().month) || (getShowDateTime().year != DateTime.now().year);
    bool _isSelectable = !((isSameYear && !isInMonthRange) || !isOutOfDate);

    debugPrint("Initial Year --> " + "${widget.initialYear}");
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 35,
          width: 80,
          color: getShowDateTime().month == monthIndex
          ? Color.fromRGBO(65, 105, 225, 1).withOpacity(0.2)
          : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: _isSelectable
            ? (){
              _dateTimeNotifier!.updateSelectedDateTime = DateTime(getShowDateTime().year, monthIndex);
              _dateTimeNotifier!.updateIsConfirmed = true;
              widget.onChanged(getShowDateTime());
              Navigator.of(context).pop();
            }
            : null,
            child: Center(
              child: Container(
                child: Text(
                  _monthName, 
                  style: TextStyle(
                    color: _isSelectable
                    ? null
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
                  ),
                ),
              )
            ),
          ),
        ),
      ),
    );
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
            const double cooMonthButton = 0.12;
            return GestureDetector(
              onTap: (){
                hanldeYearPickerSize(dateTimeNotifier);
                showDialogSuper(
                  context: context,
                  onDismissed: (data){
                    _onDialogDissmised();
                  },
                  builder: (BuildContext context) {
                    double _height = dateTimeNotifier.currentSize != null ? dateTimeNotifier.currentSize!.height / 1.3 : MediaQuery.of(context).size.height * 0.8;
                    double _width = dateTimeNotifier.currentSize != null ? dateTimeNotifier.currentSize!.width / 1.2 : MediaQuery.of(context).size.width * 0.4;
                    return AlertDialog(
                      title: Text(
                        "Select Month",
                        style: TextStyle(
                          color: Color.fromRGBO(65, 105, 225, 1),
                          fontFamily: "SF Pro Medium",
                          // fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        ),
                      content: Container( // Need to use container to add size constraint.
                        width: _width,
                        height: _height,
                        child: Row(
                          children: [
                            Container(
                              width:  _width * 0.25,
                              height: _height,
                              child: ScrollConfiguration(
                                behavior: ScrollBehavior().copyWith(physics: BouncingScrollPhysics()),
                                child: CustomYearPicker(
                                  dateTimeNotifier: dateTimeNotifier,
                                  startYear: widget.startYear!,
                                  lastYear: widget.lastYear!,
                                  initialYear: getShowDateTime(),
                                ),
                              )
                            ),
                            Container(
                              width: 10, 
                              height: _height * 0.9,
                              child: VerticalDivider(width: 0,)
                            ),
                            Expanded(
                              child: Container(
                                // height: _height * 1.2,
                                // color: Colors.red,
                                // width:  _width * 0.5813,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MonthButton(1),
                                        MonthButton(2),
                                        MonthButton(3),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MonthButton(4),
                                        MonthButton(5),
                                        MonthButton(6),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MonthButton(7),
                                        MonthButton(8),
                                        MonthButton(9),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MonthButton(10),
                                        MonthButton(11),
                                        MonthButton(12),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getShowDateTime().year.toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(75, 87, 123, 1),
                              fontFamily: "SF Pro Medium",
                              fontWeight: FontWeight.w400,
                              fontSize: 18
                            ),
                          ),
                          Text(
                            getShowDateTime().month.toString().length > 1 ? getShowDateTime().month.toString() : "0" + getShowDateTime().month.toString(),
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