import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  final String applyText;
  final Function() onApply;

  const ActionButton({
     Key? key,
     required this.applyText, 
     required this.onApply
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onApply,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Color.fromRGBO(65, 105, 225, 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            applyText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, 
              fontWeight: FontWeight.w400
            ),
          ),
        )
      ),
    );
  }
}