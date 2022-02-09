import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(color: Color.fromRGBO(65, 105, 225, 1),),
          ),
      ),
    );
  }
}