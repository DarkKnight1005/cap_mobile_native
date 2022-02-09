import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:flutter/material.dart';

class AreaSelectionNotifier extends ChangeNotifier {
  AreaSelectionData? selectedTab;
  String? selectedSubCategory;
  Map<String, String> selectedOfSubcategory = {};

  AreaSelectionNotifier({
    this.selectedTab,
    this.selectedSubCategory
  });

  set updateSelectedTab(AreaSelectionData tab) {
    selectedTab = tab;
    notifyListeners();
  }

  AreaSelectionData? get currentSelectedTab => selectedTab;

  void updateSelectedSubcategory(String? title, String? tab) {
    selectedSubCategory = tab;
    if(tab != null && title != null){
      selectedOfSubcategory[title] = tab;
    }
  }

  String? get currentSelectedSubcategory => selectedSubCategory;

  String selectedSubcategoryOf(String title){
    return selectedOfSubcategory[title] ?? "NONE";
  }

  void doNotify(){
    notifyListeners();
  }
}
