import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({super.key});

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final text = _controller.text;
      if (!text.startsWith('-')) {
        _controller.value = TextEditingValue(
          text: '-$text',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: AppColors.bankItemBackground,
      child: Center(
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '-0',
                    hintStyle: TextStyle(
                      fontSize: 32,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '€',
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xFF004D40),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
