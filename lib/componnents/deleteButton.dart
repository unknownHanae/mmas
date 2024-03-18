import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  DeleteButton({Key? key, required this.onPressed, required this.msg}) : super(key: key);

  VoidCallback onPressed;
  String msg ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Tooltip(
        message: msg,
        // decoration: BoxDecoration(
        //   color: Colors.blue, // Couleur de fond du tooltip
        //   borderRadius: BorderRadius.circular(8.0), // Optionnel : coins arrondis
        // ),
        child: Container(
          // height: 28,
          // width: 35,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          //   border: Border.all(color: Colors.red)
          // ),
          child: Center(
            child: Icon(Icons.delete, size: 20, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
