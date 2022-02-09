import 'package:cap_mobile_native/ui/widgets/DropDowns/customDropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TitledDropDown extends StatelessWidget {

  final String title;
  final String? initialValue;
  final List<String> dropDownItems;
  final List<bool>? isSelectable;
  final Function(String selectedTabName, int index) onChange; 

  final double? fieldWidth;
  final double? fieldHeigh;
  final double? widthPadding;

  const TitledDropDown({ Key? key, required this.title, this.initialValue, required this.dropDownItems, required this.onChange, this.widthPadding, this.fieldWidth, this.fieldHeigh, this.isSelectable}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.title,
              style: TextStyle(
                color: Color.fromRGBO(75, 87, 123, 1),
                fontFamily: "SF Pro Medium",
                fontWeight: FontWeight.w400,
                fontSize: 18
              ),
            ),
            Container(
              // width: fieldWidth != null ? (fieldWidth! - 100) : 100,
              child: CustomDropdown<String>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: widthPadding != null ? (fieldWidth != null ? fieldWidth! - (widthPadding ?? 0) : null) : null,
                      child: Text(
                        initialValue == null
                        ? dropDownItems[0]
                        : initialValue!,
                        style: TextStyle(
                          color: Color.fromRGBO(75, 87, 123, 1),
                            fontFamily: "SF Pro Medium",
                            fontWeight: FontWeight.w400,
                            fontSize: 18
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                onChange: (String value, int index) {
                  onChange(value, index);
                },
                dropdownButtonStyle: DropdownButtonStyle(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  width: this.fieldWidth ?? double.infinity,
                  height: this.fieldHeigh ?? 45,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  primaryColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1,
                  ),
                  
                  ),
                ),              
                dropdownStyle: DropdownStyle(
                  borderRadius: BorderRadius.circular(4),
                  elevation: 1,
                  color: Colors.white,
                  padding: EdgeInsets.all(0),
                  offset: Offset(0, -10),
                ),
                items: dropDownItems
                  .asMap()
                  .entries
                  .map(
                    (item) => DropdownItem<String>(
                  value: item.value,
                  isSelectable: isSelectable != null ? isSelectable![item.key] : true,
                  child: Container(
                    width: widthPadding != null ? (fieldWidth != null ? fieldWidth! - (widthPadding ?? 0) : null) : null,
                    child: Text(
                        item.value,
                        style: TextStyle(
                        color: (isSelectable != null ? isSelectable![item.key] : true)
                        ? Color.fromRGBO(75, 87, 123, 1)
                        : Color.fromRGBO(143, 153, 185, 1),
                          fontFamily: "SF Pro Medium",
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}