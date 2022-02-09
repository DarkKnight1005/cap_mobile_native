import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {

  /// This widget must be used inside Stack widget directly, otherwise "Direct Ancestor Error" will be thrown
  /// 
  /// Example:
  /// ```
  /// Stack(
  ///   children: [
  ///     Container(
  ///       height: 50,
  ///       width: 50,
  ///       child: Placeholder()
  ///     ),
  ///     ChildWidget(), //Everything is okay, child's direct parent is Stack
  ///     Container(
  ///       height: 50,
  ///       width: 50,
  ///       child: ChildWidget(), // Run-time error, because direct ansector is Container, instead of Stack.
  ///    ),
  ///   ],
  /// )
  /// ```

  CustomBanner({ Key? key , this.text = ""}) : super(key: key); 

  final String text;
  final String directAnsector = "Stack";

  @override
  Widget build(BuildContext context) {

    context.visitAncestorElements((element) {
      assert(element.widget.runtimeType.toString().toLowerCase() == directAnsector.toLowerCase(), "Direct Ancestor Error");
      return false;
    });

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.only(top: 45, right: 45),
        child: Banner(
          message: text,
          location: BannerLocation.bottomStart,
        ),
      ),
    );
  }
}