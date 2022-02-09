import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:cap_mobile_native/notifiers/areaselection_notifier.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/customDropdown.dart';
import 'package:cap_mobile_native/ui/widgets/areaselection_button.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/areaselection_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaSelection extends StatelessWidget {
  final List<AreaSelectionData> areaSelectionDatas;
  final Function(String tabName) onSearchTabChange;
  AreaSelection({
    required this.areaSelectionDatas,
    required this.onSearchTabChange,
  });

  // final GlobalKey<CustomDropdownState> customDropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final List<Widget> tabButtons = []..length = 0;

    final AreaSelectionNotifier selectionNotifier =
        new AreaSelectionNotifier(selectedTab: areaSelectionDatas[0]);
    selectionNotifier.addListener(() {
      if(selectionNotifier.currentSelectedSubcategory != null){
        onSearchTabChange(selectionNotifier.currentSelectedSubcategory!);
      }else{
        onSearchTabChange(selectionNotifier.selectedTab!.title!);
      }
    });
    
    areaSelectionDatas.forEach((_areaSelectionData) {
      // globalKeys.add(new GlobalKey());
      tabButtons.add(
        ChangeNotifierProvider.value(
          value: selectionNotifier,
          child: 
          _areaSelectionData.selectionType!.buttonType == ButtonType.BUTTON
          ? AreaSelectionButton(areaSelectionData: _areaSelectionData)
          : AreaSelectionDropdown(areaSelectionData: _areaSelectionData)
        ),
      );
    });
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.0,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tabButtons,
        ),
      ),
    );
  }
}
