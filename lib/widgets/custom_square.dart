import 'package:flutter/material.dart';

class CustomSquare extends StatelessWidget {
  final Color color;

  const CustomSquare({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      alignment: Alignment.center,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color,
      ),
      //  margin: const EdgeInsets.only(right: 12),
    );
    ;
  }
}

