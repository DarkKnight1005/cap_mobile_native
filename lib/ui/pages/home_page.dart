// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cap_mobile_native/Globals/fileConsts.dart';
import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:cap_mobile_native/models/locals/FilterData.dart';
import 'package:cap_mobile_native/models/locals/periodDropDownItem.dart';
import 'package:cap_mobile_native/models/locals/profileDropDownItem.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/custom_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/DialogWidgets/filter_alertDialog.dart';
import 'package:cap_mobile_native/ui/widgets/logo_button.dart';
import 'package:cap_mobile_native/ui/widgets/profile_button.dart';
import 'package:flutter/foundation.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cap_mobile_native/models/DTOs/auth_dto.dart';
import 'package:cap_mobile_native/notifiers/account_notifier.dart';
import 'package:cap_mobile_native/notifiers/areaselection_notifier.dart';
import 'package:cap_mobile_native/notifiers/homePage_notifier.dart';
import 'package:cap_mobile_native/services/API/account_service.dart';
import 'package:cap_mobile_native/services/API/file_download_service.dart';
import 'package:cap_mobile_native/ui/widgets/area_selection.dart';
import 'package:cap_mobile_native/ui/widgets/backRoundButton.dart';
import 'package:cap_mobile_native/ui/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';
import 'package:after_layout/after_layout.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage>{


  late AccountNotifier accountNotifier;
  late AreaSelectionNotifier areaSelection;
  InAppWebViewController? _webViewController;
  CrossFadeState _crossFadeState = CrossFadeState.showSecond;
  Timer? _timer;
  Timer? _timerPeriodic;

  late List<AreaSelectionData> areaSelectionDatas;
  late List<ProfileDropDownItem> profileDropDownItems;
  late List<PeriodDropDownItem> periodDropDownItems;

  @override
  void initState() { 
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    profileDropDownItems = [
      ProfileDropDownItem(title: "Şəxsi kabinet", onSelected: () => onPersonalCabinetSelected()),
      ProfileDropDownItem(title: "Çıxış", onSelected: () => onExitSelected()),
    ];

    areaSelectionDatas = [
      AreaSelectionData(title: "Tədbirlər planı", selectionType: SelectionType(buttonType: ButtonType.BUTTON)),
      AreaSelectionData(title: "Göstəricilər", selectionType: SelectionType(buttonType: ButtonType.BUTTON)),
      AreaSelectionData(title: "Hesabatlar", selectionType: SelectionType(buttonType: ButtonType.DROPDOWN, 
      subsections: ["Mənfəət və zərər hesabatı", "Balans hesabatı", "Pul vəsaitlərinin hərəkəti", "Kapitalda dəyişikliklər", "Əsas investisiya layihələri", "Dövlət büdcəsindən daxilolmalar"])),
      AreaSelectionData(title: "Sənədlər", selectionType: SelectionType(buttonType: ButtonType.DROPDOWN, 
      subsections: ["Fayllar", "Audit hesabatları"])),
    ];
    
    periodDropDownItems = [
      PeriodDropDownItem(title: "Aylıq", periodType: PeriodType.MONTHLY ,isSelectable: true),
      PeriodDropDownItem(title: "Rüblük", periodType: PeriodType.QUARTERLY, isSelectable: true),
      PeriodDropDownItem(title: "İllik", periodType: PeriodType.YEARLY, isSelectable: true),
    ];
  }

  @override
  void afterFirstLayout(BuildContext context) {
      
  }

  Future<String> _createFileFromString(String encodedStr, String fileExtension) async { //TODO: create file handler class
    // final encodedStr = "put base64 encoded string here";
    Uint8List bytes = base64.decode(encodedStr);
    String dir = "";
    if(Platform.isAndroid){
      dir = "/storage/emulated/0/Download";
    }else{
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    debugPrint("Dir To Save --> " + dir);
    File file = File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + fileExtension);
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> _handlePermissons() async{ //TODO: create permission hadler class
    if(await SuperEasyPermissions.isGranted(Permissions.storage)){
      await SuperEasyPermissions.askPermission(Permissions.storage);
    }
  }

  void onExitSelected(){
    accountNotifier.doLogOut();
  }

  void onPersonalCabinetSelected(){

  }

  void onLogoTapped(){
    FilterAlertDialog(
      dropDownItemsCompany: ["ASCO - “Azərbaycan Xəzər Dəniz Gəmiçiliyi” QSC"],
      dropDownItemsPeriod: periodDropDownItems
    ).showCustomAlertDialog(
      context: context, 
      applyText: "Tətbiq et",
      onApply: (filterData){
        FilterData _filterData = filterData as FilterData;
        debugPrint("FilterData --> " + _filterData.toJson().toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    accountNotifier = Provider.of<AccountNotifier>(context);
    areaSelection = Provider.of<AreaSelectionNotifier>(context);

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(232, 237, 247, 1),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ChangeNotifierProvider<HomePageNotifier>(
                  create: (context) => HomePageNotifier(),
                  builder: (context, wg) => Consumer<HomePageNotifier>(
                    builder: (context, notifier, wg) =>
                Stack(
                  children: [
                  Container(
                    child: Container(
                      color: Color.fromRGBO(232, 237, 247, 1),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top,
                            ),
                            padding: EdgeInsets.only(
                              top: 10,
                              left: 21,
                              right: 21,
                            ),
                            height: 70,//MediaQuery.of(context).size.height * 0.15,
                            color: Colors.white,
                            child: Row(
                              children: [
                                LogoButton(logoPath: 'assets/socar.svg', onTap: () => onLogoTapped()),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: AreaSelection(
                                      areaSelectionDatas: areaSelectionDatas,
                                    onSearchTabChange: (selection) {
                                      debugPrint("Selected Tab --> " + selection);
                                    }),
                                  ),
                                  Expanded(child: Container()),
                                  ProfileButton(
                                    initials: "AP", 
                                    profileDropDownItems: profileDropDownItems
                                  ),
                              ],
                            ),
                          ),
                        ]
                      )
                    )
                  ),
                  notifier.loadedStatus
                  ? Container(height: 0, width: 0)
                  : Container(
                    color: Colors.white,
                    child: Center(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                    ),
                  ),

                  ], 
                ),
                  )
                )
              ),
            )
          ],
        ),
      )
    );
  }
}
