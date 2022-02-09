import 'package:cap_mobile_native/models/locals/FilterData.dart';
import 'package:cap_mobile_native/models/locals/periodDropDownItem.dart';
import 'package:cap_mobile_native/notifiers/dateTime_notifier.dart';
import 'package:cap_mobile_native/notifiers/filter_notifier.dart';
import 'package:cap_mobile_native/notifiers/wifi_notifier.dart';
import 'package:cap_mobile_native/services/wifi_service.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledMonthPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledQuarterPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/custom_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/DateTimePickers/titledYearPicker.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/textField_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/titledDropDown.dart';
import 'package:cap_mobile_native/ui/widgets/quick_toast.dart';
import 'package:cap_mobile_native/ui/widgets/wifiListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:provider/provider.dart';


class WifiAlertDialog extends CustomAlertDialog{

  WifiAlertDialog() : super();

  late final BuildContext context; 
  WifiNotifier? _wifiNotifier;
  bool makeMaxSizePortrait = false;

  void showCustomAlertDialog({required BuildContext context}){
    this.context = context;
    baseWidth = MediaQuery.of(context).orientation == Orientation.landscape
    ? MediaQuery.of(context).size.width * 0.4
    : MediaQuery.of(context).size.height * 0.5;
    alertDialogColor = Color.fromRGBO(232, 237, 247, 1);
    this.showAlertDialog(context: context);
  }

  loadSsidList(WifiNotifier wifiNotifier) async{
    List<String> _tempList = await WifiService.loadSsidList();
    for (var item in _tempList) {
      if(!wifiNotifier.ssids.contains(item)){
        wifiNotifier.addSsid(item);
      }
    }
    wifiNotifier.doNotify();
  }

  void _requestPassword(){
    TextFieldAlertDialog().showCustomAlertDialog(
      applyText: "Tətbiq et",
      context: context,
      makeMaxSizePortrait: makeMaxSizePortrait,
      onSubmit: (text){
        _tryToConnect(text);
      }
    );
  }

  void showErrorToast(){
    String networlName = _wifiNotifier!.currentSelectedSsid ?? "network";
    QuickToast.showToast(
      message: "Cannot connect to ${networlName}",
      awarenessLevel: AwarenessLevel.ERRROR,
    );
  }

  void _tryToConnect(String? _password) async{
    // final RegExp wpa2RegExp = RegExp(r'/^[\u0020-\u007e\u00a0-\u00ff]*$/');
    bool isSuccess = true;
    if(_wifiNotifier!.currentSelectedSsid != null && _password != null /*&& wpa2RegExp.hasMatch(_password)*/){
      isSuccess = await WifiService.tryToConnect(ssid: _wifiNotifier!.currentSelectedSsid!, password: _password);
    }else{
      isSuccess = false;
    }

    if(!isSuccess){
      showErrorToast();
      _requestPassword();
    }else{
      Navigator.of(context).pop();
    }
  }


  @override
  List<Widget> alertDialogChildren({BoxConstraints? constraints}){

    if(constraints!.maxWidth <= baseWidth){
      makeMaxSizePortrait = true;
    }

    return [
      ChangeNotifierProvider<WifiNotifier>(
        create: (context) => WifiNotifier(),
        builder: (context, wg) => Consumer<WifiNotifier>(
          builder: (context, wifiNotifier, wg) {
            if(_wifiNotifier == null){
              _wifiNotifier = wifiNotifier;
            }
            if(wifiNotifier.ssids.isEmpty){
              loadSsidList(wifiNotifier);
            }
            return Container(
              child: Column(
                children: [ 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Wifi", style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1), fontSize: 20, fontWeight: FontWeight.bold),),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(MfgLabs.cancel, color: Colors.grey[400])
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.9,
                    // color: Colors.red,
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior().copyWith(physics: BouncingScrollPhysics()),
                      child: ListView.builder(
                        itemCount: wifiNotifier.ssids.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WifiListTile(
                            height: 70, 
                            width: baseWidth * 0.3,//MediaQuery.of(context).size.width * 0.3, 
                            onTap: () async{
                              wifiNotifier.uppdaeCurrentSsid = wifiNotifier.ssids[index];
                              _requestPassword();
                              wifiNotifier.doNotify();
                            }, 
                            ssid: wifiNotifier.ssids[index]
                          );
                        },
                      ),
                    )
                  )
                ],
              ),
            );
          }
        )
      )
    ];
    
  }
}