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
      child: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
          text,
        ),
        )
        
      ),
    );
  }
}



class RoundButtonLeft extends StatelessWidget {
  const RoundButtonLeft({
    Key? key,
    required this.icon,
    required this.clicked,
    required this.size
  }) : super(key: key);
  final IconData icon;
  final bool clicked;
  final double size; 

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      height: size,
      width: size < 50 ? size*2 : size*3,
      decoration: BoxDecoration(
        color: clicked ? Colors.orange.withOpacity(0.6) : Colors.grey[850],
        border: Border.all(color: Colors.orange),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), 
          bottomLeft: Radius.circular(25)
        ),
      ),
      child: Icon(
        icon,
        size: size-10,
        color: clicked ? Colors.grey[850] : Colors.grey,
      ),
    );
  }
}

class RoundButtonRight extends StatelessWidget {
  const RoundButtonRight({
    Key? key,
    required this.icon,
    required this.clicked,
    required this.size
  }) : super(key: key);
  final IconData icon;
  final bool clicked;
  final double size; 

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      height: size,
      width: size < 50 ? size*2 : size*3,
      decoration: BoxDecoration(
        color: clicked ? Colors.orange.withOpacity(0.6) : Colors.grey[850],
        border: Border.all(color: Colors.orange),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25), 
          bottomRight: Radius.circular(25)
        ),
      ),
      child: Icon(
        icon,
        size: size-10,
        color: clicked ? Colors.grey[850] : Colors.grey,
      ),
    );
  }
}