import 'package:cap_mobile_native/models/locals/periodDropDownItem.dart';
import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

FilterData filterDataFromJson(String str) => FilterData.fromJson(json.decode(str));

String filterDataToJson(FilterData data) => json.encode(data.toJson());

class FilterData {
    FilterData({
        required this.company,
        required this.periodName,
        required this.periodType,
        required this.startYear,
        required this.lastYear,
        required this.quarterStart,
        required this.quarterLast,
    });

    String? company;
    String? periodName;
    PeriodType? periodType;
    DateTime? startYear;
    DateTime? lastYear;
    Quarter? quarterStart;
    Quarter? quarterLast;

    factory FilterData.fromJson(Map<String, dynamic> json) => FilterData(
        company: json["company"],
        periodName: json["periodName"],
        periodType: json["periodType"],
        startYear: json["startYear"],
        lastYear: json["lastYear"],
        quarterStart: json["quaterStart"],
        quarterLast: json["quaterLast"],
    );

    Map<String, dynamic> toJson() => {
        "company": company,
        "periodName": periodName,
        "periodType": periodType,
        "startYear": startYear,
        "lastYear": lastYear,
        "quaterStart": quarterStart,
        "quaterLast": quarterLast,
    };
}
