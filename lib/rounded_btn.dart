import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton(
      {required this.colour, required this.title, required this.onPressed2});
  final Color colour;
  final String title;
  final Function() onPressed2;

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: widget.colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: widget.onPressed2,  // Remove the parentheses here
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
