import 'package:flutter/material.dart';
import 'package:NCKH/screen/signup_screen.dart';

class SignUpOption extends StatelessWidget {
  const SignUpOption(this.textButton, this.onPressed, {super.key});
  final String textButton;
  final onPressed;
  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => onPressed));
          },
          child: Text(
            textButton,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
