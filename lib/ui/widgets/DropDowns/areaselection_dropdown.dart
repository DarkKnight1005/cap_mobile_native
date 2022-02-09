import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:cap_mobile_native/notifiers/areaselection_notifier.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/customDropdown.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaSelectionDropdown extends StatelessWidget {

  Key? key;
  final AreaSelectionData areaSelectionData;

  AreaSelectionDropdown({
    this.key,
    required this.areaSelectionData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AreaSelectionNotifier>(
      builder: (context, info, _) {
        return Container(
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: IntrinsicWidth(
            stepWidth: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                    right: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CustomDropdown<String>(
                      key: key,
                      child: Text(
                        this.areaSelectionData.title!,
                        style: TextStyle(
                          color: info.selectedTab == this.areaSelectionData
                                ? Color.fromRGBO(65, 105, 225, 1)
                                : Color.fromRGBO(75, 87, 123, 1),
                            fontFamily: "SF Pro Medium",
                            fontWeight: FontWeight.w400,
                            fontSize: 20
                        ),
                      ),
                      onChange: (String value, int index) {
                        info.updateSelectedSubcategory(this.areaSelectionData.title!, value);
                        info.updateSelectedTab = this.areaSelectionData; 
                      },
                      isSelected: info.selectedTab == this.areaSelectionData,
                      dropdownButtonStyle: DropdownButtonStyle(
                        width: info.selectedSubcategoryOf(areaSelectionData.title!).length > 9 ? info.selectedSubcategoryOf(areaSelectionData.title!).length * 13 : 140,
                        height: 26,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        primaryColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)
                        ),
                      ),              
                      dropdownStyle: DropdownStyle(
                        borderRadius: BorderRadius.circular(4),
                        elevation: 1,
                        color: Colors.white,
                        padding: EdgeInsets.all(0),
                      ),
                      items: this.areaSelectionData.selectionType!.subsections!
                          .asMap()
                          .entries
                          .map(
                            (item) => DropdownItem<String>(
                          value: item.value,
                          child: Text(
                              item.value,
                              style: TextStyle(
                              color: info.selectedTab == this.areaSelectionData
                                    ? Color.fromRGBO(65, 105, 225, 1)
                                    : Color.fromRGBO(75, 87, 123, 1),
                                fontFamily: "SF Pro Medium",
                                fontWeight: FontWeight.w400,
                                fontSize: 20
                               ),
                            ),
                          ),
                      )
                          .toList(),
                    ),
                  ),
                ),
                Container(
                  height: 14,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: info.selectedTab == this.areaSelectionData
                            ? Color.fromRGBO(65, 105, 225, 1)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
