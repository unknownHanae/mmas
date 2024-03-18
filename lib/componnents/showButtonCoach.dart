import 'package:flutter/material.dart';

class ShowButtonCoach extends StatelessWidget {
  ShowButtonCoach({Key? key, required this.onPressed, required this.msg}) : super(key: key);

  VoidCallback onPressed;
  String msg ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Tooltip(
        message: msg,
        decoration: BoxDecoration(
          color: Colors.blue, // Couleur de fond du tooltip
          borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
        ),
        child: Container(
          height: 18,
          width: 25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent)
          ),
          child: Center(
            child: Icon(Icons.remove_red_eye, size: 10, color: Colors.blueAccent),
          ),
        ),
      ),
    );

  }
}
