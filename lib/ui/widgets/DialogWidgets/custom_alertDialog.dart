import 'package:cap_mobile_native/models/locals/FilterData.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledYearPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/titledDropDown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:meta/meta.dart';

class Sizes {
  Sizes._();

  static const double padding = 22.0;
  static const double borderRadius = 2.0;
}

abstract class CustomAlertDialog {

  CustomAlertDialog(){
   baseWidth = 0;
  }

  late double baseWidth;
  late Size dialogSize;
  Color? alertDialogColor;

  @protected
  List<Widget> alertDialogChildren({BoxConstraints? constraints}){
    return [];
  }

  @protected
  Future<bool> showAlertDialog({
    required BuildContext context, 
  }) async {
    
    baseWidth = baseWidth == 0 ? MediaQuery.of(context).size.width * 0.52 : baseWidth;
    
    return (
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.borderRadius),
          ),    
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
              padding: EdgeInsets.only(
                top: Sizes.padding,
                bottom: Sizes.padding,
                left: Sizes.padding,
                right: Sizes.padding,
              ),
              decoration: new BoxDecoration(
                color: alertDialogColor ?? Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    width: baseWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // To make the card compact
                      children: alertDialogChildren(constraints: constraints)
                    ),
                  );
                },
              ),
            ),
          ],
        ), 
      );
     }
    )) ?? false;
  }
}