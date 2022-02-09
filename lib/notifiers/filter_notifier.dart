import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:cap_mobile_native/models/locals/FilterData.dart';
import 'package:cap_mobile_native/models/locals/periodDropDownItem.dart';
import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:flutter/material.dart';

class FilterNotifier extends ChangeNotifier {
  
  FilterData? filterData;

  set updateFilterDataObject(FilterData newFilterData) {
    filterData = newFilterData;
  }

  set updateFilterCompany(String newCompanyName) {
    filterData!.company = newCompanyName;
    notifyListeners();
  }

  set updateFilterPeriodName(String newPeriodName) {
    filterData!.periodName = newPeriodName;
    notifyListeners();
  }

  set updateFilterPeriodType(PeriodType newPeriodType) {
    filterData!.periodType = newPeriodType;
    notifyListeners();
  }

  set updateFilterStartYear(DateTime newStartYear) {
    filterData!.startYear = newStartYear;
    notifyListeners();
  }

  set updateFilterLastYear(DateTime newLastYear) {
    filterData!.lastYear = newLastYear;
    notifyListeners();
  }

  set updateFilterQuarterStart(Quarter newQuarter) {
    filterData!.quarterStart = newQuarter;
    notifyListeners();
  }

  set updateFilterQuarterLast(Quarter newQuarter) {
    filterData!.quarterLast = newQuarter;
    notifyListeners();
  }

  void doNotify(){
    notifyListeners();
  }
}
