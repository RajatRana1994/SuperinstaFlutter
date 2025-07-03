import 'package:flutter/material.dart';

class GetCurrencyWidget extends StatelessWidget {
  final double radius;
  final double fontSize;
  const GetCurrencyWidget({super.key, this.radius = 8, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.orange,
      child: Text(
        '₦',
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
