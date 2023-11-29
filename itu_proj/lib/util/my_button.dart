import 'package:flutter/material.dart';

// context color
class MyButtonSecondary extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButtonSecondary({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(text),
    );
  }
}

// orange color
class MyButtonPrimary extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  MyButtonPrimary({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.orange,
      child: Text(text),
    );
  }
}