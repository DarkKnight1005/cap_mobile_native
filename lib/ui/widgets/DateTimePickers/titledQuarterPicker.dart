import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/cupertinoYearSelector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:provider/provider.dart';

class TitledQuarterPicker extends StatefulWidget {

  final String title;
  final DateTime? startYear;
  final DateTime? lastYear;
  final int? deltaYear;
  final DateTime? initialYear;
  final Quarter? initialQuarter;
  final Function(DateTime newDateTime, Quarter quarter) onChanged; 
  final Size Function() getSize;

  final double? fieldWidth;
  final double? fieldHeigh;

  const TitledQuarterPicker({ Key? key, required this.title, this.initialQuarter, this.startYear, this.lastYear, this.deltaYear, this.initialYear, this.fieldHeigh, this.fieldWidth, required this.onChanged, required this.getSize}) : super(key: key);

  @override
  State<TitledQuarterPicker> createState() => TitledQuarterPickerState();
}

class TitledQuarterPickerState extends State<TitledQuarterPicker> {


  @override
  void initState() {
    super.initState();
  }

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

  Map<String, String> parseQuarter(Quarter _quarter){

    String _quarterName = "";
    String _months = "";

    switch (_quarter) {
      case Quarter.Q1:
        _quarterName = "R1";
        _months = "Yan Fev Mar";
        break;
      case Quarter.Q2:
        _quarterName = "R2";
        _months = "Apr May Iyn";
        break;
      case Quarter.Q3:
        _quarterName = "R3";
        _months = "Iyl Avg Sen";
        break;
      case Quarter.Q4:
        _quarterName = "R4";
        _months = "Okt Noy Dek";
        break;
      default:
        _quarterName = "?";
        _months = "?";
    }

    return {"quarterName" : _quarterName, "months" : _months};
  }

  Widget QuarterButton(Quarter _quarter, double _width){

    String _quarterName = parseQuarter(_quarter)["quarterName"]!;
    String _months = parseQuarter(_quarter)["months"]!;

    bool isSameYear = widget.startYear!.year == widget.lastYear!.year;
    bool isInQuarterRange = widget.initialQuarter!.index <= _quarter.index;
    // bool isOutOfDate = (getShowDateTime().year == DateTime.now().year && isInQuarterRange <= DateTime.now().month) || (getShowDateTime().year != DateTime.now().year);
    bool _isSelectable = true;
    // (!isSameYear || (isSameYear && isInQuarterRange));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: 80,
          width: _width * 1.3,//100,
          color: _dateTimeNotifier!.currentQuarter == _quarter
          ? Color.fromRGBO(65, 105, 225, 1).withOpacity(0.2)
          : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: 
            _isSelectable 
            ? (){
              _dateTimeNotifier!.updateQuarter = _quarter;
              _dateTimeNotifier!.updateIsConfirmed = true;
              widget.onChanged(getShowDateTime(), _quarter);
              Navigator.of(context).pop();
            }
            : null,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _quarterName, 
                    style: TextStyle(
                      fontSize: 24,
                      color: _isSelectable
                      ? null
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
                    )
                  ),
                  SizedBox(height: 8,),
                  Text(_months, style: TextStyle(fontSize: 12),)
                ],
              ),
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
              _dateTimeNotifier!.updateQuarter = widget.initialQuarter ?? Quarter.Q1;
            }
            const double coofQuarterButton = 0.19;
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
                      contentPadding: const EdgeInsets.fromLTRB(24.0, 4.0, 0.0, 12.0),
                      title: Text(
                        "Select Quarter",
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
                              width:  _width * 0.4,
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
                                        QuarterButton(Quarter.Q1, _width * coofQuarterButton),
                                        QuarterButton(Quarter.Q2, _width * coofQuarterButton),
                                      ],
                                    ),
                                      Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        QuarterButton(Quarter.Q3, _width * coofQuarterButton),
                                        QuarterButton(Quarter.Q4, _width * coofQuarterButton),
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
                            (_dateTimeNotifier != null ? parseQuarter(_dateTimeNotifier!.currentQuarter!) : parseQuarter(widget.initialQuarter!))["quarterName"]!,
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