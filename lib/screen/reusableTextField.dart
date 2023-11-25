import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  const ReusableTextField(
      this.hintText, this.icon, this.isPassword, this.controller,
      {super.key});
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
