import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  const UIButton(this.context, this.text, this.onPressed, {super.key});
  final BuildContext context;
  final String text;
  final Function() onPressed;
  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Thay đổi màu của nút theo sở thích của bạn.
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
