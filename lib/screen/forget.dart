import 'package:flutter/material.dart';
import 'package:NCKH/screen/reset_screen.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword(this.context, {super.key});
  final BuildContext context;
  @override
  Widget build(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Quên mật khẩu?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResetPassword()));
        },
      ),
    );
  }
}
