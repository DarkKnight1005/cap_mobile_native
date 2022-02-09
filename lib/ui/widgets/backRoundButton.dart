import 'dart:ui';

import 'package:flutter/material.dart';

class BackRoundButton extends StatelessWidget {

  Function onTap;

  BackRoundButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: GestureDetector(
        onTap: (){
          this.onTap();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              // BoxShadow(
              //   spreadRadius: 4,
              //   color: Colors.black,
              //   offset: Offset(2, 2),
              //   blurRadius: 3,
              // )
            ],
          ),
          child: Container(
            height: 70,
            width: 70,
            color: Colors.transparent,//Color.fromRGBO(232, 237, 247, 1),
            child: Icon(
              Icons.arrow_back_ios_new, 
              color: Colors.white,//Color.fromRGBO(65, 105, 225, 1),
              size: 26,
              ),
          )
        ),
      )
    );
  }
}