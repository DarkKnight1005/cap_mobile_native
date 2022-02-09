import 'package:cap_mobile_native/models/locals/FilterData.dart';
import 'package:cap_mobile_native/models/locals/periodDropDownItem.dart';
import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:cap_mobile_native/notifiers/filter_notifier.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledMonthPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledQuarterPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/custom_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledYearPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/titledDropDown.dart';
import 'package:cap_mobile_native/ui/widgets/actionButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:provider/provider.dart';


class FilterAlertDialog extends CustomAlertDialog{

  final List<String> dropDownItemsCompany;
  final List<PeriodDropDownItem> dropDownItemsPeriod;

  FilterAlertDialog({
    required this.dropDownItemsCompany,
    required this.dropDownItemsPeriod,
  }) : super();

  late final BuildContext context; 
  late final Function(Object filterData) onApply; 
  late final String applyText;

  GlobalKey<TitledYearPickerState> yearPickerKeyStart = GlobalKey();
  GlobalKey<TitledYearPickerState> yearPickerKeyLast = GlobalKey();

  GlobalKey<TitledQuarterPickerState> quarterPickerKeyStart = GlobalKey();
  GlobalKey<TitledQuarterPickerState> quarterPickerKeyLast = GlobalKey();

  GlobalKey<TitledMonthPickerState> monthPickerKeyStart = GlobalKey();
  GlobalKey<TitledMonthPickerState> monthPickerKeyLast = GlobalKey();

  void showCustomAlertDialog({required BuildContext context, required Function(Object filterData) onApply, required String applyText}){
    this.context = context;
    this.onApply = onApply;
    this.applyText = applyText;
    this.showAlertDialog(context: context);
  }

  String _getInitialPeriodName(){
    String _initialPeriod = "";
    for (var dropDownItemPeriod in dropDownItemsPeriod) {
      if(dropDownItemPeriod.isSelectable){
        _initialPeriod = dropDownItemPeriod.title;
        break;
      }
    }
    return _initialPeriod;
  }

  PeriodType _getInitialPeriodType(){
    PeriodType _initialPeriodType = PeriodType.YEARLY;
    for (var dropDownItemPeriod in dropDownItemsPeriod) {
      if(dropDownItemPeriod.isSelectable){
        _initialPeriodType = dropDownItemPeriod.periodType;
        break;
      }
    }
    return _initialPeriodType;
  }

  Widget _getAppropriateDatePicker({
    required FilterNotifier filterNotifier, 
    required Size Function() getSize,
    required GlobalKey globalKeyYear,
    required GlobalKey globalKeyQuarter,
    required GlobalKey globalKeyMonth,
    required String title,
    DateTime? initialYear,
    Quarter? initialQuarter,
    required DateTime startYear,
    required DateTime lastYear,
    required Function(DateTime dateTime, {Quarter? quarter}) onChanged,
    }) {
    if(filterNotifier.filterData!.periodType == PeriodType.YEARLY) {
      return TitledYearPicker(
        key: globalKeyYear,
        fieldHeigh: 45,
        fieldWidth: baseWidth / 3.2,
        title: title,//"Başlanğıc tarix",
        initialYear: initialYear, //filterNotifier.filterData!.startYear!,
        startYear: startYear,//DateTime(2015),
        lastYear: lastYear, //DateTime(DateTime.now().year),
        getSize: getSize,
        onChanged: (newDateTime){
          onChanged(newDateTime);
        },
      );
    }else if(filterNotifier.filterData!.periodType == PeriodType.QUARTERLY){
      return TitledQuarterPicker(
        key: globalKeyQuarter,
        fieldHeigh: 45,
        fieldWidth: baseWidth / 3.2,
        title: title,//"Başlanğıc tarix",
        initialYear: initialYear, //filterNotifier.filterData!.startYear!,
        initialQuarter: initialQuarter,
        startYear: startYear,//DateTime(2015),
        lastYear: lastYear, //DateTime(DateTime.now().year),
        getSize: getSize,
        onChanged: (newDateTime, quarter){
          onChanged(newDateTime, quarter: quarter);
        },
      );
    }else if(filterNotifier.filterData!.periodType == PeriodType.MONTHLY){
      return TitledMonthPicker(
        key: globalKeyMonth,
        fieldHeigh: 45,
        fieldWidth: baseWidth / 3.2,
        title: title,//"Başlanğıc tarix",
        initialYear: initialYear, //filterNotifier.filterData!.startYear!,
        startYear: startYear,//DateTime(2015),
        lastYear: lastYear, //DateTime(DateTime.now().year),
        getSize: getSize,
        onChanged: (newDateTime){
          onChanged(newDateTime);
        },
      );
    }else{
      return Container();
    }
    
  }

