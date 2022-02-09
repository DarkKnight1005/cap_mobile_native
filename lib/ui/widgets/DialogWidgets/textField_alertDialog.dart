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
import 'package:cap_mobile_native/ui/widgets/DropDowns/titledDropDown.dart';
import 'package:cap_mobile_native/ui/widgets/actionButton.dart';
import 'package:cap_mobile_native/ui/widgets/cap_textfield.dart';
import 'package:cap_mobile_native/ui/widgets/wifiListTile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:provider/provider.dart';


class TextFieldAlertDialog extends CustomAlertDialog{

  TextFieldAlertDialog() : super();

  Function(String? text)? onSubmit;
  late final String applyText;

  late final BuildContext context; 
  final TextEditingController _textEditingController = TextEditingController();
  

  void showCustomAlertDialog({required BuildContext context, required Function(String? text) onSubmit, required String applyText, required bool makeMaxSizePortrait}){
    this.context = context;
    this.onSubmit = onSubmit;
    this.applyText = applyText;
    baseWidth = MediaQuery.of(context).orientation == Orientation.landscape
    ? MediaQuery.of(context).size.width * 0.3
    : MediaQuery.of(context).size.height * (makeMaxSizePortrait ? 0.4 : 0.4);// Size(236.0, 524.0)

    alertDialogColor = Color.fromRGBO(232, 237, 247, 1);
    this.showAlertDialog(context: context);
  }

  @override
  List<Widget> alertDialogChildren({BoxConstraints? constraints}){
    debugPrint(constraints!.biggest.toString());
    return [
       Container(
        child: Column(
          children: [ 
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Write a password", style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1), fontSize: 20, fontWeight: FontWeight.bold),),
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
              margin: new EdgeInsets.only(top: 20),
              // width: MediaQuery.of(context).size.width * 0.75,
              child: CAPTextField(
                label: 'Şifrə',
                controller: _textEditingController,
                hintText: 'şifrə',
                isPassword: true,
                needAutoFocus: true,
                focusNode: FocusNode(),
                textInputAction: TextInputAction.done,
                  onDone: (){
                    Navigator.of(context).pop();      
                    onSubmit!(_textEditingController.text);
                  },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ActionButton(
                applyText: applyText, 
                onApply: (){
                  Navigator.of(context).pop();      
                  onSubmit!(_textEditingController.text);
                }
          ),
            ),
          ],
        ),
      )
    ];
    
  }
}