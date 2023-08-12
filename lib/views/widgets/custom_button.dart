import 'package:flutter/material.dart';

import '../../values.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 48,
      decoration: const BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 26, 26, 26)),
          ),
        ),
      ),
    );
  }
}
