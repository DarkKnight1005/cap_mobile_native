import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class WifiListTile extends StatelessWidget {

  final String ssid;
  final double height;
  final double width;
  final Function() onTap;

  const WifiListTile({
     Key? key,
     required this.height,
     required this.width,
     required this.onTap,
     required this.ssid,
     }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          height: this.height,
          width: this.width,
          color: Color.fromRGBO(65, 105, 225, 1).withOpacity(0.2),//Colors.grey[300],
          child: InkWell(
            onTap: (){
              this.onTap();
            },
            borderRadius: BorderRadius.circular(4),
            child: Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: CircleAvatar(
                      radius: height * 0.3,
                      backgroundColor: Colors.grey[100],//Color.fromRGBO(65, 105, 225, 1).withOpacity(0.4),//Colors.blueGrey[200],
                      child: Icon(Icons.wifi, size: 26, color: Color.fromRGBO(65, 105, 225, 1)),
                    ),
                  ),
                  Text(
                    this.ssid,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}