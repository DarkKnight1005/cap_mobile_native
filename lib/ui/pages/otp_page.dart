import 'dart:async';

import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/models/responses/auth_response.dart';
import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/services/API/account_service.dart';
import 'package:cap_mobile_native/ui/pages/home_page.dart';
import 'package:cap_mobile_native/ui/pages/login_code_page.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/rounded_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/otp_timer.dart';
import 'package:cap_mobile_native/ui/widgets/quick_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final AuthDTO dto;

  const OtpPage({
    Key? key,
    required this.dto,
  }) : super(key: key);
  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpPage> with SingleTickerProviderStateMixin {
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
  // late bool _hideResendButton;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 5))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              // setState(() {
              //   _hideResendButton = !_hideResendButton;
              // });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: _getVerificationCodeLabel,
    );
  }

  get _getVerificationCodeLabel {
    return new Text(
      "Təsdiq kodu",
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
        )
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
        _getTimerText,
        SizedBox(height: 20,),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Center(
            child: Text(
              "SMS vasitəsilə göndərilən təsdiq kodunu daxil edin", 
              style: TextStyle(color: Color.fromRGBO(75, 87, 123, 1)),
              ),
            ),
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
                // height: _screenSize.height,
                // width: _screenSize.width* 0.4,
                child: _getInputField(isPortrait: false),
              ),
              SizedBox(height: 40,),
              _getTimerText,
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                child: Text(
                  "SMS vasitəsilə göndərilən təsdiq kodunu daxil edin", 
                  style: TextStyle(color: Color.fromRGBO(75, 87, 123, 1)),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: _screenSize.height,
          width: _screenSize.width * 0.5,
          child: _getOtpKeyboard(isPortrait: false),
        )
        
      ]
    );
  }

  get _getTimerText {
    return Container(
      decoration: new BoxDecoration(
          border: new Border.all(
            width: 1,
            color: Color.fromRGBO(113, 142, 232, 1),
          ),
          borderRadius: new BorderRadius.circular(30)),
      padding: new EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: new Offstage(
        offstage: false, //!_hideResendButton,
        child: OtpTimer(
          _controller,
          22.0,
          Color.fromRGBO(75, 87, 123, 1),
        ),
      ),
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
        // TODO: Resend you OTP via API
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
                      label: Text(
                          "İmtina",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24
                          ),
                        ),
                        isPortrait: isPortrait,
                      onPressed: () {
                        Navigator.of(context).pop();
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
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    accountNotifier = Provider.of<AccountNotifier>(context);

    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
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

  Future<Null> _startCountdown() async {
    setState(() {
      // _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  Future<Null> _restartCountdown() async {
    setState(() {
      // _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reset();
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void _setCurrentDigit(int i){
    if (_pinController.text.length < 4) {
      _pinController.text += i.toString();
    }
    if(_pinController.text.length == 4){
      validateOTPCode();
    }
  }


  void validateOTPCode() async{
    widget.dto.recaptchaToken = "";
    widget.dto.code = _pinController.text;
    var response = await _accountService.auth(widget.dto);
    if (response.isSucceded!) {
      widget.dto.authToken = response.result!.token.toString();
      if(widget.dto.rememberMe!){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
            LoginCodePage(dto: widget.dto),
          )
        );
      }else{
        accountNotifier.authDTO = widget.dto;
        debugPrint("\n\nNew Token Retrieved --> " + response.result!.token.toString() +"\n\n");
        Navigator.of(context).pop();
      }
    }else{
      var length = _pinController.text.length;
        if (length > 0) {
          _pinController.text =
              _pinController.text.substring(0, length - 4);
        }
    }
    mapAndShowToast(response);
  }

  void mapAndShowToast(AuthResponse response){
    if(response.isSucceded == null){
      QuickToast.showToast(message: "Server Hətasi", awarenessLevel: AwarenessLevel.ERRROR);
    }
    else if(response.isError!){
      QuickToast.showToast(message: response.errorMessage!, awarenessLevel: AwarenessLevel.ERRROR);
    }
  }
}
