import 'package:cap_mobile_native/notifiers/passwordvisibility_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CAPTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool needAutoFocus;
  final String label;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function onDone;

  CAPTextField({
    required this.hintText,
    required this.controller,
    required this.label,
    required this.focusNode,
    required this.textInputAction,
    required this.onDone,
    this.isPassword = false,
    this.needAutoFocus = false,
  });
  @override
  Widget build(BuildContext context) {
    return new ChangeNotifierProvider<PasswordVisibilityNotifier>(
      create: (context) => new PasswordVisibilityNotifier(),
      builder: (context, wg) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Padding(
            padding: new EdgeInsets.only(bottom: 8),
            child: new Text(
              this.label,
              style: new TextStyle(
                color: Color.fromRGBO(75, 87, 123, 1),
                fontSize: 18,
              ),
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.white,
            ),
            child: new Consumer<PasswordVisibilityNotifier>(
              builder: (context, notifier, wg) => TextField(
                autocorrect: false,
                controller: controller,
                obscureText: isPassword ? !notifier.isVisible : false,
                textInputAction: textInputAction,
                focusNode: focusNode,
                autofocus: needAutoFocus,
                onSubmitted: (_text){
                  onDone();
                },
                decoration: InputDecoration(
                  suffixIcon: isPassword
                      ? new GestureDetector(
                          onTap: () {
                            notifier.updateVisibility();
                          },
                          child: Icon(
                            notifier.isVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        )
                      : new Icon(
                          Icons.ac_unit,
                          size: 0,
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Color.fromRGBO(142, 158, 206, 1)),
                  contentPadding: new EdgeInsets.only(
                      top: 0, bottom: 0, left: 10, right: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
