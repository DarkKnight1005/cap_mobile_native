import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';

class LogoButton extends StatelessWidget {

  final String logoPath;
  final Function() onTap;

  const LogoButton({ Key? key, required this.logoPath, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SvgPicture.asset(
            this.logoPath,//
            width: MediaQuery.of(context).size.width * 0.13,
          ),
        ),
      ),
    );
  }
}