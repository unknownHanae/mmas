import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  String title;
  LabelText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.blueAccent
          ),
        ),
      ),
    );
  }
}
