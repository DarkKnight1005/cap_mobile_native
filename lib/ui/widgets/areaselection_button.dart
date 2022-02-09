import 'package:cap_mobile_native/models/locals/AreaSelectionData.dart';
import 'package:cap_mobile_native/notifiers/areaselection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaSelectionButton extends StatelessWidget {
  final AreaSelectionData areaSelectionData;

  AreaSelectionButton({
    required this.areaSelectionData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AreaSelectionNotifier>(
      builder: (context, info, _) {
        return new GestureDetector(
          onTap: () {
            if (info.selectedTab != this.areaSelectionData) {
              info.updateSelectedSubcategory(null, null);
              info.updateSelectedTab = this.areaSelectionData;
            }
          },
          child: new Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: new BoxDecoration(
              color: Colors.transparent,
            ),
            child: IntrinsicWidth(
              stepWidth: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new Padding(
                    padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: new Text(
                        areaSelectionData.title!,
                        style: new TextStyle(
                            color: info.selectedTab == this.areaSelectionData
                                ? Color.fromRGBO(65, 105, 225, 1)
                                : Color.fromRGBO(75, 87, 123, 1),
                            fontFamily: "SF Pro Medium",
                            fontSize: 20),
                      ),
                    ),
                  ),
                  new Container(
                    height: 14,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: new Container(
                      decoration: new BoxDecoration(
                        border: new Border.all(
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
          ),
        );
      },
    );
  }
}