  @override
  List<Widget> alertDialogChildren({BoxConstraints? constraints}){
  
    FilterData filterData = FilterData(
      company: dropDownItemsCompany[0], 
      periodName: _getInitialPeriodName(),
      periodType: _getInitialPeriodType(),
      startYear: DateTime(2015), 
      lastYear: DateTime.now(),
      quarterStart: Quarter.Q1,
      quarterLast: Quarter.Q4,
    );

    return [
      ChangeNotifierProvider<FilterNotifier>(
        create: (context) => FilterNotifier(),
        builder: (context, wg) => Consumer<FilterNotifier>(
          builder: (context, filterNotifier, wg) {
            if(filterNotifier.filterData == null){
              filterNotifier.updateFilterDataObject = filterData;
            }
            return Container(
              child: Column(
                children: [ 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Axtar", style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1), fontSize: 20, fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(MfgLabs.cancel, color: Colors.grey[400])
                      )
                    ],
                  ),
                  Container(
                    // height: scroll == null ?  100 : context.size!.height,
                    // color: Colors.red,
                    child: SingleChildScrollView(
                      child: Column(
                        
                        children: [
                          TitledDropDown(
                              title: "Müəssisə",
                              fieldWidth: baseWidth,
                              widthPadding: 50,
                              dropDownItems: dropDownItemsCompany, 
                              onChange: (selectedTabName, index) {
                                filterNotifier.updateFilterCompany = selectedTabName;
                              }
                          ),
                          SizedBox(height: 6,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: baseWidth / 3.2,
                                  height: 100,
                                  child: TitledDropDown(
                                    fieldWidth: baseWidth / 3.2,
                                    title: "Dövr",
                                    initialValue: filterNotifier.filterData!.periodName!,
                                    dropDownItems: List<String>.from(dropDownItemsPeriod.map((item) => item.title)),
                                    isSelectable: List<bool>.from(dropDownItemsPeriod.map((item) => item.isSelectable)),
                                    onChange: (selectedTabName, index) {
                                      filterNotifier.updateFilterPeriodName = selectedTabName;
                                      filterNotifier.updateFilterPeriodType = dropDownItemsPeriod[index].periodType;
                                    }
                                  ),
                                ),
                                Container(
                                  width: baseWidth / 3.2,
                                  height: 100,
                                  child: _getAppropriateDatePicker(
                                    globalKeyYear: yearPickerKeyStart,
                                    globalKeyQuarter: quarterPickerKeyStart,
                                    globalKeyMonth: monthPickerKeyStart,
                                    title: "Başlanğıc tarix",
                                    filterNotifier: filterNotifier, 
                                    initialYear: filterNotifier.filterData!.startYear,
                                    initialQuarter: Quarter.Q1,
                                    startYear: DateTime(2015),
                                    lastYear: DateTime.now(),
                                    getSize: (){
                                        return context.size!;
                                    },
                                    onChanged: (newDateTime, {quarter}){
                                      filterNotifier.updateFilterStartYear = newDateTime;
                                      if(newDateTime.year > filterNotifier.filterData!.lastYear!.year){
                                        if(yearPickerKeyLast.currentState != null){
                                          yearPickerKeyLast.currentState!.changeDateTime(newDateTime);
                                        }
                                        if(quarterPickerKeyLast.currentState != null){
                                          quarterPickerKeyLast.currentState!.changeDateTime(newDateTime);
                                        }
                                        if(monthPickerKeyLast.currentState != null){
                                          monthPickerKeyLast.currentState!.changeDateTime(newDateTime);
                                        }
                                        filterNotifier.updateFilterLastYear = newDateTime;
                                        if(quarter != null){
                                          filterNotifier.updateFilterQuarterStart = quarter;
                                        }  
                                      }
                                      if(newDateTime.year == filterNotifier.filterData!.lastYear!.year && newDateTime.month > filterNotifier.filterData!.lastYear!.month){
                                        if(monthPickerKeyLast.currentState != null){
                                          monthPickerKeyLast.currentState!.changeDateTime(newDateTime);
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: baseWidth / 3.2,
                                  height: 100,
                                  child: _getAppropriateDatePicker(
                                    globalKeyYear: yearPickerKeyLast,
                                    globalKeyQuarter: quarterPickerKeyLast,
                                    globalKeyMonth: monthPickerKeyLast,
                                    title: "Son tarix",
                                    filterNotifier: filterNotifier, 
                                    initialYear: filterNotifier.filterData!.lastYear,
                                    initialQuarter: Quarter.Q4,
                                    startYear: filterNotifier.filterData!.startYear!,
                                    lastYear: DateTime.now(),
                                    getSize: (){
                                        return context.size!;
                                    },
                                    onChanged: (newDateTime, {quarter}){
                                      filterNotifier.updateFilterLastYear = newDateTime;
                                      if(quarter != null){
                                        filterNotifier.updateFilterQuarterLast = quarter;
                                      }    
                                    },
                                  ),
                                ),
                              ],
                          ),
                          SizedBox(height: 22,),
                          ActionButton(
                              applyText: applyText, 
                              onApply: (){
                                Navigator.of(context).pop();      
                                onApply(filterData);
                              }
                          ),
                        ],
                        
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        )
      )
    ];
    
  }
}