import 'package:flutter/material.dart';


import '../utils/app_colors.dart';

class SmallToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;

  const SmallToggleSwitch({
    super.key,
    this.initialValue = false,
    required this.onChanged,
    this.width = 25,
    this.height = 16,
  });

  @override
  State<SmallToggleSwitch> createState() => _SmallToggleSwitchState();
}

class _SmallToggleSwitchState extends State<SmallToggleSwitch> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final double circleSize = widget.height - 4;

    return GestureDetector(
      onTap: () {
        setState(() => _isOn = !_isOn);
        widget.onChanged(_isOn);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _isOn ? AppColors.darkGreen : Colors.grey[400],
          borderRadius: BorderRadius.circular(widget.height),
        ),
        child: Align(
          alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
