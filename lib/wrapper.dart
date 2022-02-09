// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/ui/pages/home_page.dart';
import 'package:cap_mobile_native/ui/pages/login_page.dart';
import 'package:cap_mobile_native/ui/pages/open_code_page.dart';
import 'package:cap_mobile_native/ui/widgets/customBanner.dart';
import 'package:cap_mobile_native/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        Consumer<AccountNotifier>(
          builder: (context, account, child) {
            return FutureBuilder(
              future: account.isLogedIn,
              // initialData: InitialData,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  if(snapshot.data!){
                    if(account.isBioCodeEnabled && !account.isAuthedBio){
                      return HomePage();//OpenCodePage();
                    }else{
                      return HomePage();
                    }
                  }else{
                    return LoginPage();
                  }
                }else{
                  return Loading();
                }
                
              },
            );
          }
        ),
        CustomBanner(text: "BETA"),
      ],
    );
  }
}