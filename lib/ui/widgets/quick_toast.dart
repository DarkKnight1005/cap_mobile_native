import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AwarenessLevel {  
  ERRROR,
  WARNING,
  SUCCESS
}

class QuickToast {
  QuickToast._();

  static void showToast({required String message, AwarenessLevel? awarenessLevel}){

    Color _toastColor;

    switch (awarenessLevel) {
      case AwarenessLevel.SUCCESS:
        _toastColor =  Colors.green;
        break;
      case AwarenessLevel.WARNING:
        _toastColor =  Colors.amber;
        break;
      case AwarenessLevel.ERRROR:
        _toastColor =  Colors.red;
        break;
      default:
        _toastColor =  Colors.grey;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: _toastColor,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}