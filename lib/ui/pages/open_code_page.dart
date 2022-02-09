
import 'dart:async';
import 'dart:ui';

import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/models/responses/auth_response.dart';
import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/services/API/account_service.dart';
import 'package:cap_mobile_native/ui/pages/home_page.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/rounded_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/otp_timer.dart';
import 'package:cap_mobile_native/ui/widgets/quick_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OpenCodePage extends StatefulWidget {


  const OpenCodePage({
    Key? key,
  }) : super(key: key);
  @override
  _OpenCodePageState createState() => new _OpenCodePageState();
}

class _OpenCodePageState extends State<OpenCodePage> with SingleTickerProviderStateMixin {
  // Constants
  final int time = 60;
  final AccountService _accountService = new AccountService();
  final TextEditingController _pinController = new TextEditingController();
  late AnimationController _controller;
  late AccountNotifier accountNotifier;

  // Variables
  late Size _screenSize;
  late Timer timer;
  late int? totalTimeInSeconds;
  late bool _hideResendButton;
  late LocalAuthentication localAuth;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 5))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);

      localAuth = LocalAuthentication();

      tryBiometricAuth();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> tryBiometricAuth() async{
    bool _isSuccess = await localAuth.authenticate(localizedReason: "Sistemə daxil olmaq üçün təsdiqləyin", biometricOnly: true);
    if(_isSuccess){
      accountNotifier.isAuthedBio = true;
    }
  }

  get _getAppbar {
    return new AppBar(
      backgroundColor: Color.fromRGBO(65, 105, 225, 1),
      elevation: 0.0,
      leading: new InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: new Icon(
          Icons.keyboard_arrow_left,
          size: 46,
          color: Colors.white,
        ),
        onTap: () {
          accountNotifier.doLogOut();
        },
      ),
      centerTitle: true,
      title: _getVerificationCodeLabel,
    );
  }

  get _getVerificationCodeLabel {
    return new Text(
      "Pin kod",
      textAlign: TextAlign.left,
      style: new TextStyle(
        fontSize: 22.0,
        color: Colors.white,
      ),
    );
  }

  Widget _getInputField({required bool isPortrait}) {
    return new Stack(
      children: [
        new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 40),
          child: PinCodeTextField(
            controller: _pinController,
            backgroundColor: Colors.white,
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Color.fromRGBO(75, 87, 123, 1),
              fontWeight: FontWeight.bold,
            ),
            length: 4,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: 50,
              borderRadius: BorderRadius.circular(5),
              borderWidth: 3,
              fieldWidth: isPortrait 
              ? MediaQuery.of(context).size.width / 4 - 40 
              : MediaQuery.of(context).size.width / 13,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              activeColor: Color.fromRGBO(65, 105, 225, 1),
              inactiveColor: Color.fromRGBO(75, 87, 123, 1),
            ),
            cursorColor: Colors.black,
            animationDuration: Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              print(value);
              setState(() {});
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),
        ),
        new Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
        ),
        
      ],
    );
  }

  get _getInputPartPortrait {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.13,
              bottom: MediaQuery.of(context).size.height * 0.04),
          child: _getInputField(isPortrait: true),
        ),
        new Expanded(child: new Container()),
        _getOtpKeyboard(isPortrait: true),
      ],
    );
  }

  get _getInputPartLandscape {
    return Row(
      children: [
        Container(
          height: _screenSize.height,
          width: _screenSize.width* 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: _getInputField(isPortrait: false),
              ),
              SizedBox(height: 40,),
            ],
          ),
        ),
        Container(
          height: _screenSize.height,
          width: _screenSize.width* 0.5,
          child: _getOtpKeyboard(isPortrait: false),
        )
      ]
    );
  }



  get _getResendButton {
    return new InkWell(
      child: new Container(
        height: 32,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: new Text(
          "Yenidən Göndər",
          style:
              new TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: () {
        // Resend you OTP via API or anything
      },
    );
  }

  Widget _getOtpKeyboard({required bool isPortrait}) {
    return new Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(65, 105, 225, 1),
        borderRadius: new BorderRadius.only(
          topLeft: new Radius.circular(isPortrait ? 45 : 0),
          topRight: new Radius.circular(isPortrait ? 45 : 0),
        ),
      ),
      padding: new EdgeInsets.only(top: isPortrait ? 40 : 0),
      height: _screenSize.width - 50,
      child: new Column(
        children: <Widget>[
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "1",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(1);
                    }),
                _otpKeyboardInputButton(
                    label: "2",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(2);
                    }),
                _otpKeyboardInputButton(
                    label: "3",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(3);
                    }),
              ],
            ),
          ),
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "4",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(4);
                    }),
                _otpKeyboardInputButton(
                    label: "5",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(5);
                    }),
                _otpKeyboardInputButton(
                    label: "6",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(6);
                    }),
              ],
            ),
          ),
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "7",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(7);
                    }),
                _otpKeyboardInputButton(
                    label: "8",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(8);
                    }),
                _otpKeyboardInputButton(
                    label: "9",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(9);
                    }),
              ],
            ),
          ),
          new Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardActionButton(
                    label: Icon(Icons.fingerprint, size: 34, color: Colors.white,),
                    isPortrait: isPortrait,
                    onPressed: () {
                      tryBiometricAuth();
                    }),
                _otpKeyboardInputButton(
                    label: "0",
                    isPortrait: isPortrait,
                    onPressed: () {
                      _setCurrentDigit(0);
                    }),
                _otpKeyboardActionButton(
                    label: new Icon(
                      Icons.backspace,
                      color: Colors.white,
                      size: 30,
                    ),
                    isPortrait: isPortrait,
                    onPressed: () {
                      var length = _pinController.text.length;
                      if (length > 0) {
                        _pinController.text =
                            _pinController.text.substring(0, length - 1);
                      }
                    }
                  ),
              ],
            ),
          ),
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    accountNotifier = Provider.of<AccountNotifier>(context);

    return WillPopScope(
      onWillPop: () async{
        accountNotifier.doLogOut();
        return true;
      },
      child: new Scaffold(
        appBar: _getAppbar,
        backgroundColor: Colors.white,
        body:  OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Stack(
              children: [ 
                Offstage(
                  offstage: orientation != Orientation.portrait,
                  child: Container(
                  width: _screenSize.width,
                  child: _getInputPartPortrait,
                )
              ),
              Offstage(
                  offstage: orientation == Orientation.portrait,
                  child: Container(
                  width: _screenSize.width,
                  child: _getInputPartLandscape,
                )
              ),
              ]
            );
          },
        ), 
      ),
    );
  }

  Widget _otpKeyboardInputButton(
      {required String label, required VoidCallback onPressed, required bool isPortrait}) {
    return new Material(
      color: Colors.transparent,
      borderRadius:
          new BorderRadius.circular(
            isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6
          ),
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(
            isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6
          ),
        child: new Container(
          height: isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6,
          width: isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _otpKeyboardActionButton({Widget? label, required VoidCallback onPressed, required bool isPortrait}) {
    return new InkWell(
      onTap: onPressed,
     borderRadius:
          new BorderRadius.circular(isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6
          ),
      child: new Container(
        height: isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6,
        width: isPortrait
            ? MediaQuery.of(context).size.width / 3 - 50
            : MediaQuery.of(context).size.width / 6,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  void _setCurrentDigit(int i){
    if (_pinController.text.length < 4) {
      _pinController.text += i.toString();
    }
    if(_pinController.text.length == 4){
      validateCode();
    }
  }

  void validateCode(){
    bool isValid = accountNotifier.checkCode(_pinController.text);
    if(isValid){
      accountNotifier.isAuthedBio = true;
    }else{
      _pinController.text = "";
      QuickToast.showToast(message: "Kod səhvdir", awarenessLevel: AwarenessLevel.ERRROR);
    }
  }
}

