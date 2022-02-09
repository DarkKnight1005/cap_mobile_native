import 'package:flutter/material.dart';

class Sizes {
  Sizes._();

  static const double padding = 14.0;
  static const double avatarRadius = 55.0;
}

class RoundedAlertDialog {

  RoundedAlertDialog._();

  static Future<bool> showAlertDialog({
    required BuildContext context, 
    required Function() onCancel,
    required Function() onAccept,
    required String title,
    required String description,
    required String okayText,
    required String cancelText,
    }) async {
    return (await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.padding),
      ),    
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
    children: <Widget>[
      Container(
  padding: EdgeInsets.only(
    top: Sizes.avatarRadius + Sizes.padding,
    bottom: Sizes.padding,
    left: Sizes.padding,
    right: Sizes.padding,
  ),
  margin: EdgeInsets.only(top: Sizes.avatarRadius),
  decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(Sizes.padding),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10.0,
        offset: const Offset(0.0, 10.0),
      ),
    ],
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min, // To make the card compact
    children: <Widget>[
      Text(
        title, //'Trust this Device',
        style: TextStyle(
          fontSize: 24.0,
          fontFamily: "GothamRounded",
          
        ),
      ),
      SizedBox(height: 16.0),
      Text(
        description, //"4-digit code or biometrics will be required on each login",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: "GothamRounded",
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
      ),
      SizedBox(height: 6.0),
         Row(
           mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: onCancel,
              child: Text( cancelText, style: TextStyle(color: Colors.red,),),
            ),
            FlatButton(
              onPressed: onAccept,
              child: Text( okayText, style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1)),),
            ),
          ],
        ),
      
      
    ],
  ),
),
Positioned(
  left: Sizes.padding,
  right: Sizes.padding,
  child: CircleAvatar(
    backgroundColor: Color.fromRGBO(65, 105, 225, 1),
    radius: Sizes.avatarRadius,
    child: Icon(Icons.fingerprint, size: 60, color: Colors.white,),
  ),
),
    ],
  ), 
      ),
    )) ?? false;
  }
}