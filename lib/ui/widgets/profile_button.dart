import 'package:cap_mobile_native/models/locals/profileDropDownItem.dart';
import 'package:cap_mobile_native/ui/widgets/DropDowns/customDropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProfileButton extends StatelessWidget {

  final String initials;
  final List<ProfileDropDownItem> profileDropDownItems;

  ProfileButton({ Key? key, required this.initials, required this.profileDropDownItems}) : super(key: key);

  final GlobalKey<CustomDropdownState<ProfileDropDownItem>> customDropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    // RenderBox renderBox = context.findRenderObject() as RenderBox;
    // var size = renderBox.size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        child: GestureDetector(
          onTap: (){
            customDropdownKey.currentState!.toggleDropdown();
          },
          child: Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Color.fromRGBO(65, 105, 225, 1),
                child: Text(
                  this.initials, 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                    ),
                )
              ),
              CustomDropdown<ProfileDropDownItem>(
                    key: customDropdownKey,
                    child: Text(
                      "",
                    ),
                    onChange: (ProfileDropDownItem value, int index) {
                      debugPrint("ProfileButton value --> " + value.title);
                      value.onSelected();
                    },
                    dropdownButtonStyle: DropdownButtonStyle(
                      width: 0,
                      height: 32,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      primaryColor: Colors.white,
                      shape: 
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    ),     
                    hideIcon: true,         
                    hideButton: true,
                    dropdownStyle: DropdownStyle(
                      borderRadius: BorderRadius.circular(4),
                      elevation: 1,
                      color: Colors.white,
                      padding: EdgeInsets.all(0),
                      offset: Offset(-100, 8),
                      width: 150,
                    ),
                    items: profileDropDownItems
                        .asMap()
                        .entries
                        .map(
                          (item) => DropdownItem<ProfileDropDownItem>(
                        value: item.value,
                        child: Text(
                            item.value.title,
                            style: TextStyle(
                            color: Color.fromRGBO(75, 87, 123, 1),
                              fontFamily: "SF Pro Medium",
                              fontWeight: FontWeight.w400,
                              fontSize: 20
                              ),
                          ),
                        ),
                    )
                        .toList(),
                  ),
            ],
          ),
        )
      ),
    );
  }
}