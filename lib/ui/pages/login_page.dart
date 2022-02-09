import 'dart:io';
import 'dart:ui';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/models/responses/auth_response.dart';
import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/services/API/account_service.dart';
import 'package:cap_mobile_native/ui/pages/login_code_page.dart';
import 'package:cap_mobile_native/ui/pages/otp_page.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/wifi_alerDialog.dart';
import 'package:cap_mobile_native/ui/widgets/cap_textfield.dart';
import 'package:cap_mobile_native/ui/widgets/quick_toast.dart';
import 'package:cap_mobile_native/ui/widgets/wifiListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CrossFadeState _crossFadeState = CrossFadeState.showSecond;
  late dynamic Function()? _onLoginPressed;
  late InAppWebViewController _controller;
  final AuthDTO _dto = AuthDTO(rememberMe: false);
  late AccountNotifier accountNotifier;
  final AccountService _accountService = new AccountService();
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final FocusNode loginFocusNode = FocusNode();
  final FocusNode passwordLoginNode = FocusNode();
  late Function()? _startLoading;
  late GlobalKey<ArgonButtonState> argon_key = GlobalKey();
  late GlobalKey checkbox_key = GlobalKey();
  late PackageInfo packageInfo;
  String version = "";

  bool isCatpchaControllerNeeded = false;
  bool isLoadStop = false;

  late Function disableCatphcaController;

  List<String> wifiNetworkNames = []..length = 0;

  @override
  void dispose() { 
    loginFocusNode.dispose();
    passwordLoginNode.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  doArgonLogin() async{
    argon_key.currentState!.animateForward();
    await _onLoginPressed!();
    argon_key.currentState!.animateReverse();
  }

  void mapAndShowToast(AuthResponse response){
    if(response.isSucceded == null){
      QuickToast.showToast(message: "Server Hətasi", awarenessLevel: AwarenessLevel.ERRROR);
    }
    else if(response.isError!){
      QuickToast.showToast(message: response.errorMessage!, awarenessLevel: AwarenessLevel.ERRROR);
      if(response.errorMessage == "Network Error"){
        WifiAlertDialog().showCustomAlertDialog(context: context);
      }
    }else if(response.isSucceded!){
      QuickToast.showToast(message: response.result!.message!, awarenessLevel: AwarenessLevel.SUCCESS);
    }
  }

  void completeLogin(){
    argon_key.currentState!.animateReverse();
    setState(() {
      _onLoginPressed = getOnLogin();
    });
  }

  getOnLogin() => () async {
        setState(() {
          _onLoginPressed = null;
          isCatpchaControllerNeeded = false;
        });

        _dto.recaptchaToken = "";
        _dto.authToken = "";
        _dto.code = "";

        var response = await _accountService.auth(_dto);
        debugPrint(response.toMap().toString());
        if (response.isSucceded!) {
          if(!response.result!.requiredConfirm!){
            _dto.authToken = response.result!.token.toString();
            if(_dto.rememberMe!){
              completeLogin();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                new LoginCodePage(dto: _dto)
              )           
            );
            }else{
              accountNotifier.authDTO = _dto;
            }
            // debugPrint("\n\nNew Token Retrieved --> " + response.result!.token.toString() +"\n\n");
          }else{
            completeLogin();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                new OtpPage(dto: _dto)
              )
            );
          }
        }else{
          setState(() {
            isLoadStop = false;
            isCatpchaControllerNeeded = false;
          });
        }
        mapAndShowToast(response);
        setState(() {
          _onLoginPressed = getOnLogin();
        });
      };

    // _disableCatphcaController() => () {
    //   setState(() {
    //     isLoadStop = false;
    //     isCatpchaControllerNeeded = false;
    //   });
    // };

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    initPackageInfo();
    // _tempGetWifList();
    _passwordController.addListener(() {
      _dto.password = _passwordController.text;
    });
    _userNameController.addListener(() {
      _dto.emailOrUsername = _userNameController.text;
    });
    _onLoginPressed = getOnLogin();

    // disableCatphcaController = _disableCatphcaController();
   
    
  }

  Future<void> initPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  Widget PortraitLogin(BuildContext context) {

    final Widget logo = SvgPicture.asset(
      'assets/logo.svg',
      width: MediaQuery.of(context).size.width * 0.75,
    );

    return  Container(
      color: Colors.transparent,
      child: new Stack(
        children: [
          // getWebView(context),
          new Container(
            color: Color.fromRGBO(232, 237, 247, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: new AnimatedCrossFade(
              firstChild: new Center(
                child: new Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
              secondChild: new Container(
                // color: Colors.red,
                width: double.infinity,
                // height: double.infinity,
                child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                          child: Column(
                            children: [
                              new Padding(
                              padding: new EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 5,
                                bottom: MediaQuery.of(context).size.height *
                                    0.061576354679803,
                              ),
                              child: logo,
                            ),
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: CAPTextField(
                                label: 'İstifadəçi Adı',
                                controller: _userNameController,
                                hintText: 'login@email.com',
                                focusNode: loginFocusNode,
                                textInputAction: TextInputAction.next,
                                onDone: (){},
                              ),
                            ),
                            new Container(
                              margin: new EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: CAPTextField(
                                label: 'Şifrə',
                                controller: _passwordController,
                                hintText: 'şifrə',
                                isPassword: true,
                                focusNode: passwordLoginNode,
                                textInputAction: TextInputAction.done,
                                  onDone: (){
                                    doArgonLogin();
                                  //  argon_key.currentState!.animateForward();
                                  //   doArgonLogin();
                                  },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.78,
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Color.fromRGBO(65, 105, 225, 1),
                                      value: _dto.rememberMe,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _dto.rememberMe = newValue!;
                                        });
                                      },
                                    ),
                                    Text("Yadda saxla", style: TextStyle(color: Color.fromRGBO(75, 87, 123, 1), fontSize: 16),)
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: new EdgeInsets.only(top: 20),
                              // width: MediaQuery.of(context).size.width * 0.75,
                              // height: 45,
                              child: ArgonButton(
                                  key: argon_key,
                                  elevation: 0,
                                  focusElevation: 0,
                                  hoverElevation: 0,
                                  disabledElevation: 0,
                                  highlightElevation: 0,
                                  height: 45,
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  borderRadius: 5.0,
                                  color: Colors.blue,
                                  child: Text(
                                    "Daxil Ol",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700
                                  ),
                                  ),
                                  loader: Container(
                                    height: 45,
                                    width: 45,
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      // size: loaderWidth ,
                                    ),
                                  ),
                                  onTap: (startLoading, stopLoading, btnState){
                                    doArgonLogin();
                                  }, 
                                ) 
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Container(
                              child: Text(
                                "Ver. ${version} Beta",
                                style: TextStyle(color: Color.fromRGBO(75, 87, 123, 1)),//Color.fromRGBO(65, 105, 225, 1),),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              crossFadeState: _crossFadeState,
              duration: new Duration(milliseconds: 80),
            ),
          )
        ],
      ),
    );
  }

  Widget LandscapeLogin(BuildContext context) {

    final Widget logo = SvgPicture.asset(
      'assets/logo.svg',
      width: MediaQuery.of(context).size.height * 0.35,
    );

    return  Row(
      children: [
        Container(
          color: Colors.transparent,
          child: Container(
            color: Color.fromRGBO(232, 237, 247, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.45,
            child: new AnimatedCrossFade(
              firstChild: new Center(
                child: new Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
              secondChild: new Center(
                child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Padding(
                        padding: new EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 5,
                          bottom: MediaQuery.of(context).size.height *
                              0.061576354679803,
                        ),
                        child: logo,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: CAPTextField(
                          label: 'İstifadəçi Adı',
                          controller: _userNameController,
                          hintText: 'login@email.com',
                          focusNode: loginFocusNode,
                          textInputAction: TextInputAction.next,
                          onDone: (){},
                        ),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * 0.32,
                        child: CAPTextField(
                          label: 'Şifrə',
                          controller: _passwordController,
                          hintText: 'şifrə',
                          isPassword: true,
                          focusNode: passwordLoginNode,
                          textInputAction: TextInputAction.done,
                            onDone: (){
                              doArgonLogin();
                            //  argon_key.currentState!.animateForward();
                            //   doArgonLogin();
                            },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.34,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: Color.fromRGBO(65, 105, 225, 1),
                                value: _dto.rememberMe,
                                onChanged: (newValue) {
                                  setState(() {
                                    _dto.rememberMe = newValue!;
                                  });
                                },
                              ),
                              Text("Yadda saxla", style: TextStyle(color: Color.fromRGBO(75, 87, 123, 1), fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(top: 20),
                        // width: MediaQuery.of(context).size.width * 0.75,
                        // height: 45,
                        child: ArgonButton(
                            key: argon_key,
                            elevation: 0,
                            focusElevation: 0,
                            hoverElevation: 0,
                            disabledElevation: 0,
                            highlightElevation: 0,
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.32,
                            borderRadius: 5.0,
                            color: Colors.blue,
                            child: Text(
                              "Daxil Ol",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700
                            ),
                            ),
                            loader: Container(
                              height: 45,
                              width: 45,
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                // size: loaderWidth ,
                              ),
                            ),
                            onTap: (startLoading, stopLoading, btnState){
                              doArgonLogin();
                            },
                          ) 
                        ),
                    ],
                  ),
                ),
              ),
              crossFadeState: _crossFadeState,
              duration: new Duration(milliseconds: 80),
            ),
          )
        ),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.55,
              height: MediaQuery.of(context).size.height,
              child: Image.asset('assets/login-bg.png', fit: BoxFit.fill,),
            ),
            Positioned(
              bottom: 5,
              right: 10,
              child: Text(
                "Ver. ${version} Beta",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    accountNotifier = Provider.of<AccountNotifier>(context);

    return new Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
          ? PortraitLogin(context)
          : LandscapeLogin(context);//PortraitLogin(context);
        },
      ),
      
    );
  }
}
