import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final Function() onTap;
  const FilterButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: Container(
        padding: new EdgeInsets.symmetric(vertical: 19),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            new Text(
              'Filter',
              style: new TextStyle(
                color: Color.fromRGBO(75, 87, 123, 1),
                fontSize: 18,
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 11),
              child: new Icon(
                Icons.filter_list_sharp,
                size: 24,
                color: Color.fromRGBO(75, 87, 123, 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
