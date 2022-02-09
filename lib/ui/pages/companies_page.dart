// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget _home_logo = SvgPicture.asset(
      'assets/home_logo_simple.svg',
      width: MediaQuery.of(context).size.width * 0.08,
    );
    final Widget _main_logo = Padding(
      padding: EdgeInsets.only(top: 20),
      child: SvgPicture.asset(
        'assets/main_logo.svg',
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      body: Builder(
        builder: (con) => Container(
          color: Color.fromRGBO(232, 237, 247, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                padding: EdgeInsets.only(
                  top: 12,
                  left: 21,
                  right: 21,
                ),
                height: 70,
                color: Colors.white,
                child: Row(
                  children: [
                    _home_logo,
                   Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'General Information System',
                        style: TextStyle(
                          color: Color.fromRGBO(65, 105, 225, 1),
                          fontSize: 26,
                        ),
                      ),
                    ),
                   Expanded(child: Container()),
                   Container(
                      child: Icon(
                        Icons.menu_rounded,
                        size: MediaQuery.of(context).size.width * 0.04,
                        color: Color.fromRGBO(75, 87, 123, 1),
                      ),
                    )
                  ],
                ),
              ),
             Expanded(child: Container()),
             Container(
                height: MediaQuery.of(context).size.height -
                    (70 + MediaQuery.of(context).padding.top + 25),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      _main_logo,
                     Row(
                        children: [
                         Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 246, 251, 1),
                            ),
                            margin: EdgeInsets.only(left: 20, right: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
