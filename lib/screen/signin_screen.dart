import 'package:NCKH/main_screen.dart';
import 'package:NCKH/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:NCKH/screen/home_screen.dart';
import 'package:NCKH/screen/reset_screen.dart';
import 'package:NCKH/screen/signup_screen.dart';
import 'package:NCKH/utils/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  static Color hexStringToColor(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

 void onLoginSuccess() {
  // Chuyển hướng về màn hình chính (MainScreen) sau đăng nhập thành công.
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => MainScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                _reusableTextField(
                  "Nhập Email",
                  Icons.email,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                _reusableTextField(
                  "Nhập Mật khẩu",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 5,
                ),
                _forgetPassword(context),
                _firebaseUIButton(context, "Đăng nhập", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                     .then((value) {

  onLoginSuccess();
}).catchError((error) {
  print("Lỗi ${error.toString()}");
});

                }),
                _signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reusableTextField(
    String hintText,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _forgetPassword(BuildContext context) {
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword ()));
        },
      ),
    );
  }

  Widget _signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Chưa có tài khoản?", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Đăng ký",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _firebaseUIButton(BuildContext context, String text, void Function() onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Thay đổi màu của nút theo sở thích của bạn.
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
