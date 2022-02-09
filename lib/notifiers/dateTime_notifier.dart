import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:flutter/material.dart';

enum Quarter{
  Q1,
  Q2,
  Q3,
  Q4,
}

class DateTimeNotifier extends ChangeNotifier {
  
  DateTime? _selectedDateTime;
  Quarter? _quarter; 
  Size? _size;
  bool _isConfirmed = false;

  set updateSelectedDateTime(DateTime newDateTime) {
    _selectedDateTime = newDateTime;
    notifyListeners();
  }

  set updateSize(Size newSize) {
    _size = newSize;
    notifyListeners();
  }

  set updateQuarter(Quarter newQuarter) {
    _quarter = newQuarter;
  }

  set updateIsConfirmed(bool newStatus) {
    debugPrint("Recieved event --updateIsConfirmed-- change from -- ${_isConfirmed} -- to -- ${newStatus} --");
    _isConfirmed = newStatus;
    notifyListeners();
  }

  DateTime? get currentSelectedDateTime => _selectedDateTime;
  
  Size? get currentSize => _size;

  Quarter? get currentQuarter => _quarter;

  bool get getIsConfirmed => _isConfirmed;

  void doNotify(){
    notifyListeners();
  }
}
