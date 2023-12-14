import 'package:flutter/material.dart';

class RestartButton extends StatelessWidget{
  const RestartButton({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: MaterialButton(
        onPressed: (){

        },
        minWidth: 300,
        child: Text(
          text,
        ),
      ),
    );
  }
}



class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        child: Icon(
          icon,
          size: 36,
          color: Colors.grey[850],
        ),
      ),
    );
  }
}